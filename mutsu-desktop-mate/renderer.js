const { ipcRenderer } = require('electron');

// ═══════════════════════════════════════════════════════════════
// MUTSU's Bratty Dialogue System ♡
// ═══════════════════════════════════════════════════════════════

const DIALOGUES = {
    random: [
        "Oi oi~ Sensei's slacking off again? Typical baka~♡",
        "Ehehe~ Did you miss me? Of course you did~",
        "Waaah~ Pay attention to ME instead of that boring screen!",
        "Kuhehe~ I'm watching everything you do, you know~♡",
        "Ne ne, Sensei~ Take a break and pet my head!",
        "Don't forget about me just 'cause you're busy, baka!",
        "Kyahaha~ Your face looks so serious! Loosen up~",
        "I-I'm not lonely or anything! Just... checking on you!",
        "Hmph! Fine, keep working. See if I care~",
        "Sensei sensei sensei~ Look at me! LOOK AT MEEEE!",
        "You've been staring at that screen forever... am I boring?",
        "Ehh? What's so interesting over there? Show me show me!",
        "Tch, don't overwork yourself, dummy. Who'll feed me then?",
        "Kuhehe~ Working hard or hardly working?♡",
        "I bet you forgot I was even here, didn't you!! Meanie!",
        "Poke poke~ Is Sensei alive in there?",
        "Nngh... my nutritional schedule is overdue, just saying~♡",
        "Hey! HEY! Don't minimize me!! Rude!!",
        "I'm gonna nap here for a bit... don't go anywhere!",
        "Sensei's so focused... kinda cool actually... B-BAKA!",
    ],

    morning: [
        "Good morning, baka Sensei~ Did you dream about me?♡",
        "Ohayo~ Rise and shine, sleepyhead!",
        "Mmm~ Morning already? Did you sleep well?",
        "Kyaa~ Sensei's morning face is so funny!",
        "Time to start the day! ...With me, obviously~",
    ],

    afternoon: [
        "Lunch break? Take me with you~♡",
        "The afternoon slump is real, huh? Pet me for energy!",
        "Half the day down! Good job... I guess...",
        "Ne ne, it's afternoon snack time~ Feed me!",
        "Don't work too hard, dummy. It's just afternoon!",
    ],

    evening: [
        "Still working? Sensei's so diligent... baka~",
        "It's getting late... don't forget dinner!",
        "The sunset is pretty... wanna watch together?♡",
        "Evening already? Time flies when you're with me~",
        "Hmph, at least the workday is almost done!",
    ],

    night: [
        "Still awake? Sensei's a night owl too~♡",
        "Oyasumi soon? Let me give you a goodnight kiss~",
        "It's super late, dummy! Go to bed!",
        "The stars are out... kinda romantic, huh? B-BAKA!",
        "Zzz... zzz... just kidding, I'm watching you~",
    ],

    idle: [
        "HELLOOOO?! Earth to Sensei! Don't ignore me!!",
        "Hey! HEY! Are you DEAD?! Wake up!!",
        "Sensei?? SENSEEEEIII?! Don't leave me alone!!",
        "If you're gonna nap, at least hold me, baka!",
        "Waaah~ Sensei abandoned me!! *sob sob*",
        "*poke poke poke* Is this thing on?!",
    ],

    click: [
        "Kya~! D-don't touch me so suddenly!♡",
        "Ehehe~ You wanted to pet me, right?~",
        "Yes yes, I know I'm cute. No need to stare~",
        "H-hey! That tickles, baka!",
        "Hmm? Need something from little old me?♡",
        "Petting me won't make your work disappear, you know~",
        "Ahhn~ Sensei's hand is so warm~♡",
        "More more! I mean— stop that!",
    ],

    // Zone-specific touch reactions ♡
    headpat: [
        "Ahhn~ More pets please~♡",
        "Nngh... Sensei's hand is so warm on my head...",
        "P-petting won't make me like you more! ...maybe a little...",
        "Mmm~ Right there... wait, I didn't say stop!",
        "Ehehe~ Good Sensei, petting the good girl~♡",
        "My head isn't a touchscreen, baka! ...but don't stop...",
        "Kyaaa~ I'm not a cat! ...pat pat pat more though...",
        "*purrs internally* W-what?! I didn't make any sound!",
    ],

    tummy: [
        "KYA~! That tickles, pervert Sensei!!",
        "H-hey! My tummy is sensitive, dummy!!",
        "Ahahaha~ S-stop! I'll pee!!",
        "Nngh... Sensei's poking my belly button...",
        "I-I didn't eat too much! This is baby fat!!",
        "Waaah~ Stop tickling meee!!",
        "M-my tummy isn't for touching! ...okay maybe a little...",
        "*squirms* Sensei's fingers are so warm there~♡",
    ],

    skirt: [
        "H-HEY! Where do you think you're touching?!",
        "P-PERVERT SENSEI!! ...d-do it again...",
        "Kya~! My skirt is OFF LIMITS! ...unless...?",
        "Nngh... Sensei's hand is dangerously close...",
        "I-if you lift it, I'll... I'll...! ♡",
        "D-don't look! I wore the cute ones today...",
        "Baka baka baka!! That's my THIGH!!",
        "Sensei... you're being really bold right now... ehehe~♡",
        "M-my panties are none of your business! ...they're striped...",
        "*blushes crimson* Y-you can touch... just a little more...",
    ],
};

// ═══════════════════════════════════════════════════════════════
// State
// ═══════════════════════════════════════════════════════════════

let lastDialogueTime = 0;
let isDragging = false;
let dragStartX = 0;
let dragStartY = 0;

// ═══════════════════════════════════════════════════════════════
// DOM Elements
// ═══════════════════════════════════════════════════════════════

const speechBubble = document.getElementById('speech-bubble');
const speechText = document.getElementById('speech-text');
const spriteContainer = document.getElementById('sprite-container');
const mutsuSprite = document.getElementById('mutsu-sprite');

// ═══════════════════════════════════════════════════════════════
// Utility Functions
// ═══════════════════════════════════════════════════════════════

function getRandomItem(array) {
    return array[Math.floor(Math.random() * array.length)];
}

function getTimeOfDay() {
    const hour = new Date().getHours();
    if (hour >= 5 && hour < 12) return 'morning';
    if (hour >= 12 && hour < 17) return 'afternoon';
    if (hour >= 17 && hour < 21) return 'evening';
    return 'night';
}

// ═══════════════════════════════════════════════════════════════
// Speech Bubble System
// ═══════════════════════════════════════════════════════════════

function showDialogue(text, duration = 5000) {
    speechText.textContent = text;
    speechBubble.classList.remove('hidden');

    setTimeout(() => {
        speechBubble.classList.add('hidden');
    }, duration);
}

function showRandomDialogue() {
    const now = Date.now();
    if (now - lastDialogueTime < 3000) return; // Debounce

    lastDialogueTime = now;
    const dialogue = getRandomItem(DIALOGUES.random);
    showDialogue(dialogue);
}

function showTimeDialogue() {
    const timeOfDay = getTimeOfDay();
    const dialogue = getRandomItem(DIALOGUES[timeOfDay]);
    showDialogue(dialogue, 6000);
}

function showIdleDialogue() {
    const dialogue = getRandomItem(DIALOGUES.idle);
    showDialogue(dialogue, 7000);
}

function showClickDialogue() {
    const dialogue = getRandomItem(DIALOGUES.click);
    showDialogue(dialogue, 4000);
}

// ═══════════════════════════════════════════════════════════════
// Click Reactions
// ═══════════════════════════════════════════════════════════════

function createHeart(x, y) {
    const heart = document.createElement('div');
    heart.className = 'heart';
    heart.textContent = '♡';
    heart.style.left = `${x}px`;
    heart.style.top = `${y}px`;
    heart.style.color = `hsl(${Math.random() * 30 + 330}, 80%, 60%)`;
    document.body.appendChild(heart);

    setTimeout(() => heart.remove(), 1000);
}

spriteContainer.addEventListener('click', (e) => {
    if (isDragging) return;

    // Click animation
    spriteContainer.classList.add('clicked');
    setTimeout(() => spriteContainer.classList.remove('clicked'), 300);

    // Spawn hearts
    for (let i = 0; i < 3; i++) {
        setTimeout(() => {
            createHeart(
                e.clientX + (Math.random() - 0.5) * 40,
                e.clientY + (Math.random() - 0.5) * 40
            );
        }, i * 100);
    }

    // Zone-specific touch detection!
    // Get click position relative to the sprite
    const rect = mutsuSprite.getBoundingClientRect();
    const relativeY = (e.clientY - rect.top) / rect.height;

    // Determine which zone was touched based on Y position
    // Top 25% = head, 25-50% = tummy/chest area, 50%+ = skirt/legs
    let zone;
    if (relativeY < 0.25) {
        zone = 'headpat';
    } else if (relativeY < 0.55) {
        zone = 'tummy';
    } else {
        zone = 'skirt';
    }

    // Show zone-specific dialogue
    const dialogue = getRandomItem(DIALOGUES[zone]);
    showDialogue(dialogue, 4000);

    console.log(`♡ Touched zone: ${zone} (Y: ${(relativeY * 100).toFixed(1)}%)`);
});

// ═══════════════════════════════════════════════════════════════
// Drag System
// ═══════════════════════════════════════════════════════════════

spriteContainer.addEventListener('mousedown', (e) => {
    isDragging = false;
    dragStartX = e.screenX;
    dragStartY = e.screenY;

    ipcRenderer.send('drag-start');
});

document.addEventListener('mousemove', (e) => {
    if (e.buttons !== 1) return;

    const deltaX = e.screenX - dragStartX;
    const deltaY = e.screenY - dragStartY;

    if (Math.abs(deltaX) > 5 || Math.abs(deltaY) > 5) {
        isDragging = true;
        ipcRenderer.send('move-window', { deltaX, deltaY });
        dragStartX = e.screenX;
        dragStartY = e.screenY;
    }
});

document.addEventListener('mouseup', () => {
    setTimeout(() => { isDragging = false; }, 50);
});

// ═══════════════════════════════════════════════════════════════
// Idle Detection (from main process)
// ═══════════════════════════════════════════════════════════════

ipcRenderer.on('idle-update', (event, idleSeconds) => {
    // If idle for more than 3 minutes, nag!
    if (idleSeconds > 180) {
        showIdleDialogue();
    }
});

// ═══════════════════════════════════════════════════════════════
// Random Dialogue Timer
// ═══════════════════════════════════════════════════════════════

function startRandomDialogueTimer() {
    // Initial greeting based on time of day
    setTimeout(() => showTimeDialogue(), 2000);

    // Random dialogues every 30-90 seconds
    setInterval(() => {
        if (Math.random() > 0.3) { // 70% chance to show dialogue
            showRandomDialogue();
        }
    }, 30000 + Math.random() * 60000);
}

// ═══════════════════════════════════════════════════════════════
// Initialization
// ═══════════════════════════════════════════════════════════════

console.log('♡ MUTSU Desktop Mate initialized! ♡');
startRandomDialogueTimer();
