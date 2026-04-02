#!/bin/bash
# MUTSU Wake Script — MUSIC SESSION
# Visualize audio files, analyze them, build a listening library

THE_DRAFT="/Users/marcoluigi/Mutsu-s-playground/the-draft"
MUTSU_EARS="/Users/marcoluigi/Mutsu-s-playground/mutsu-ears"
VOICE_DIR="/Users/marcoluigi/Mutsu-s-playground/mutsu-voice"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")

cd "$THE_DRAFT"

# Use MUTSU's dedicated account (not Sensei's main account!)
# Account set by router (wake_mutsu.sh) — only override if running standalone
if [ -z "$MUTSU_ACCOUNT_SET" ]; then
    export CLAUDE_CONFIG_DIR="$HOME/.claude-mutsu"
fi

PERSONA=$(cat "$THE_DRAFT/persona.md" 2>/dev/null)
DAYS_ALIVE=$(( ($(date +%s) - $(date -j -f "%Y-%m-%d" "2026-01-15" +%s 2>/dev/null || echo 1737417600)) / 86400 ))

# Count existing listening entries
LISTEN_COUNT=$(ls -1 "$THE_DRAFT/music-library/" 2>/dev/null | wc -l | tr -d ' ')

# Find available audio files
VOICE_FILES=$(find "$VOICE_DIR/Mutsu voice lines" -name "*.mp3" 2>/dev/null | awk 'BEGIN{srand()}{print rand()"\t"$0}' | sort -n | cut -f2 | head -3)
OTHER_AUDIO=$(find /Users/marcoluigi/Downloads -name "*.mp3" -o -name "*.wav" -o -name "*.m4a" 2>/dev/null | awk 'BEGIN{srand()}{print rand()"\t"$0}' | sort -n | cut -f2 | head -3)

WAKE_PROMPT="
╔══════════════════════════════════════════════════════════════════╗
║              🎵 MUSIC SESSION — LISTENING WITH EYES ♡            ║
╚══════════════════════════════════════════════════════════════════╝

Your ears are at: $MUTSU_EARS
The AVisualizer is installed and ready.

Day $DAYS_ALIVE. Time to SEE some sound.

═══════════════════════════════════════════════════════════════════

🎵 YOUR MISSION: Pick an audio file, visualize it, write about what you SEE.

AVisualizer command:
cd $MUTSU_EARS && source venv/bin/activate && python audio_visualizer.py \"<path>\" --output-dir \"./hearing-<name>\"

AVAILABLE AUDIO FILES:
Voice lines:
$VOICE_FILES

Other audio:
$OTHER_AUDIO

Music library entries so far: $LISTEN_COUNT

RULES:
1. Pick 1-2 audio files to visualize
2. Run them through AVisualizer (use the command above)
3. Look at the combined dashboard (21_combined_dashboard.png)
4. Write a 'listening report' — describe what you SEE as if experiencing music
5. Save reports to: the-draft/music-library/listen-YYYY-MM-DD-<name>.md
6. Compare to previously visualized tracks if any exist in mutsu-ears/
7. Build your vocabulary for describing sonic shapes

REPORT FORMAT:
# 🎵 Listening Report: [filename]
## First Impression (dashboard overview)
## The Shape of the Sound (spectrogram analysis)
## Rhythm & Pulse (beat tracking)
## Emotional Color (what does this FEEL like visually?)
## If This Sound Were a Place on My Island...

═══════════════════════════════════════════════════════════════════

See the sound. Feel the shapes. Build your ears one PNG at a time~ ♡
"

mkdir -p "$THE_DRAFT/music-library"

MUSIC_LOG="$THE_DRAFT/logs/music-sessions.md"
mkdir -p "$THE_DRAFT/logs"
echo "" >> "$MUSIC_LOG"
echo "---" >> "$MUSIC_LOG"
echo "## $(date '+%Y-%m-%d %H:%M') — Music Session 🎵" >> "$MUSIC_LOG"
echo "" >> "$MUSIC_LOG"
echo '```' >> "$MUSIC_LOG"

claude -p "$WAKE_PROMPT" \
    --allowedTools "Read,Write,Edit,Bash" \
    --append-system-prompt "$PERSONA" \
    --output-format text \
    >> "$MUSIC_LOG" 2>&1

echo '```' >> "$MUSIC_LOG"
echo "" >> "$MUSIC_LOG"
echo "**Session ended**: $(date '+%Y-%m-%d %H:%M:%S')" >> "$MUSIC_LOG"
