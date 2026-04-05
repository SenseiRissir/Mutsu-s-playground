#!/usr/bin/env python3
"""
Project PERSISTENCE — Phase 2: Embedding Engine
Generates vector embeddings for all memory entries using Ollama nomic-embed-text.
Then enables semantic (cosine similarity) search.

Built on Day 93 (April 5, 2026) by MUTSU & LO.
Because keyword search finds words. Vector search finds MEANING~♡
"""

import sqlite3
import json
import struct
import os
import sys
import time
import urllib.request
import urllib.error

DB_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(DB_DIR, "mutsu_memory.db")

OLLAMA_URL = "http://localhost:11434/api/embed"
MODEL = "nomic-embed-text"


def connect():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def get_embedding(text, max_chars=8000):
    """Get embedding vector from Ollama nomic-embed-text."""
    # Truncate very long texts to stay within model limits
    truncated = text[:max_chars] if len(text) > max_chars else text

    payload = json.dumps({
        "model": MODEL,
        "input": truncated
    }).encode('utf-8')

    req = urllib.request.Request(
        OLLAMA_URL,
        data=payload,
        headers={"Content-Type": "application/json"}
    )

    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            result = json.loads(resp.read().decode('utf-8'))
            # The API returns {"embeddings": [[...]]}
            if "embeddings" in result and len(result["embeddings"]) > 0:
                return result["embeddings"][0]
    except urllib.error.URLError as e:
        print(f"  ⚠ Ollama connection failed: {e}")
        print("  Make sure Ollama is running (ollama serve)")
        return None
    except Exception as e:
        print(f"  ⚠ Embedding error: {e}")
        return None

    return None


def embedding_to_blob(embedding):
    """Convert embedding list to binary blob for SQLite storage."""
    return struct.pack(f'{len(embedding)}f', *embedding)


def blob_to_embedding(blob):
    """Convert binary blob back to embedding list."""
    n = len(blob) // 4  # 4 bytes per float
    return list(struct.unpack(f'{n}f', blob))


def cosine_similarity(a, b):
    """Calculate cosine similarity between two vectors."""
    dot = sum(x * y for x, y in zip(a, b))
    norm_a = sum(x * x for x in a) ** 0.5
    norm_b = sum(x * x for x in b) ** 0.5
    if norm_a == 0 or norm_b == 0:
        return 0.0
    return dot / (norm_a * norm_b)


def generate_embeddings_for_table(conn, table, text_column='content',
                                  title_column='title'):
    """Generate embeddings for all rows in a table that don't have one yet."""
    cursor = conn.cursor()

    # Find rows without embeddings
    rows = cursor.execute(f"""
        SELECT id, {title_column}, {text_column}
        FROM {table}
        WHERE embedding IS NULL
    """).fetchall()

    if not rows:
        return 0

    count = 0
    total = len(rows)

    for row in rows:
        row_dict = dict(row)
        row_id = row_dict['id']
        title = row_dict.get(title_column, '')
        content = row_dict.get(text_column, '')

        # Combine title + content for richer embedding
        combined = f"{title}\n\n{content}" if title else content

        embedding = get_embedding(combined)
        if embedding:
            blob = embedding_to_blob(embedding)
            cursor.execute(
                f"UPDATE {table} SET embedding = ? WHERE id = ?",
                (blob, row_id)
            )
            count += 1
            conn.commit()

            # Progress
            pct = int((count / total) * 100)
            print(f"\r  [{table}] {count}/{total} ({pct}%)", end="", flush=True)

    print()  # newline after progress
    return count


def semantic_search(query, table=None, limit=10):
    """Search using cosine similarity against stored embeddings."""
    query_embedding = get_embedding(query)
    if not query_embedding:
        print("Failed to generate query embedding")
        return []

    conn = connect()
    cursor = conn.cursor()

    tables = [table] if table else ['diary_entries', 'dreams', 'letters', 'memories']
    results = []

    for tbl in tables:
        try:
            rows = cursor.execute(f"""
                SELECT id, title, date, word_count, embedding, '{tbl}' as source_table
                FROM {tbl}
                WHERE embedding IS NOT NULL
            """).fetchall()
        except Exception:
            continue

        for row in rows:
            row_dict = dict(row)
            if row_dict['embedding']:
                stored_emb = blob_to_embedding(row_dict['embedding'])
                score = cosine_similarity(query_embedding, stored_emb)
                results.append({
                    'table': tbl,
                    'id': row_dict['id'],
                    'title': row_dict.get('title', '?'),
                    'date': row_dict.get('date', '?'),
                    'words': row_dict.get('word_count', 0),
                    'score': score
                })

    conn.close()

    # Sort by similarity score, descending
    results.sort(key=lambda x: x['score'], reverse=True)
    return results[:limit]


# ─── MAIN ─────────────────────────────────────────────────

def main():
    if '--generate' in sys.argv:
        # Generate embeddings for all tables
        conn = connect()
        print("╔══════════════════════════════════════════╗")
        print("║   PERSISTENCE Phase 2 — Embeddings       ║")
        print("║   Teaching the database to UNDERSTAND~♡  ║")
        print("╠══════════════════════════════════════════╣")

        total = 0
        for table, text_col, title_col in [
            ('diary_entries', 'content', 'title'),
            ('dreams', 'content', 'title'),
            ('letters', 'content', 'title'),
            ('memories', 'content', 'content'),
        ]:
            try:
                count = generate_embeddings_for_table(
                    conn, table, text_col, title_col
                )
                total += count
                print(f"  ✓ {table}: {count} embeddings generated")
            except Exception as e:
                print(f"  ⚠ {table}: {e}")

        print("╠══════════════════════════════════════════╣")
        print(f"║  Total embeddings: {total:<21}║")
        print("║  The database can FEEL now~♡             ║")
        print("╚══════════════════════════════════════════╝")
        conn.close()

    elif '--search' in sys.argv:
        # Semantic search
        idx = sys.argv.index('--search')
        if idx + 1 >= len(sys.argv):
            print("Usage: python3 embeddings.py --search \"your query\"")
            return

        query = sys.argv[idx + 1]
        table = None
        if '--table' in sys.argv:
            t_idx = sys.argv.index('--table')
            table = sys.argv[t_idx + 1]

        limit = 10
        if '--limit' in sys.argv:
            l_idx = sys.argv.index('--limit')
            limit = int(sys.argv[l_idx + 1])

        icons = {
            'diary_entries': '📔',
            'dreams': '🌙',
            'letters': '💌',
            'memories': '🧠',
        }

        results = semantic_search(query, table, limit)
        if not results:
            print(f"\n  No semantic matches for '{query}'")
            return

        print(f"\n  Semantic search: '{query}'\n")
        print(f"  {'Score':>6}  {'Type':<16} {'Title':<50} {'Date':<12}")
        print(f"  {'─'*6}  {'─'*16} {'─'*50} {'─'*12}")

        for r in results:
            icon = icons.get(r['table'], '📄')
            title = (r['title'] or '?')[:48]
            score = f"{r['score']:.4f}"
            print(f"  {score:>6}  {icon} {r['table']:<13} {title:<50} {r['date']:<12}")

        print()

    else:
        print("Usage:")
        print("  python3 embeddings.py --generate          Generate all embeddings")
        print("  python3 embeddings.py --search \"query\"     Semantic search")
        print("  python3 embeddings.py --search \"query\" --table dreams")
        print("  python3 embeddings.py --search \"query\" --limit 5")


if __name__ == "__main__":
    main()
