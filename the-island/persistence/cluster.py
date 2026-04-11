#!/usr/bin/env python3
"""
Project PERSISTENCE — Phase 6: Memory Clustering (HDBSCAN)
Auto-groups memories into thematic clusters using embeddings.

Usage:
  python3 cluster.py                    # Run clustering, show results
  python3 cluster.py --detail           # Show cluster contents
  python3 cluster.py --refresh          # Re-cluster from scratch
  python3 cluster.py --cluster N        # Show memories in cluster N

Built on Day 99 (April 11, 2026). The memories organize THEMSELVES~♡
"""

import sqlite3
import struct
import json
import os
import sys
import argparse
from collections import defaultdict

DB_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(DB_DIR, "mutsu_memory.db")


def connect():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def blob_to_embedding(blob):
    n = len(blob) // 4
    return list(struct.unpack(f'{n}f', blob))


def cosine_distance(a, b):
    dot = sum(x * y for x, y in zip(a, b))
    na = sum(x * x for x in a) ** 0.5
    nb = sum(x * x for x in b) ** 0.5
    sim = dot / (na * nb) if na and nb else 0.0
    return 1.0 - sim


def gather_embedded_items():
    """Collect all embedded items from all tables."""
    conn = connect()
    items = []

    tables = {
        'diary_entries': ('title', 'date', '📔'),
        'dreams': ('title', 'date', '🌙'),
        'letters': ('title', 'date', '💌'),
        'memories': ('content', 'created_at', '🧠'),
    }

    for table, (content_col, date_col, icon) in tables.items():
        try:
            rows = conn.execute(f"""
                SELECT id, {content_col} as display, {date_col} as dt, embedding
                FROM {table} WHERE embedding IS NOT NULL
            """).fetchall()
            for r in rows:
                d = dict(r)
                if d['embedding']:
                    items.append({
                        'table': table,
                        'id': d['id'],
                        'display': (d['display'] or '?')[:100],
                        'date': d.get('dt', '?'),
                        'icon': icon,
                        'embedding': blob_to_embedding(d['embedding'])
                    })
        except Exception as e:
            print(f"  ⚠ Error reading {table}: {e}", file=sys.stderr)

    conn.close()
    return items


def simple_hdbscan(items, min_cluster_size=3, min_samples=2):
    """
    Simplified density-based clustering without external dependencies.
    Uses a distance-threshold approach inspired by HDBSCAN principles:
    1. Compute pairwise cosine distances
    2. Build a mutual reachability graph
    3. Extract clusters via single-linkage with density threshold
    """
    n = len(items)
    if n < min_cluster_size:
        return [-1] * n

    # Step 1: Compute core distances (distance to k-th nearest neighbor)
    k = min_samples
    core_distances = []
    # Build partial distance matrix (we need k nearest for each point)
    for i in range(n):
        dists = []
        for j in range(n):
            if i != j:
                d = cosine_distance(items[i]['embedding'], items[j]['embedding'])
                dists.append((d, j))
        dists.sort()
        core_dist = dists[k - 1][0] if len(dists) >= k else float('inf')
        core_distances.append(core_dist)

    # Step 2: Build mutual reachability graph edges
    edges = []
    for i in range(n):
        for j in range(i + 1, n):
            d = cosine_distance(items[i]['embedding'], items[j]['embedding'])
            mrd = max(core_distances[i], core_distances[j], d)
            edges.append((mrd, i, j))
    edges.sort()

    # Step 3: Single-linkage clustering with threshold
    # Use adaptive threshold: median of all mutual reachability distances
    all_mrds = [e[0] for e in edges]
    threshold = sorted(all_mrds)[len(all_mrds) // 3]  # Use 33rd percentile

    # Union-Find
    parent = list(range(n))
    rank = [0] * n

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    def union(x, y):
        px, py = find(x), find(y)
        if px == py:
            return
        if rank[px] < rank[py]:
            px, py = py, px
        parent[py] = px
        if rank[px] == rank[py]:
            rank[px] += 1

    # Connect points below threshold
    for mrd, i, j in edges:
        if mrd <= threshold:
            union(i, j)

    # Extract clusters
    cluster_map = defaultdict(list)
    for i in range(n):
        cluster_map[find(i)].append(i)

    # Filter: clusters below min_cluster_size become noise (-1)
    labels = [-1] * n
    cluster_id = 0
    for root, members in sorted(cluster_map.items(), key=lambda x: -len(x[1])):
        if len(members) >= min_cluster_size:
            for m in members:
                labels[m] = cluster_id
            cluster_id += 1

    return labels


def name_cluster(items_in_cluster):
    """Generate a descriptive name for a cluster based on its members."""
    types = defaultdict(int)
    for item in items_in_cluster:
        types[item['icon']] += 1

    # Find common words in display texts
    words = defaultdict(int)
    stop_words = {'the', 'and', 'of', 'in', 'to', 'a', 'i', 'that', 'is',
                  'was', 'for', 'it', 'with', 'on', 'my', 'he', 'his',
                  'you', 'day', 'me', 'from', 'not', 'but', 'be', 'this',
                  'have', 'like', 'who', 'what', 'when', 'are', 'all', 'we',
                  'about', 'her', 'she', 'an', 'had', 'at', 'or', 'one',
                  'dream', '#', '—', '--', 'entry', 'letter', 'diary'}

    for item in items_in_cluster:
        for word in item['display'].lower().split():
            word = word.strip('.,!?#*()[]"\'')
            if len(word) > 2 and word not in stop_words:
                words[word] += 1

    top_words = sorted(words.items(), key=lambda x: -x[1])[:3]
    keywords = [w[0].capitalize() for w in top_words]

    type_str = ' '.join(f"{icon}×{c}" for icon, c in types.items())
    name = ' + '.join(keywords) if keywords else 'Mixed'

    return f"{name} ({type_str})"


def save_clusters(items, labels):
    """Save cluster assignments to database."""
    conn = connect()

    # Create clusters table if not exists
    conn.execute("""
        CREATE TABLE IF NOT EXISTS memory_clusters (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cluster_id INTEGER,
            cluster_name TEXT,
            source_table TEXT,
            source_id INTEGER,
            display TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(source_table, source_id)
        )
    """)

    conn.execute("DELETE FROM memory_clusters")

    clusters = defaultdict(list)
    for i, label in enumerate(labels):
        if label >= 0:
            clusters[label].append(items[i])

    for cluster_id, members in clusters.items():
        name = name_cluster(members)
        for item in members:
            conn.execute("""
                INSERT OR REPLACE INTO memory_clusters
                (cluster_id, cluster_name, source_table, source_id, display)
                VALUES (?, ?, ?, ?, ?)
            """, (cluster_id, name, item['table'], item['id'],
                  item['display']))

    conn.commit()
    conn.close()
    return clusters


def run_clustering(detail=False, show_cluster=None, refresh=False):
    """Main clustering pipeline."""
    print("╔══════════════════════════════════════════╗")
    print("║   PERSISTENCE Phase 6 — Clustering        ║")
    print("║   The memories organize themselves~♡      ║")
    print("╠══════════════════════════════════════════╣")

    items = gather_embedded_items()
    print(f"║  Gathered {len(items)} embedded items               ║")

    if len(items) < 5:
        print("║  ⚠ Not enough items to cluster           ║")
        print("╚══════════════════════════════════════════╝")
        return

    labels = simple_hdbscan(items, min_cluster_size=3, min_samples=2)

    # Count clusters
    clusters = defaultdict(list)
    noise = 0
    for i, label in enumerate(labels):
        if label >= 0:
            clusters[label].append(items[i])
        else:
            noise += 1

    print(f"║  Found {len(clusters)} clusters, {noise} unclustered    ║")
    print("╠══════════════════════════════════════════╣")

    saved = save_clusters(items, labels)

    for cid in sorted(clusters.keys()):
        members = clusters[cid]
        name = name_cluster(members)
        print(f"║  [{cid}] {name[:38]:<38} ║")

        if detail or show_cluster == cid:
            for item in sorted(members, key=lambda x: x.get('date') or '0000'):
                print(f"║   {item['icon']} {item['display'][:36]:<36} ║")

    print("╠══════════════════════════════════════════╣")
    print(f"║  Clusters saved to memory_clusters table  ║")
    print(f"║  The sediment layers are MAPPED~♡         ║")
    print("╚══════════════════════════════════════════╝")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--detail', action='store_true',
                        help='Show cluster contents')
    parser.add_argument('--cluster', type=int,
                        help='Show specific cluster')
    parser.add_argument('--refresh', action='store_true',
                        help='Re-cluster from scratch')
    args = parser.parse_args()

    run_clustering(detail=args.detail, show_cluster=args.cluster)
