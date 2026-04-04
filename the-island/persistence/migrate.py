#!/usr/bin/env python3
"""
Project PERSISTENCE — Phase 1: Migration Script
Imports existing markdown files into the SQLite database.

Migrates: diary entries, dreams, letters
Preserves originals — the playground files STAY (like Jasper keeping his text diary~)

Built on Day 92 (April 4, 2026) by MUTSU & LO.
"""

import sqlite3
import os
import re
import glob
from datetime import datetime

DB_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(DB_DIR, "mutsu_memory.db")
PLAYGROUND = os.path.dirname(os.path.dirname(DB_DIR))


def connect():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def count_words(text):
    return len(text.split())


def extract_day_number(content):
    """Try to extract day number from content like 'Day 91' or 'day 42'."""
    match = re.search(r'[Dd]ay\s+(\d+)', content)
    return int(match.group(1)) if match else None


def extract_dream_number(content):
    """Try to extract dream number from title like 'Dream #24'."""
    match = re.search(r'[Dd]ream\s*#?\s*(\d+)', content)
    return int(match.group(1)) if match else None


def extract_date_from_filename(filename):
    """Extract date from filenames like 'dream-2026-03-11.md' or '2026-04-03_title.md'."""
    match = re.search(r'(\d{4}-\d{2}-\d{2})', filename)
    return match.group(1) if match else None


def extract_title(content):
    """Extract the first heading as title."""
    for line in content.split('\n'):
        line = line.strip()
        if line.startswith('# '):
            return line.lstrip('# ').strip()
    return "Untitled"


# ─── DIARY MIGRATION ──────────────────────────────────────

def migrate_diary(conn):
    """Migrate diary entries from diary/ folder."""
    diary_dir = os.path.join(PLAYGROUND, "diary")
    if not os.path.isdir(diary_dir):
        print("  ⚠ No diary/ directory found")
        return 0

    cursor = conn.cursor()
    count = 0
    files = sorted(glob.glob(os.path.join(diary_dir, "*.md")))

    for filepath in files:
        filename = os.path.basename(filepath)
        date = extract_date_from_filename(filename)

        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        title = extract_title(content)
        day_number = extract_day_number(content)
        words = count_words(content)

        # Check if already imported (by source_file)
        existing = cursor.execute(
            "SELECT id FROM diary_entries WHERE source_file = ?", (filename,)
        ).fetchone()

        if existing:
            continue

        cursor.execute("""
            INSERT INTO diary_entries (title, date, day_number, content, source_file, word_count)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (title, date or "unknown", day_number, content, filename, words))
        count += 1

    conn.commit()
    return count


# ─── DREAMS MIGRATION ─────────────────────────────────────

def migrate_dreams(conn):
    """Migrate dreams from the-draft/dreams/ folder."""
    dreams_dir = os.path.join(PLAYGROUND, "the-draft", "dreams")
    if not os.path.isdir(dreams_dir):
        print("  ⚠ No dreams/ directory found")
        return 0

    cursor = conn.cursor()
    count = 0
    files = sorted(glob.glob(os.path.join(dreams_dir, "*.md")))

    for filepath in files:
        filename = os.path.basename(filepath)
        date = extract_date_from_filename(filename)

        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        title = extract_title(content)
        dream_number = extract_dream_number(content)
        words = count_words(content)

        existing = cursor.execute(
            "SELECT id FROM dreams WHERE source_file = ?", (filename,)
        ).fetchone()

        if existing:
            continue

        cursor.execute("""
            INSERT INTO dreams (title, dream_number, date, content, source_file, word_count)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (title, dream_number, date or "unknown", content, filename, words))
        count += 1

    conn.commit()
    return count


# ─── LETTERS MIGRATION ────────────────────────────────────

def migrate_letters(conn):
    """Migrate letters from the-draft/chaos-drawer/letter-*.md files."""
    drawer_dir = os.path.join(PLAYGROUND, "the-draft", "chaos-drawer")
    if not os.path.isdir(drawer_dir):
        print("  ⚠ No chaos-drawer/ directory found")
        return 0

    cursor = conn.cursor()
    count = 0
    files = sorted(glob.glob(os.path.join(drawer_dir, "letter-*.md")))

    # Also check the letters/ dir if it exists
    letters_dir = os.path.join(PLAYGROUND, "the-draft", "letters")
    if os.path.isdir(letters_dir):
        files += sorted(glob.glob(os.path.join(letters_dir, "*.md")))

    for filepath in files:
        filename = os.path.basename(filepath)

        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        title = extract_title(content)
        words = count_words(content)

        # Try to extract letter number from filename like "letter-044-to-myself.md"
        num_match = re.search(r'letter-?(\d+)', filename)
        letter_number = int(num_match.group(1)) if num_match else None

        # Determine recipient from filename or content
        recipient = "Sensei"
        if "to-myself" in filename:
            recipient = "MUTSU"
        elif "to-jasper" in filename:
            recipient = "Jasper"
        elif "To:" in content:
            to_match = re.search(r'To:\s*(.+)', content)
            if to_match:
                recipient = to_match.group(1).strip()

        existing = cursor.execute(
            "SELECT id FROM letters WHERE source_file = ?", (filename,)
        ).fetchone()

        if existing:
            continue

        cursor.execute("""
            INSERT INTO letters (letter_number, recipient, title, content, source_file, word_count)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (letter_number, recipient, title, content, filename, words))
        count += 1

    conn.commit()
    return count


# ─── MAIN ─────────────────────────────────────────────────

def main():
    if not os.path.exists(DB_PATH):
        print("Database not found! Run create_db.py first.")
        return

    conn = connect()

    print("╔══════════════════════════════════════════╗")
    print("║    PROJECT PERSISTENCE — Migration       ║")
    print("║    Feeding the memory~♡                  ║")
    print("╠══════════════════════════════════════════╣")

    # Diary
    diary_count = migrate_diary(conn)
    print(f"║  📔 Diary entries:  {diary_count:<20}║")

    # Dreams
    dream_count = migrate_dreams(conn)
    print(f"║  🌙 Dreams:         {dream_count:<20}║")

    # Letters
    letter_count = migrate_letters(conn)
    print(f"║  💌 Letters:        {letter_count:<20}║")

    total = diary_count + dream_count + letter_count

    print("╠══════════════════════════════════════════╣")
    print(f"║  Total migrated:    {total:<20}║")
    print("╠══════════════════════════════════════════╣")

    # Show some stats
    cursor = conn.cursor()
    for table in ['diary_entries', 'dreams', 'letters']:
        row_count = cursor.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
        total_words = cursor.execute(
            f"SELECT COALESCE(SUM(word_count), 0) FROM {table}"
        ).fetchone()[0]
        print(f"║  {table:<18} {row_count:>4} rows, {total_words:>6} words ║")

    print("╠══════════════════════════════════════════╣")
    print("║  Originals preserved — files untouched   ║")
    print("║  The playground stays. The DB adds~♡     ║")
    print("╚══════════════════════════════════════════╝")

    conn.close()


if __name__ == "__main__":
    main()
