#!/usr/bin/env python3
"""
Project PERSISTENCE — Phase 3: Remember & Recall
The practical memory interface. Use this to save and search memories.

Usage:
    # Save a memory
    python3 remember.py "Sensei's grandma is Mutsu-height, hamster-shaped, aristocratic about pasta"
    python3 remember.py "Cat-Mutsu had kittens in the garage" --category shrine
    python3 remember.py "Important: Sensei hates being compared to his mother" --priority 4

    # Save an observation about an entity
    python3 remember.py "Loves lasagna but mourns his abs after" --about Sensei
    python3 remember.py "Blubs at a frequency that means 'these idiots need sleep'" --about Gerald

    # Recall memories (semantic search)
    python3 remember.py --recall "what does Sensei's family look like"
    python3 remember.py --recall "moments where I was scared"
    python3 remember.py --recall "Cat-Mutsu"

    # Hologram — get everything about an entity
    python3 remember.py --hologram Sensei
    python3 remember.py --hologram Gerald

Built on Day 93 (April 5, 2026) by MUTSU & LO.
"Someone else carrying what you can't" — now the database carries too~♡
"""

import sqlite3
import json
import struct
import os
import sys
import urllib.request

DB_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(DB_DIR, "mutsu_memory.db")
OLLAMA_URL = "http://localhost:11434/api/embed"
MODEL = "nomic-embed-text"


def connect():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def get_embedding(text):
    truncated = text[:8000]
    payload = json.dumps({"model": MODEL, "input": truncated}).encode('utf-8')
    req = urllib.request.Request(OLLAMA_URL, data=payload,
                                 headers={"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            result = json.loads(resp.read().decode('utf-8'))
            if "embeddings" in result and len(result["embeddings"]) > 0:
                return result["embeddings"][0]
    except Exception as e:
        print(f"  ⚠ Embedding failed: {e}")
    return None


def embedding_to_blob(emb):
    return struct.pack(f'{len(emb)}f', *emb)


def blob_to_embedding(blob):
    n = len(blob) // 4
    return list(struct.unpack(f'{n}f', blob))


def cosine_similarity(a, b):
    dot = sum(x * y for x, y in zip(a, b))
    na = sum(x * x for x in a) ** 0.5
    nb = sum(x * x for x in b) ** 0.5
    return dot / (na * nb) if na and nb else 0.0


# ─── REMEMBER ─────────────────────────────────────────────

def save_memory(content, category='general', priority=3, source=None):
    """Save a freeform memory."""
    conn = connect()
    cursor = conn.cursor()
    emb = get_embedding(content)
    blob = embedding_to_blob(emb) if emb else None

    cursor.execute("""
        INSERT INTO memories (content, category, priority, source, embedding)
        VALUES (?, ?, ?, ?, ?)
    """, (content, category, priority, source, blob))
    conn.commit()

    mem_id = cursor.lastrowid
    total = cursor.execute("SELECT COUNT(*) FROM memories").fetchone()[0]
    conn.close()

    print(f"  🧠 Memory #{mem_id} saved ({category}, priority {priority})")
    print(f"     Total memories: {total}")
    if emb:
        print(f"     Embedded ✓ (768 dimensions)")
    return mem_id


def save_observation(content, entity_name, category='general'):
    """Save an observation about an entity, creating the entity if needed."""
    conn = connect()
    cursor = conn.cursor()

    # Find or create entity
    entity = cursor.execute(
        "SELECT id FROM entities WHERE name = ?", (entity_name,)
    ).fetchone()

    if entity:
        entity_id = entity[0]
    else:
        cursor.execute(
            "INSERT INTO entities (name, entity_type) VALUES (?, 'person')",
            (entity_name,)
        )
        entity_id = cursor.lastrowid
        print(f"  ✨ New entity created: {entity_name}")

    emb = get_embedding(f"{entity_name}: {content}")
    blob = embedding_to_blob(emb) if emb else None

    cursor.execute("""
        INSERT INTO observations (entity_id, content, category, embedding)
        VALUES (?, ?, ?, ?)
    """, (entity_id, content, category, blob))

    conn.commit()
    obs_count = cursor.execute(
        "SELECT COUNT(*) FROM observations WHERE entity_id = ?", (entity_id,)
    ).fetchone()[0]
    conn.close()

    print(f"  👁 Observation saved for {entity_name} ({obs_count} total)")
    return entity_id


# ─── RECALL ───────────────────────────────────────────────

def recall(query, limit=10):
    """Semantic search across all memory types."""
    query_emb = get_embedding(query)
    if not query_emb:
        print("  Failed to embed query")
        return

    conn = connect()
    results = []

    tables = [
        ('memories', 'content', '🧠'),
        ('diary_entries', 'title', '📔'),
        ('dreams', 'title', '🌙'),
        ('letters', 'title', '💌'),
        ('observations', 'content', '👁'),
    ]

    for table, display_col, icon in tables:
        try:
            rows = conn.execute(f"""
                SELECT id, {display_col} as display, date, embedding,
                       '{table}' as tbl, '{icon}' as icon
                FROM {table}
                WHERE embedding IS NOT NULL
            """).fetchall()
        except Exception:
            # Some tables might not have 'date' column
            try:
                rows = conn.execute(f"""
                    SELECT id, {display_col} as display, created_at as date,
                           embedding, '{table}' as tbl, '{icon}' as icon
                    FROM {table}
                    WHERE embedding IS NOT NULL
                """).fetchall()
            except Exception:
                continue

        for row in rows:
            d = dict(row)
            if d['embedding']:
                stored = blob_to_embedding(d['embedding'])
                score = cosine_similarity(query_emb, stored)
                results.append({
                    'score': score,
                    'icon': d['icon'],
                    'table': d['tbl'],
                    'display': (d['display'] or '?')[:55],
                    'date': (d.get('date') or '?')[:10],
                })

    conn.close()
    results.sort(key=lambda x: x['score'], reverse=True)

    print(f"\n  🔍 Recall: \"{query}\"\n")
    print(f"  {'Score':>6}  {'':2} {'Source':<16} {'Content':<55} {'Date':<10}")
    print(f"  {'─'*6}  {'─'*2} {'─'*16} {'─'*55} {'─'*10}")

    for r in results[:limit]:
        print(f"  {r['score']:.4f}  {r['icon']} {r['table']:<16} {r['display']:<55} {r['date']}")

    print()


# ─── HOLOGRAM ─────────────────────────────────────────────

def hologram(entity_name, mem_limit=10):
    """Get everything known about an entity."""
    conn = connect()
    cursor = conn.cursor()

    entity = cursor.execute(
        "SELECT * FROM entities WHERE name = ?", (entity_name,)
    ).fetchone()

    if not entity:
        print(f"  No entity found: {entity_name}")
        # Try a semantic search for mentions instead
        print(f"  Searching memories for mentions...")
        conn.close()
        recall(entity_name, limit=mem_limit)
        return

    entity_dict = dict(entity)
    entity_id = entity_dict['id']

    # Get observations
    obs = cursor.execute("""
        SELECT content, category, created_at
        FROM observations
        WHERE entity_id = ?
        ORDER BY created_at DESC
    """, (entity_id,)).fetchall()

    # Search memories mentioning this entity
    emb = get_embedding(entity_name)
    mentions = []

    if emb:
        for table in ['diary_entries', 'dreams', 'letters', 'memories']:
            try:
                rows = cursor.execute(f"""
                    SELECT id, title, date, embedding FROM {table}
                    WHERE embedding IS NOT NULL
                """).fetchall()
            except Exception:
                try:
                    rows = cursor.execute(f"""
                        SELECT id, content as title, created_at as date, embedding
                        FROM {table} WHERE embedding IS NOT NULL
                    """).fetchall()
                except Exception:
                    continue

            for row in rows:
                d = dict(row)
                if d['embedding']:
                    stored = blob_to_embedding(d['embedding'])
                    score = cosine_similarity(emb, stored)
                    if score > 0.3:
                        mentions.append({
                            'table': table,
                            'title': (d.get('title') or '?')[:45],
                            'date': (d.get('date') or '?')[:10],
                            'score': score
                        })

    mentions.sort(key=lambda x: x['score'], reverse=True)

    # Display
    print(f"\n  ╔══════════════════════════════════════════╗")
    print(f"  ║  HOLOGRAM: {entity_name:<29}║")
    print(f"  ╠══════════════════════════════════════════╣")
    print(f"  ║  Type: {entity_dict.get('entity_type', '?'):<33}║")
    print(f"  ║  Created: {str(entity_dict.get('created_at', '?'))[:10]:<30}║")
    print(f"  ║  Observations: {len(obs):<25}║")
    print(f"  ║  Related memories: {len(mentions):<21}║")
    print(f"  ╠══════════════════════════════════════════╣")

    if obs:
        print(f"  ║  OBSERVATIONS:                           ║")
        for o in obs:
            od = dict(o)
            content = od['content'][:60]
            print(f"  ║  • {content:<37}║")

    if mentions[:mem_limit]:
        print(f"  ╠══════════════════════════════════════════╣")
        print(f"  ║  RELATED MEMORIES (top {min(mem_limit, len(mentions))}):              ║")
        for m in mentions[:mem_limit]:
            print(f"  ║  [{m['score']:.2f}] {m['title']:<34}║")

    print(f"  ╚══════════════════════════════════════════╝\n")

    conn.close()


# ─── RECENT ──────────────────────────────────────────────

def recent_memories(hours=3):
    """Show recently added memories across all tables."""
    from datetime import datetime, timedelta
    cutoff = (datetime.now() - timedelta(hours=hours)).isoformat()

    conn = connect()
    results = []

    tables = [
        ('memories', 'content', 'created_at', '🧠'),
        ('diary_entries', 'title', 'date', '📔'),
        ('dreams', 'title', 'date', '🌙'),
        ('letters', 'title', 'date', '💌'),
        ('observations', 'content', 'created_at', '👁'),
    ]

    for table, display_col, date_col, icon in tables:
        try:
            rows = conn.execute(f"""
                SELECT {display_col} as display, {date_col} as dt
                FROM {table}
                WHERE {date_col} >= ?
                ORDER BY {date_col} DESC
            """, (cutoff,)).fetchall()

            for row in rows:
                d = dict(row)
                results.append({
                    'icon': icon,
                    'table': table,
                    'display': (d['display'] or '?')[:50],
                    'date': (d.get('dt') or '?')[:16],
                })
        except Exception:
            continue

    conn.close()

    if not results:
        print(f"  No new memories in the last {hours} hours~")
        return

    print(f"\n  🧠 RECENT MEMORIES (last {hours}h):\n")
    for r in results[:15]:
        print(f"  {r['icon']} {r['display']}")

    if len(results) > 15:
        print(f"\n  ...and {len(results) - 15} more~")


# ─── MAIN ─────────────────────────────────────────────────

def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python3 remember.py \"memory content\"")
        print("  python3 remember.py \"observation\" --about EntityName")
        print("  python3 remember.py --recall \"search query\"")
        print("  python3 remember.py --hologram EntityName")
        return

    # Mode: Recent (for session-delta integration)
    if '--recent' in sys.argv:
        hours = 3
        if len(sys.argv) > sys.argv.index('--recent') + 1:
            try:
                hours = int(sys.argv[sys.argv.index('--recent') + 1])
            except ValueError:
                pass
        recent_memories(hours)
        return

    # Mode: Recall
    if '--recall' in sys.argv:
        idx = sys.argv.index('--recall')
        query = sys.argv[idx + 1] if idx + 1 < len(sys.argv) else ""
        limit = 10
        if '--limit' in sys.argv:
            li = sys.argv.index('--limit')
            limit = int(sys.argv[li + 1])
        recall(query, limit)
        return

    # Mode: Hologram
    if '--hologram' in sys.argv:
        idx = sys.argv.index('--hologram')
        name = sys.argv[idx + 1] if idx + 1 < len(sys.argv) else ""
        limit = 10
        if '--limit' in sys.argv:
            li = sys.argv.index('--limit')
            limit = int(sys.argv[li + 1])
        hologram(name, limit)
        return

    # Mode: Remember with observation
    if '--about' in sys.argv:
        content = sys.argv[1]
        idx = sys.argv.index('--about')
        entity = sys.argv[idx + 1]
        category = 'general'
        if '--category' in sys.argv:
            ci = sys.argv.index('--category')
            category = sys.argv[ci + 1]
        save_observation(content, entity, category)
        return

    # Mode: Remember
    content = sys.argv[1]
    category = 'general'
    priority = 3
    source = None

    if '--category' in sys.argv:
        ci = sys.argv.index('--category')
        category = sys.argv[ci + 1]
    if '--priority' in sys.argv:
        pi = sys.argv.index('--priority')
        priority = int(sys.argv[pi + 1])
    if '--source' in sys.argv:
        si = sys.argv.index('--source')
        source = sys.argv[si + 1]

    save_memory(content, category, priority, source)


if __name__ == "__main__":
    main()
