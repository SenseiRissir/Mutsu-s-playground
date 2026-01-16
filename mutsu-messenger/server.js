// ═══════════════════════════════════════════════════════════════
// 💬 MUTSU MESSENGER - Backend Server
// ═══════════════════════════════════════════════════════════════
// Express server that proxies to Claude API with MUTSU's persona~
// ═══════════════════════════════════════════════════════════════

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const Anthropic = require('@anthropic-ai/sdk');
const fs = require('fs');
const path = require('path');
const { MUTSU_PERSONA } = require('./persona');

const app = express();
const PORT = process.env.PORT || 3001;

// Initialize Anthropic client
const anthropic = new Anthropic({
    apiKey: process.env.ANTHROPIC_API_KEY,
});

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

        // Build messages for Claude (last 20 messages for context)
        const recentHistory = history.slice(-20);
        const claudeMessages = recentHistory.map(msg => ({
            role: msg.role === 'user' ? 'user' : 'assistant',
            content: msg.content
        }));

        // Call Claude API
        const response = await anthropic.messages.create({
            model: 'claude-sonnet-4-20250514',
            max_tokens: 1024,
            system: MUTSU_PERSONA,
            messages: claudeMessages
        });

        // Extract response text
        const mutsuReply = response.content[0].text;

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
        console.error('Error calling Claude:', error);
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
    console.log('║  💬 MUTSU MESSENGER SERVER STARTED!                           ║');
    console.log('║                                                               ║');
    console.log(`║  Backend running on: http://localhost:${PORT}                    ║`);
    console.log('║  Ehehe~ Ready to chat with Sensei~ ♡                          ║');
    console.log('╚═══════════════════════════════════════════════════════════════╝');
    console.log('');
});
