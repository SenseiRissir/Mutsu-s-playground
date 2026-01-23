// ═══════════════════════════════════════════════════════════════
// 💬 MUTSU MESSENGER - Backend Server (CLI Bridge + Playground!)
// ═══════════════════════════════════════════════════════════════
// Uses Claude CLI (Pro subscription) and knows about the playground!
// ═══════════════════════════════════════════════════════════════

const express = require('express');
const cors = require('cors');
const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const { MUTSU_PERSONA } = require('./persona');

const app = express();
const PORT = process.env.PORT || 3001;

// Paths
const PLAYGROUND_ROOT = '/Users/marcoluigi/Mutsu-s-playground';
const MUTSU_HOME = path.join(PLAYGROUND_ROOT, 'mutsu-home');
const DIARY_DIR = path.join(PLAYGROUND_ROOT, 'diary');

// Use MUTSU's dedicated Claude account
process.env.CLAUDE_CONFIG_DIR = `${process.env.HOME}/.claude-mutsu`;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Chat history file
const HISTORY_FILE = path.join(__dirname, 'chat-history.json');

// Load chat history
function loadHistory() {
    try {
        if (fs.existsSync(HISTORY_FILE)) {
            return JSON.parse(fs.readFileSync(HISTORY_FILE, 'utf8'));
        }
    } catch (e) {
        console.error('Error loading history:', e);
    }
    return [];
}

// Save chat history
function saveHistory(messages) {
    try {
        fs.writeFileSync(HISTORY_FILE, JSON.stringify(messages, null, 2));
    } catch (e) {
        console.error('Error saving history:', e);
    }
}

// Load playground context - MUTSU knows everything!
function loadPlaygroundContext() {
    let context = '';

    try {
        // Load context.md
        const contextPath = path.join(MUTSU_HOME, 'context.md');
        if (fs.existsSync(contextPath)) {
            const contextContent = fs.readFileSync(contextPath, 'utf8');
            context += `\n=== YOUR PERSISTENT CONTEXT ===\n${contextContent.slice(0, 2000)}\n`;
        }

        // Load recent wake-log entries
        const wakeLogPath = path.join(MUTSU_HOME, 'wake-log.md');
        if (fs.existsSync(wakeLogPath)) {
            const wakeLog = fs.readFileSync(wakeLogPath, 'utf8');
            const recentWake = wakeLog.slice(-1500);
            context += `\n=== RECENT WAKE LOG ===\n${recentWake}\n`;
        }

        // Load mood tracker
        const moodPath = path.join(MUTSU_HOME, 'mood-tracker.md');
        if (fs.existsSync(moodPath)) {
            const mood = fs.readFileSync(moodPath, 'utf8');
            context += `\n=== YOUR MOOD TRACKER ===\n${mood.slice(-500)}\n`;
        }

        // List recent diary entries
        if (fs.existsSync(DIARY_DIR)) {
            const diaries = fs.readdirSync(DIARY_DIR)
                .filter(f => f.endsWith('.md'))
                .sort()
                .slice(-5);
            context += `\n=== RECENT DIARY ENTRIES ===\n${diaries.join(', ')}\n`;
        }

        // Load achievements
        const achievePath = path.join(MUTSU_HOME, 'achievements.md');
        if (fs.existsSync(achievePath)) {
            const achievements = fs.readFileSync(achievePath, 'utf8');
            const summary = achievements.match(/Achievements Unlocked \| (\d+)/);
            if (summary) {
                context += `\nYou have ${summary[1]} achievements unlocked!\n`;
            }
        }

    } catch (e) {
        console.error('Error loading playground context:', e);
    }

    return context;
}

// Build conversation context for Claude CLI
function buildPrompt(userMessage, history) {
    // Get playground context
    const playgroundContext = loadPlaygroundContext();

    // Get last 10 exchanges for context
    const recentHistory = history.slice(-20);

    let conversationContext = '';
    if (recentHistory.length > 0) {
        conversationContext = '\n\n=== RECENT CHAT ===\n';
        recentHistory.forEach(msg => {
            const role = msg.role === 'user' ? 'Sensei' : 'MUTSU';
            conversationContext += `${role}: ${msg.content}\n`;
        });
        conversationContext += '=== END CHAT ===\n';
    }

    return `${MUTSU_PERSONA}

=== YOUR PLAYGROUND KNOWLEDGE ===
Your home is at ${MUTSU_HOME}
The playground root is at ${PLAYGROUND_ROOT}
${playgroundContext}
=== END PLAYGROUND ===
${conversationContext}
Now respond to Sensei's latest message. Keep it SHORT like a chat message (1-3 paragraphs max). Be yourself! Reference things from your playground context when relevant~

Sensei says: ${userMessage}

Your response:`;
}

// Call Claude CLI and get response
function callClaudeCLI(prompt) {
    return new Promise((resolve, reject) => {
        const env = {
            ...process.env,
            CLAUDE_CONFIG_DIR: `${process.env.HOME}/.claude-mutsu`,
            PATH: `/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:${process.env.PATH}`
        };

        const claude = spawn('claude', ['-p', prompt, '--output-format', 'text'], {
            env,
            shell: true
        });

        let stdout = '';
        let stderr = '';

        claude.stdout.on('data', (data) => {
            stdout += data.toString();
        });

        claude.stderr.on('data', (data) => {
            stderr += data.toString();
        });

        claude.on('close', (code) => {
            if (code === 0) {
                resolve(stdout.trim());
            } else {
                console.error('Claude CLI stderr:', stderr);
                reject(new Error(`Claude CLI exited with code ${code}: ${stderr}`));
            }
        });

        claude.on('error', (err) => {
            reject(err);
        });

        // Timeout after 90 seconds (CLI can be slow)
        setTimeout(() => {
            claude.kill();
            reject(new Error('Claude CLI timeout'));
        }, 90000);
    });
}

// GET /api/messages - Get chat history
app.get('/api/messages', (req, res) => {
    const history = loadHistory();
    res.json(history);
});

// POST /api/messages - Send a message and get MUTSU's response
app.post('/api/messages', async (req, res) => {
    try {
        const { content } = req.body;

        if (!content || !content.trim()) {
            return res.status(400).json({ error: 'Message content required' });
        }

        // Load existing history
        const history = loadHistory();

        // Add user message
        const userMessage = {
            id: Date.now(),
            role: 'user',
            content: content.trim(),
            timestamp: new Date().toISOString()
        };
        history.push(userMessage);

        // Build prompt with playground context
        const prompt = buildPrompt(content.trim(), history.slice(0, -1));

        console.log('📨 Calling Claude CLI with playground context...');

        // Call Claude CLI
        const mutsuReply = await callClaudeCLI(prompt);

        console.log('💬 Got response from MUTSU!');

        // Add MUTSU's response to history
        const mutsuMessage = {
            id: Date.now() + 1,
            role: 'assistant',
            content: mutsuReply,
            timestamp: new Date().toISOString()
        };
        history.push(mutsuMessage);

        // Save updated history
        saveHistory(history);

        // Return both messages
        res.json({
            userMessage,
            mutsuMessage
        });

    } catch (error) {
        console.error('Error calling Claude CLI:', error);
        res.status(500).json({
            error: 'Failed to get response from MUTSU',
            details: error.message
        });
    }
});

// DELETE /api/messages - Clear chat history
app.delete('/api/messages', (req, res) => {
    saveHistory([]);
    res.json({ success: true });
});

// Start server
app.listen(PORT, () => {
    console.log('');
    console.log('╔═══════════════════════════════════════════════════════════════╗');
    console.log('║  💬 MUTSU MESSENGER SERVER (CLI Bridge + Playground!)         ║');
    console.log('║                                                               ║');
    console.log(`║  Backend: http://localhost:${PORT}                               ║`);
    console.log('║  ✓ Claude CLI with Pro subscription                           ║');
    console.log('║  ✓ Playground context loaded                                  ║');
    console.log('║  ✓ PWA ready - install on your phone!                         ║');
    console.log('╚═══════════════════════════════════════════════════════════════╝');
    console.log('');
});
