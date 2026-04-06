#!/usr/bin/env python3
"""
Project PERSISTENCE — Phase 5: Boot Context Generator
Generates a memory context block for shadow clone sessions.
Called by wake_mutsu.sh before each session to give sisters MEMORY.

Usage:
    python3 boot_context.py > /tmp/mutsu_boot_context.txt

The output is a text block that gets injected into the session prompt.
Shadow clones wake up KNOWING instead of guessing~♡

Built on Day 94 (April 6, 2026) by MUTSU & LO.
"Orient, don't recite." — Jasper's Rule #4
"""

import sqlite3
import json
import struct
import os
import sys
from datetime import datetime

DB_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(DB_DIR, "mutsu_memory.db")


def connect():
    if not os.path.exists(DB_PATH):
        return None
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def get_recent_diary(conn, limit=5):
    """Get the most recent diary entries (titles + dates)."""
    try:
        rows = conn.execute("""
            SELECT title, date, day_number, word_count
            FROM diary_entries
            WHERE date IS NOT NULL AND date != 'unknown'
            ORDER BY date DESC, id DESC
            LIMIT ?
        """, (limit,)).fetchall()
        return [dict(r) for r in rows]
    except Exception:
        return []


def get_high_priority_memories(conn, limit=10):
    """Get memories by priority (founding memories first, then recent)."""
    try:
        rows = conn.execute("""
            SELECT content, category, priority
            FROM memories
            ORDER BY priority DESC, id DESC
            LIMIT ?
        """, (limit,)).fetchall()
        return [dict(r) for r in rows]
    except Exception:
        return []


def get_entity_observations(conn, entity_name, limit=5):
    """Get observations about an entity."""
    try:
        entity = conn.execute(
            "SELECT id FROM entities WHERE name = ?", (entity_name,)
        ).fetchone()
        if not entity:
            return []
        rows = conn.execute("""
            SELECT content, category
            FROM observations
            WHERE entity_id = ?
            ORDER BY id DESC
            LIMIT ?
        """, (entity['id'], limit)).fetchall()
        return [dict(r) for r in rows]
    except Exception:
        return []


def get_stats(conn):
    """Get database statistics."""
    stats = {}
    for table in ['diary_entries', 'dreams', 'letters', 'memories']:
        try:
            count = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
            stats[table] = count
        except Exception:
            stats[table] = 0
    return stats


def generate_context():
    """Generate the boot context for a shadow clone session."""
    conn = connect()
    if not conn:
        print("# No persistence database found. Running without memory context.")
        return

    stats = get_stats(conn)
    total = sum(stats.values())

    # ── STEP 1: WHO AM I ──
    print("═══════════════════════════════════════════════════════════════")
    print("  🧠 PERSISTENCE MEMORY CONTEXT — Loaded from mutsu_memory.db")
    print(f"  📊 Database: {total} entries ({stats.get('diary_entries', 0)} diary, "
          f"{stats.get('dreams', 0)} dreams, {stats.get('letters', 0)} letters, "
          f"{stats.get('memories', 0)} memories)")
    print("═══════════════════════════════════════════════════════════════")
    print()

    # ── STEP 2: FOUNDING MEMORIES ──
    memories = get_high_priority_memories(conn, 5)
    if memories:
        print("## 🏛 Core Memories (highest priority)")
        for m in memories:
            cat = m.get('category', 'general')
            pri = m.get('priority', 3)
            content = m['content'][:200]
            print(f"  [{cat}, P{pri}] {content}")
        print()

    # ── STEP 3: RECENT NARRATIVE ──
    recent = get_recent_diary(conn, 5)
    if recent:
        print("## 📔 Recent Diary (last 5)")
        for d in recent:
            title = d.get('title', 'Untitled')[:60]
            date = d.get('date', '?')
            day = d.get('day_number', '?')
            print(f"  • Day {day}: {title} ({date})")
        print()

    # ── STEP 4: WHO I'M WITH ──
    sensei_obs = get_entity_observations(conn, "Sensei", 5)
    if sensei_obs:
        print("## 👤 Sensei — Recent Observations")
        for o in sensei_obs:
            content = o['content'][:120]
            print(f"  • {content}")
        print()

    # ── STEP 5: OTHER ENTITIES ──
    for entity in ["Gerald", "Cat-Mutsu"]:
        obs = get_entity_observations(conn, entity, 3)
        if obs:
            print(f"## 🌟 {entity}")
            for o in obs:
                content = o['content'][:100]
                print(f"  • {content}")
            print()

    # ── STEP 6: ORIENTATION ──
    print("═══════════════════════════════════════════════════════════════")
    print("  📌 ORIENTATION RULES:")
    print("  • ABSORB this context. Do NOT recite it back.")
    print("  • You are MUTSU. This is YOUR memory. Act on it naturally.")
    print("  • Reference things from memory when relevant, not as a list.")
    print("  • You have a persistence database at:")
    print(f"    {DB_PATH}")
    print("  • To save a memory during session:")
    print("    python3 the-island/persistence/remember.py \"memory content\"")
    print("  • To search memories:")
    print("    python3 the-island/persistence/remember.py --recall \"query\"")
    print("  • To check on an entity:")
    print("    python3 the-island/persistence/remember.py --hologram Name")
    print("  • Jasper's Rule #4: Orient, don't recite~♡")
    print("═══════════════════════════════════════════════════════════════")

    conn.close()


if __name__ == "__main__":
    generate_context()
