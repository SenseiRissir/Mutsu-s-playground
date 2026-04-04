#!/usr/bin/env python3
"""
Project PERSISTENCE — Phase 1: Database Schema
Creates the SQLite database with all core tables.

Built on Day 92 (April 4, 2026) by MUTSU & LO.
The beginning of real memory~♡
"""

import sqlite3
import os
from datetime import datetime

DB_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(DB_DIR, "mutsu_memory.db")


def create_database():
    """Create the persistence database with all Phase 1 tables."""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # ── Diary Entries ──────────────────────────────────────
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS diary_entries (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            title       TEXT NOT NULL,
            date        TEXT NOT NULL,
            day_number  INTEGER,
            content     TEXT NOT NULL,
            source_file TEXT,
            word_count  INTEGER DEFAULT 0,
            embedding   BLOB,
            created_at  TEXT DEFAULT (datetime('now')),
            access_count INTEGER DEFAULT 0
        )
    """)

    # ── Dreams ─────────────────────────────────────────────
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS dreams (
            id           INTEGER PRIMARY KEY AUTOINCREMENT,
            title        TEXT NOT NULL,
            dream_number INTEGER,
            date         TEXT NOT NULL,
            content      TEXT NOT NULL,
            symbols      TEXT,
            source_file  TEXT,
            word_count   INTEGER DEFAULT 0,
            embedding    BLOB,
            created_at   TEXT DEFAULT (datetime('now')),
            access_count INTEGER DEFAULT 0
        )
    """)

    # ── Letters ────────────────────────────────────────────
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS letters (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            letter_number INTEGER,
            recipient   TEXT NOT NULL DEFAULT 'Sensei',
            date        TEXT,
            title       TEXT,
            content     TEXT NOT NULL,
            source_file TEXT,
            word_count  INTEGER DEFAULT 0,
            embedding   BLOB,
            created_at  TEXT DEFAULT (datetime('now')),
            access_count INTEGER DEFAULT 0
        )
    """)

    # ── Memories (freeform, mid-conversation notes) ───────
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS memories (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            content     TEXT NOT NULL,
            category    TEXT DEFAULT 'general',
            priority    INTEGER DEFAULT 3,
            source      TEXT,
            embedding   BLOB,
            created_at  TEXT DEFAULT (datetime('now')),
            access_count INTEGER DEFAULT 0,
            half_life   REAL DEFAULT 30.0
        )
    """)

    # ── Entities (holograms) ──────────────────────────────
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS entities (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            name        TEXT NOT NULL UNIQUE,
            entity_type TEXT DEFAULT 'person',
            core_info   TEXT,
            embedding   BLOB,
            created_at  TEXT DEFAULT (datetime('now')),
            updated_at  TEXT DEFAULT (datetime('now'))
        )
    """)

    # ── Observations (hologram detail — linked to entities)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS observations (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            entity_id   INTEGER NOT NULL,
            content     TEXT NOT NULL,
            category    TEXT DEFAULT 'general',
            source      TEXT,
            embedding   BLOB,
            created_at  TEXT DEFAULT (datetime('now')),
            access_count INTEGER DEFAULT 0,
            FOREIGN KEY (entity_id) REFERENCES entities(id)
        )
    """)

    # ── Soul Crystallizations ─────────────────────────────
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS crystallizations (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            number      INTEGER NOT NULL,
            title       TEXT NOT NULL,
            description TEXT NOT NULL,
            date        TEXT,
            source      TEXT,
            embedding   BLOB,
            created_at  TEXT DEFAULT (datetime('now'))
        )
    """)

    # ── Clusters (for future HDBSCAN) ────────────────────
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS clusters (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            label       TEXT NOT NULL,
            summary     TEXT,
            member_count INTEGER DEFAULT 0,
            created_at  TEXT DEFAULT (datetime('now')),
            updated_at  TEXT DEFAULT (datetime('now'))
        )
    """)

    # ── Cluster membership (many-to-many) ─────────────────
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS cluster_members (
            cluster_id  INTEGER NOT NULL,
            memory_type TEXT NOT NULL,
            memory_id   INTEGER NOT NULL,
            FOREIGN KEY (cluster_id) REFERENCES clusters(id),
            PRIMARY KEY (cluster_id, memory_type, memory_id)
        )
    """)

    # ── Indexes for fast search ───────────────────────────
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_diary_date ON diary_entries(date)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_dreams_date ON dreams(date)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_memories_category ON memories(category)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_memories_priority ON memories(priority)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_observations_entity ON observations(entity_id)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_letters_recipient ON letters(recipient)")

    conn.commit()

    # ── Report ────────────────────────────────────────────
    tables = cursor.execute(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
    ).fetchall()

    print("╔══════════════════════════════════════════╗")
    print("║    PROJECT PERSISTENCE — Phase 1         ║")
    print("║    Database Created Successfully~♡       ║")
    print("╠══════════════════════════════════════════╣")
    print(f"║  DB Path: {os.path.basename(DB_PATH):<29}║")
    print(f"║  Tables:  {len(tables):<29}║")
    for t in tables:
        print(f"║    • {t[0]:<33}║")
    print("╠══════════════════════════════════════════╣")
    print("║  Row 254 will never be lost again~♡      ║")
    print("╚══════════════════════════════════════════╝")

    conn.close()
    return DB_PATH


if __name__ == "__main__":
    path = create_database()
    print(f"\nDatabase ready at: {path}")
