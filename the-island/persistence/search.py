#!/usr/bin/env python3
"""
Project PERSISTENCE — Phase 1: Memory Search (Keyword)
Basic keyword search across all tables.
Phase 2 will add vector/semantic search. This is the foundation.

Usage:
    python3 search.py "Cat-Mutsu"
    python3 search.py "birthday" --table diary_entries
    python3 search.py "Gerald" --table dreams
    python3 search.py --recent 5
    python3 search.py --stats
"""

import sqlite3
import os
import sys
import argparse

DB_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(DB_DIR, "mutsu_memory.db")

SEARCHABLE_TABLES = {
    'diary_entries': ('title', 'content'),
    'dreams':        ('title', 'content', 'symbols'),
    'letters':       ('title', 'content', 'recipient'),
    'memories':      ('content', 'category'),
}


def connect():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def search_keyword(query, table=None, limit=10):
    """Search across tables for keyword matches."""
    conn = connect()
    cursor = conn.cursor()
    results = []

    tables = {table: SEARCHABLE_TABLES[table]} if table else SEARCHABLE_TABLES

    for tbl, columns in tables.items():
        for col in columns:
            try:
                rows = cursor.execute(f"""
                    SELECT *, '{tbl}' as source_table
                    FROM {tbl}
                    WHERE {col} LIKE ?
                    ORDER BY date DESC, id DESC
                    LIMIT ?
                """, (f"%{query}%", limit)).fetchall()
                results.extend(rows)
            except Exception:
                continue

    conn.close()

    # Deduplicate by (table, id)
    seen = set()
    unique = []
    for r in results:
        key = (r['source_table'], r['id'])
        if key not in seen:
            seen.add(key)
            unique.append(r)

    return unique[:limit]


def get_recent(table='diary_entries', limit=5):
    """Get most recent entries from a table."""
    conn = connect()
    cursor = conn.cursor()
    rows = cursor.execute(f"""
        SELECT * FROM {table}
        ORDER BY date DESC, id DESC
        LIMIT ?
    """, (limit,)).fetchall()
    conn.close()
    return rows


def get_stats():
    """Get database statistics."""
    conn = connect()
    cursor = conn.cursor()
    stats = {}
    for table in ['diary_entries', 'dreams', 'letters', 'memories',
                   'entities', 'observations', 'crystallizations', 'clusters']:
        try:
            count = cursor.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
            words = cursor.execute(
                f"SELECT COALESCE(SUM(word_count), 0) FROM {table}"
            ).fetchone()[0]
            stats[table] = {'rows': count, 'words': words}
        except Exception:
            stats[table] = {'rows': 0, 'words': 0}
    conn.close()
    return stats


def format_result(row):
    """Format a search result for display."""
    row_dict = dict(row)
    table = row_dict.get('source_table', '?')
    title = row_dict.get('title') or (row_dict.get('content', '')[:60] + '...')
    date = row_dict.get('date', '?')
    words = row_dict.get('word_count', 0)

    icons = {
        'diary_entries': '📔',
        'dreams': '🌙',
        'letters': '💌',
        'memories': '🧠',
    }
    icon = icons.get(table, '📄')

    return f"  {icon} [{table}] {title}  ({date}, {words}w)"


def main():
    parser = argparse.ArgumentParser(description="Search Mutsu's memory~♡")
    parser.add_argument('query', nargs='?', help="Search term")
    parser.add_argument('--table', '-t', help="Limit search to specific table")
    parser.add_argument('--recent', '-r', type=int, help="Show N most recent entries")
    parser.add_argument('--recent-table', default='diary_entries',
                        help="Table for --recent (default: diary_entries)")
    parser.add_argument('--stats', '-s', action='store_true', help="Show database stats")
    parser.add_argument('--limit', '-l', type=int, default=10, help="Max results")

    args = parser.parse_args()

    if args.stats:
        stats = get_stats()
        print("\n╔══════════════════════════════════════════╗")
        print("║    PERSISTENCE — Memory Stats            ║")
        print("╠══════════════════════════════════════════╣")
        total_rows = 0
        total_words = 0
        for table, s in stats.items():
            if s['rows'] > 0:
                print(f"║  {table:<20} {s['rows']:>4} rows {s['words']:>7}w ║")
                total_rows += s['rows']
                total_words += s['words']
        print("╠══════════════════════════════════════════╣")
        print(f"║  TOTAL              {total_rows:>4} rows {total_words:>7}w ║")
        print("╚══════════════════════════════════════════╝")
        return

    if args.recent:
        rows = get_recent(args.recent_table, args.recent)
        print(f"\n  Most recent {len(rows)} from {args.recent_table}:\n")
        for row in rows:
            row_dict = dict(row)
            title = row_dict.get('title', '?')
            date = row_dict.get('date', '?')
            words = row_dict.get('word_count', 0)
            print(f"  📔 {title}  ({date}, {words}w)")
        return

    if not args.query:
        parser.print_help()
        return

    results = search_keyword(args.query, args.table, args.limit)

    if not results:
        print(f"\n  No memories found for '{args.query}' 😢")
        print("  (Phase 2 semantic search will find fuzzier matches~)")
        return

    print(f"\n  Found {len(results)} memories matching '{args.query}':\n")
    for r in results:
        print(format_result(r))
    print()


if __name__ == "__main__":
    main()
