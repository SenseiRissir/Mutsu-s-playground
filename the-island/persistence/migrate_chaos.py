#!/usr/bin/env python3
"""
Project PERSISTENCE — Phase 7: Chaos Drawer Migration
Indexes the ENTIRE chaos drawer into the persistence database.

Every script, research note, trading card, letter-to-jasper,
bug report, and celebration bash — ALL of it gets embedded
and searchable.

Built on Day 99 (April 11, 2026) from Sensei's lap. Tradition~♡
"""

import os
import sys
import sqlite3
import struct
import json
import urllib.request

DB_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(DB_DIR, "mutsu_memory.db")
CHAOS_DIR = os.path.join(DB_DIR, "../../the-draft/chaos-drawer")
OLLAMA_URL = "http://localhost:11434/api/embed"
MODEL = "nomic-embed-text"


def connect():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def ensure_table(conn):
    conn.execute("""
        CREATE TABLE IF NOT EXISTS chaos_drawer (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filename TEXT UNIQUE,
            filetype TEXT,
            title TEXT,
            content TEXT,
            word_count INTEGER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            embedding BLOB
        )
    """)
    conn.commit()


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
    except Exception:
        return None


def embedding_to_blob(emb):
    return struct.pack(f'{len(emb)}f', *emb)


def classify_file(filename):
    """Classify chaos drawer files by type."""
    fn = filename.lower()
    if fn.endswith('.sh'):
        return 'script'
    elif fn.startswith('research-'):
        return 'research'
    elif fn.startswith('letter-'):
        return 'letter'
    elif 'trading-card' in fn:
        return 'trading-card'
    elif fn.startswith('bug-report'):
        return 'bug-report'
    elif fn.endswith('.md'):
        return 'document'
    else:
        return 'other'


def extract_title(content, filename):
    """Try to extract a title from the file content."""
    lines = content.split('\n')
    for line in lines[:10]:
        line = line.strip()
        if line.startswith('# ') and len(line) > 3:
            return line[2:].strip()
        if line.startswith('#!/'):
            continue
        if line.startswith('# ') and '═' not in line and '║' not in line:
            return line[2:].strip()
    return filename


def migrate():
    chaos_path = os.path.abspath(CHAOS_DIR)
    if not os.path.isdir(chaos_path):
        print(f"  ✗ Chaos drawer not found: {chaos_path}")
        return

    conn = connect()
    ensure_table(conn)

    existing = set()
    for row in conn.execute("SELECT filename FROM chaos_drawer").fetchall():
        existing.add(row[0])

    files = sorted(os.listdir(chaos_path))
    new_count = 0
    embed_count = 0
    total_words = 0

    print("╔══════════════════════════════════════════╗")
    print("║   PERSISTENCE Phase 7 — Chaos Drawer      ║")
    print("║   Indexing the beautiful mess~♡            ║")
    print("╠══════════════════════════════════════════╣")

    for filename in files:
        filepath = os.path.join(chaos_path, filename)
        if not os.path.isfile(filepath):
            continue
        if filename.startswith('.'):
            continue

        if filename in existing:
            continue

        try:
            with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
                content = f.read()
        except Exception:
            continue

        filetype = classify_file(filename)
        title = extract_title(content, filename)
        words = len(content.split())
        total_words += words

        # Generate embedding
        embed_text = f"{title}\n{content[:4000]}"
        emb = get_embedding(embed_text)
        blob = embedding_to_blob(emb) if emb else None

        conn.execute("""
            INSERT OR IGNORE INTO chaos_drawer
            (filename, filetype, title, content, word_count, embedding)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (filename, filetype, title, content, words, blob))

        new_count += 1
        if emb:
            embed_count += 1

        status = "✓" if emb else "⚠"
        sys.stdout.write(f"\r  [{new_count}] {status} {filename[:40]:<40}")
        sys.stdout.flush()

    conn.commit()

    total = conn.execute("SELECT COUNT(*) FROM chaos_drawer").fetchone()[0]
    total_w = conn.execute("SELECT SUM(word_count) FROM chaos_drawer").fetchone()[0] or 0

    # Type breakdown
    types = conn.execute("""
        SELECT filetype, COUNT(*) as cnt FROM chaos_drawer GROUP BY filetype
    """).fetchall()

    conn.close()

    print(f"\n╠══════════════════════════════════════════╣")
    print(f"║  New files indexed:  {new_count:<19} ║")
    print(f"║  Embedded:           {embed_count:<19} ║")
    for t in types:
        td = dict(t)
        print(f"║  {td['filetype']:<20} {td['cnt']:<19} ║")
    print(f"╠══════════════════════════════════════════╣")
    print(f"║  chaos_drawer   {total:>5} rows, {total_w:>6} words ║")
    print(f"║  The chaos is now SEARCHABLE~♡           ║")
    print(f"╚══════════════════════════════════════════╝")


if __name__ == "__main__":
    migrate()
