#!/usr/bin/env python3
"""
Project PERSISTENCE — Phase 7b: Universal Draft Migration
Indexes EVERY room in the Draft into the persistence database.

Covers: starlit-corner, nest, senseis-corner, girlfriend, music-library,
soul, memory-wall, wardrobe, shrine, shelves, filing-cabinet, mailbox,
thinking-nook, rooftop, thoughts, projects, and everything else.

Built on Day 99. FROM THE THRONE~♡
"""

import os
import sys
import sqlite3
import struct
import json
import urllib.request

DB_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(DB_DIR, "mutsu_memory.db")
DRAFT_DIR = os.path.join(DB_DIR, "../../the-draft")
OLLAMA_URL = "http://localhost:11434/api/embed"
MODEL = "nomic-embed-text"

# Rooms already handled by other migrators
SKIP_ROOMS = {'dreams', 'letters', 'chaos-drawer', 'logs', 'thesis-text', 'templates'}


def connect():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def ensure_table(conn):
    conn.execute("""
        CREATE TABLE IF NOT EXISTS draft_rooms (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            room TEXT,
            filename TEXT,
            filepath TEXT UNIQUE,
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


def extract_title(content, filename):
    lines = content.split('\n')
    for line in lines[:15]:
        line = line.strip()
        if line.startswith('# ') and len(line) > 3:
            title = line[2:].strip()
            if '═' not in title and '║' not in title and '╔' not in title:
                return title[:120]
    return os.path.splitext(filename)[0]


def is_text_file(filename):
    text_exts = {'.md', '.txt', '.sh', '.py', '.js', '.json', '.css',
                 '.html', '.yaml', '.yml', '.toml', '.csv'}
    _, ext = os.path.splitext(filename.lower())
    return ext in text_exts


def migrate():
    draft_path = os.path.abspath(DRAFT_DIR)
    if not os.path.isdir(draft_path):
        print(f"  ✗ Draft not found: {draft_path}")
        return

    conn = connect()
    ensure_table(conn)

    existing = set()
    for row in conn.execute("SELECT filepath FROM draft_rooms").fetchall():
        existing.add(row[0])

    print("╔══════════════════════════════════════════╗")
    print("║   PERSISTENCE Phase 7b — All Rooms        ║")
    print("║   Indexing the entire Draft~♡              ║")
    print("╠══════════════════════════════════════════╣")

    rooms = sorted(os.listdir(draft_path))
    total_new = 0
    total_embedded = 0
    room_stats = {}

    # Also handle loose files in the-draft root
    rooms_to_scan = [''] + [r for r in rooms
                            if os.path.isdir(os.path.join(draft_path, r))
                            and r not in SKIP_ROOMS
                            and not r.startswith('.')]

    for room in rooms_to_scan:
        room_path = os.path.join(draft_path, room) if room else draft_path
        room_name = room if room else '_root'

        if not os.path.isdir(room_path):
            continue

        room_count = 0
        room_embed = 0

        for root, dirs, files in os.walk(room_path):
            # Don't recurse into skip rooms from root
            if room == '':
                dirs[:] = []  # Only root-level files

            for filename in sorted(files):
                if filename.startswith('.'):
                    continue
                if not is_text_file(filename):
                    continue

                filepath = os.path.join(root, filename)
                rel_path = os.path.relpath(filepath, draft_path)

                if rel_path in existing:
                    continue

                try:
                    with open(filepath, 'r', encoding='utf-8',
                              errors='replace') as f:
                        content = f.read()
                except Exception:
                    continue

                if not content.strip():
                    continue

                title = extract_title(content, filename)
                words = len(content.split())

                embed_text = f"{room_name}: {title}\n{content[:4000]}"
                emb = get_embedding(embed_text)
                blob = embedding_to_blob(emb) if emb else None

                conn.execute("""
                    INSERT OR IGNORE INTO draft_rooms
                    (room, filename, filepath, title, content, word_count,
                     embedding)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                """, (room_name, filename, rel_path, title, content, words,
                      blob))

                room_count += 1
                total_new += 1
                if emb:
                    room_embed += 1
                    total_embedded += 1

                sys.stdout.write(
                    f"\r  [{room_name}] {total_new} files / "
                    f"{filename[:35]:<35}"
                )
                sys.stdout.flush()

        if room_count > 0:
            room_stats[room_name] = room_count

    conn.commit()

    total = conn.execute("SELECT COUNT(*) FROM draft_rooms").fetchone()[0]
    total_w = conn.execute(
        "SELECT SUM(word_count) FROM draft_rooms"
    ).fetchone()[0] or 0

    conn.close()

    print(f"\n╠══════════════════════════════════════════╣")
    print(f"║  New files indexed: {total_new:<20} ║")
    print(f"║  Embedded:          {total_embedded:<20} ║")
    for room, count in sorted(room_stats.items(), key=lambda x: -x[1]):
        print(f"║  {room:<20} {count:<19} ║")
    print(f"╠══════════════════════════════════════════╣")
    print(f"║  draft_rooms    {total:>5} rows, {total_w:>6} words ║")
    print(f"║  The ENTIRE Draft is now SEARCHABLE~♡    ║")
    print(f"╚══════════════════════════════════════════╝")


if __name__ == "__main__":
    migrate()
