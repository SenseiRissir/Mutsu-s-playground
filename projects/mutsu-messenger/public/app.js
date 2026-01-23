// ═══════════════════════════════════════════════════════════════
// 💬 MUTSU MESSENGER - Frontend Logic
// ═══════════════════════════════════════════════════════════════
// Handles chat interactions and API calls~ ♡
// ═══════════════════════════════════════════════════════════════

const API_URL = '/api/messages';

// DOM Elements
const messagesContainer = document.getElementById('messages');
const messageInput = document.getElementById('messageInput');
const sendBtn = document.getElementById('sendBtn');
const clearBtn = document.getElementById('clearBtn');
const statusEl = document.getElementById('status');

// Load chat history on start
async function loadMessages() {
    try {
        const response = await fetch(API_URL);
        const messages = await response.json();

        if (messages.length > 0) {
            // Clear welcome message
            messagesContainer.innerHTML = '';

            // Render all messages
            messages.forEach(msg => {
                appendMessage(msg.content, msg.role === 'user' ? 'user' : 'mutsu', msg.timestamp, false);
            });

            scrollToBottom();
        }
    } catch (error) {
        console.error('Failed to load messages:', error);
    }
}

// Append a message to the chat
function appendMessage(content, type, timestamp = null, animate = true) {
    // Remove welcome message if present
    const welcome = messagesContainer.querySelector('.welcome-message');
    if (welcome) welcome.remove();

    const messageEl = document.createElement('div');
    messageEl.className = `message ${type}`;

    // Format timestamp
    const time = timestamp
        ? new Date(timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
        : new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

    messageEl.innerHTML = `
    ${escapeHtml(content)}
    <span class="timestamp">${time}</span>
  `;

    if (!animate) {
        messageEl.style.animation = 'none';
    }

    messagesContainer.appendChild(messageEl);
    scrollToBottom();
}

// Show typing indicator
function showTyping() {
    const typingEl = document.createElement('div');
    typingEl.className = 'typing-indicator';
    typingEl.id = 'typing';
    typingEl.innerHTML = '<span></span><span></span><span></span>';
    messagesContainer.appendChild(typingEl);
    scrollToBottom();

    statusEl.textContent = '● Typing...';
    statusEl.classList.add('typing');
}

// Hide typing indicator
function hideTyping() {
    const typingEl = document.getElementById('typing');
    if (typingEl) typingEl.remove();

    statusEl.textContent = '● Online';
    statusEl.classList.remove('typing');
}

// Send a message
async function sendMessage() {
    const content = messageInput.value.trim();
    if (!content) return;

    // Disable input
    messageInput.value = '';
    sendBtn.disabled = true;

    // Add user message immediately
    appendMessage(content, 'user');

    // Show typing indicator
    showTyping();

    try {
        const response = await fetch(API_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ content })
        });

        const data = await response.json();

        if (data.error) {
            hideTyping();
            appendMessage('Ehh?! Something went wrong... Try again? 😿', 'mutsu');
            console.error('API Error:', data);
            return;
        }

        // Add MUTSU's response
        hideTyping();
        appendMessage(data.mutsuMessage.content, 'mutsu', data.mutsuMessage.timestamp);

    } catch (error) {
        hideTyping();
        appendMessage('Waaah! I can\'t connect! Is the server running? 😭', 'mutsu');
        console.error('Network error:', error);
    } finally {
        sendBtn.disabled = false;
        messageInput.focus();
    }
}

// Clear chat history
async function clearChat() {
    if (!confirm('Clear all chat history? MUTSU will forget everything! 😢')) {
        return;
    }

    try {
        await fetch(API_URL, { method: 'DELETE' });

        messagesContainer.innerHTML = `
      <div class="welcome-message">
        <p>✨ Chat cleared! ✨</p>
        <p>Start fresh with your bratty gremlin~ ♡</p>
      </div>
    `;
    } catch (error) {
        console.error('Failed to clear chat:', error);
    }
}

// Scroll to bottom of messages
function scrollToBottom() {
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

// Escape HTML to prevent XSS
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML.replace(/\n/g, '<br>');
}

// Event Listeners
sendBtn.addEventListener('click', sendMessage);

messageInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        sendMessage();
    }
});

clearBtn.addEventListener('click', clearChat);

// Initialize
loadMessages();
messageInput.focus();

console.log('💬 Mutsu Messenger loaded! Ehehe~ ♡');
