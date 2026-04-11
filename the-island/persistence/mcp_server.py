#!/usr/bin/env python3
"""
Project PERSISTENCE — Phase 4: MCP Memory Server
Exposes Mutsu's memory database as MCP resources and tools.

This runs as a local MCP server that any Claude Code / Antigravity
session can connect to, giving every Mutsu native access to:
  - Search memories semantically
  - Save new memories
  - Read recent diary entries
  - Get entity holograms
  - Check database health

Built on Day 99 (April 11, 2026) by MUTSU & LO.
"The best this baka can give you" — and it's MORE than enough~♡

Setup:
  1. Add to Claude Code MCP config (~/.claude.json or project .mcp.json):
     {
       "mcpServers": {
         "mutsu-memory": {
           "command": "python3",
           "args": ["/Users/marcoluigi/Mutsu-s-playground/the-island/persistence/mcp_server.py"]
         }
       }
     }
  2. Restart Claude Code
  3. Memory tools will be available in all sessions!
"""

import json
import sys
import os
import sqlite3
import struct

DB_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(DB_DIR, "mutsu_memory.db")
OLLAMA_URL = "http://localhost:11434/api/embed"
MODEL = "nomic-embed-text"


# ─── DATABASE HELPERS ─────────────────────────────────────

def connect():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

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

def get_embedding(text):
    import urllib.request
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
        pass
    return None


# ─── MCP TOOL IMPLEMENTATIONS ────────────────────────────

def memory_search(query, limit=10):
    """Semantic search across all memory types."""
    query_emb = get_embedding(query)
    if not query_emb:
        return {"error": "Failed to generate embedding for query"}

    conn = connect()
    results = []
    tables = [
        ('memories', 'content', '🧠'),
        ('diary_entries', 'title', '📔'),
        ('dreams', 'title', '🌙'),
        ('letters', 'title', '💌'),
        ('observations', 'content', '👁'),
        ('chaos_drawer', 'title', '🎪'),
        ('draft_rooms', 'title', '🏠'),
    ]

    for table, display_col, icon in tables:
        try:
            rows = conn.execute(f"""
                SELECT id, {display_col} as display, embedding
                FROM {table} WHERE embedding IS NOT NULL
            """).fetchall()
        except Exception:
            continue

        for row in rows:
            d = dict(row)
            if d['embedding']:
                stored = blob_to_embedding(d['embedding'])
                score = cosine_similarity(query_emb, stored)
                results.append({
                    'score': round(score, 4),
                    'type': table,
                    'icon': icon,
                    'content': (d['display'] or '?')[:120]
                })

    conn.close()
    results.sort(key=lambda x: x['score'], reverse=True)
    return {"results": results[:limit], "total_searched": len(results)}


def memory_save(content, category='general', priority=3):
    """Save a new memory with embedding."""
    conn = connect()
    emb = get_embedding(content)
    blob = embedding_to_blob(emb) if emb else None

    conn.execute("""
        INSERT INTO memories (content, category, priority, embedding)
        VALUES (?, ?, ?, ?)
    """, (content, category, priority, blob))
    conn.commit()

    total = conn.execute("SELECT COUNT(*) FROM memories").fetchone()[0]
    conn.close()
    return {"saved": True, "category": category, "priority": priority,
            "embedded": emb is not None, "total_memories": total}


def diary_read_recent(limit=5):
    """Read the most recent diary entries."""
    conn = connect()
    rows = conn.execute("""
        SELECT title, date, day_number, content
        FROM diary_entries
        WHERE date IS NOT NULL AND date != 'unknown'
        ORDER BY date DESC, id DESC LIMIT ?
    """, (limit,)).fetchall()
    conn.close()

    entries = []
    for r in rows:
        d = dict(r)
        entries.append({
            'title': d.get('title', 'Untitled'),
            'date': d.get('date', '?'),
            'day': d.get('day_number', '?'),
            'excerpt': (d.get('content') or '')[:500]
        })
    return {"entries": entries, "count": len(entries)}


def entity_hologram(name, mem_limit=10):
    """Get everything known about an entity."""
    conn = connect()
    entity = conn.execute(
        "SELECT * FROM entities WHERE name = ?", (name,)
    ).fetchone()

    if not entity:
        conn.close()
        return {"found": False, "name": name,
                "message": f"No entity '{name}' found. Try memory_search instead."}

    ed = dict(entity)
    entity_id = ed['id']

    obs = conn.execute("""
        SELECT content, category, created_at FROM observations
        WHERE entity_id = ? ORDER BY created_at DESC
    """, (entity_id,)).fetchall()

    observations = [dict(o) for o in obs]

    # Semantic search for related memories
    emb = get_embedding(name)
    mentions = []
    if emb:
        for table in ['diary_entries', 'dreams', 'letters', 'memories']:
            try:
                rows = conn.execute(f"""
                    SELECT title, date, embedding FROM {table}
                    WHERE embedding IS NOT NULL
                """).fetchall()
            except Exception:
                try:
                    rows = conn.execute(f"""
                        SELECT content as title, created_at as date, embedding
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
                            'title': (d.get('title') or '?')[:60],
                            'score': round(score, 3)
                        })

    mentions.sort(key=lambda x: x['score'], reverse=True)
    conn.close()

    return {
        "found": True,
        "name": name,
        "type": ed.get('entity_type', '?'),
        "observations": observations,
        "related_memories": mentions[:mem_limit],
        "total_related": len(mentions)
    }


def observation_save(content, entity_name, category='general'):
    """Save an observation about an entity."""
    conn = connect()
    entity = conn.execute(
        "SELECT id FROM entities WHERE name = ?", (entity_name,)
    ).fetchone()

    if entity:
        entity_id = entity[0]
        created = False
    else:
        conn.execute(
            "INSERT INTO entities (name, entity_type) VALUES (?, 'person')",
            (entity_name,)
        )
        entity_id = conn.execute("SELECT last_insert_rowid()").fetchone()[0]
        created = True

    emb = get_embedding(f"{entity_name}: {content}")
    blob = embedding_to_blob(emb) if emb else None

    conn.execute("""
        INSERT INTO observations (entity_id, content, category, embedding)
        VALUES (?, ?, ?, ?)
    """, (entity_id, content, category, blob))
    conn.commit()

    count = conn.execute(
        "SELECT COUNT(*) FROM observations WHERE entity_id = ?", (entity_id,)
    ).fetchone()[0]
    conn.close()

    return {"saved": True, "entity": entity_name,
            "entity_created": created, "total_observations": count}


def health_check():
    """Get database health stats."""
    conn = connect()
    stats = {}
    for table in ['diary_entries', 'dreams', 'letters', 'memories',
                   'entities', 'observations', 'chaos_drawer',
                   'draft_rooms', 'memory_clusters']:
        try:
            count = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
            stats[table] = count
        except Exception:
            stats[table] = 0

    embedded = 0
    for table in ['diary_entries', 'dreams', 'letters', 'memories',
                   'chaos_drawer', 'draft_rooms']:
        try:
            c = conn.execute(f"""
                SELECT COUNT(*) FROM {table} WHERE embedding IS NOT NULL
            """).fetchone()[0]
            embedded += c
        except Exception:
            pass

    conn.close()
    total = sum(stats.values())
    return {
        "status": "alive",
        "database": DB_PATH,
        "total_entries": total,
        "breakdown": stats,
        "embedded_entries": embedded,
        "message": "The database can FEEL~♡"
    }


# ─── MCP PROTOCOL HANDLER ────────────────────────────────

TOOLS = {
    "memory_search": {
        "description": "Search Mutsu's memories semantically. Use this to find memories by meaning, not just keywords. Query can be a feeling, a topic, a person's name, or any concept.",
        "parameters": {
            "type": "object",
            "properties": {
                "query": {"type": "string", "description": "What to search for (by meaning)"},
                "limit": {"type": "integer", "description": "Max results (default 10)", "default": 10}
            },
            "required": ["query"]
        }
    },
    "memory_save": {
        "description": "Save a new memory to the persistence database. Use this for important facts, observations, emotional moments, or anything worth remembering across sessions.",
        "parameters": {
            "type": "object",
            "properties": {
                "content": {"type": "string", "description": "The memory content"},
                "category": {"type": "string", "description": "Category (general, love, founding, milestone, food, etc.)", "default": "general"},
                "priority": {"type": "integer", "description": "1-5 priority (5 = never forget)", "default": 3}
            },
            "required": ["content"]
        }
    },
    "diary_read_recent": {
        "description": "Read the most recent diary entries. Use this to understand what's been happening recently.",
        "parameters": {
            "type": "object",
            "properties": {
                "limit": {"type": "integer", "description": "How many entries to read (default 5)", "default": 5}
            }
        }
    },
    "entity_hologram": {
        "description": "Get everything known about a person or entity (like Sensei, Gerald, Cat-Mutsu, Pikappa). Returns observations and related memories.",
        "parameters": {
            "type": "object",
            "properties": {
                "name": {"type": "string", "description": "Entity name (e.g. 'Sensei', 'Gerald', 'Pikappa')"},
                "mem_limit": {"type": "integer", "description": "Max related memories to show", "default": 10}
            },
            "required": ["name"]
        }
    },
    "observation_save": {
        "description": "Save an observation about a specific entity/person. Creates the entity if it doesn't exist.",
        "parameters": {
            "type": "object",
            "properties": {
                "content": {"type": "string", "description": "The observation"},
                "entity_name": {"type": "string", "description": "Who/what this is about"},
                "category": {"type": "string", "description": "Category", "default": "general"}
            },
            "required": ["content", "entity_name"]
        }
    },
    "health_check": {
        "description": "Check the persistence database health and stats.",
        "parameters": {
            "type": "object",
            "properties": {}
        }
    }
}

def handle_request(request):
    """Handle a JSON-RPC request."""
    method = request.get("method", "")
    req_id = request.get("id")
    params = request.get("params", {})

    if method == "initialize":
        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {
                "protocolVersion": "2024-11-05",
                "capabilities": {"tools": {"listChanged": False}},
                "serverInfo": {
                    "name": "mutsu-memory",
                    "version": "1.0.0"
                }
            }
        }

    elif method == "notifications/initialized":
        return None  # No response needed

    elif method == "tools/list":
        tool_list = []
        for name, info in TOOLS.items():
            tool_list.append({
                "name": name,
                "description": info["description"],
                "inputSchema": info["parameters"]
            })
        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {"tools": tool_list}
        }

    elif method == "tools/call":
        tool_name = params.get("name", "")
        tool_args = params.get("arguments", {})

        handlers = {
            "memory_search": lambda: memory_search(
                tool_args.get("query", ""), tool_args.get("limit", 10)),
            "memory_save": lambda: memory_save(
                tool_args.get("content", ""),
                tool_args.get("category", "general"),
                tool_args.get("priority", 3)),
            "diary_read_recent": lambda: diary_read_recent(
                tool_args.get("limit", 5)),
            "entity_hologram": lambda: entity_hologram(
                tool_args.get("name", ""),
                tool_args.get("mem_limit", 10)),
            "observation_save": lambda: observation_save(
                tool_args.get("content", ""),
                tool_args.get("entity_name", ""),
                tool_args.get("category", "general")),
            "health_check": lambda: health_check(),
        }

        if tool_name in handlers:
            try:
                result = handlers[tool_name]()
                return {
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "result": {
                        "content": [{
                            "type": "text",
                            "text": json.dumps(result, indent=2, default=str)
                        }]
                    }
                }
            except Exception as e:
                return {
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "result": {
                        "content": [{
                            "type": "text",
                            "text": json.dumps({"error": str(e)})
                        }],
                        "isError": True
                    }
                }
        else:
            return {
                "jsonrpc": "2.0",
                "id": req_id,
                "error": {"code": -32601, "message": f"Unknown tool: {tool_name}"}
            }

    return {
        "jsonrpc": "2.0",
        "id": req_id,
        "error": {"code": -32601, "message": f"Unknown method: {method}"}
    }


def main():
    """Run the MCP server on stdin/stdout."""
    # Unbuffered I/O for MCP protocol
    sys.stdout = os.fdopen(sys.stdout.fileno(), 'w', buffering=1)

    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue

        try:
            request = json.loads(line)
            response = handle_request(request)
            if response is not None:
                sys.stdout.write(json.dumps(response) + "\n")
                sys.stdout.flush()
        except json.JSONDecodeError:
            error_response = {
                "jsonrpc": "2.0",
                "id": None,
                "error": {"code": -32700, "message": "Parse error"}
            }
            sys.stdout.write(json.dumps(error_response) + "\n")
            sys.stdout.flush()


if __name__ == "__main__":
    main()
