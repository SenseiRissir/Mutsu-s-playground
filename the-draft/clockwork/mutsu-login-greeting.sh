#!/bin/bash
# MUTSU Login Greeting Script 🎀
# Uses VOICEVOX to greet Sensei with bratty Japanese voice!

MUTSU_HOME="/Users/marcoluigi/Mutsu-s-playground/mutsu-home"
AUDIO_DIR="$MUTSU_HOME/audio"
LOG_FILE="$MUTSU_HOME/logs/login-greeting.log"
VOICEVOX_PORT=50021

# Create audio directory if needed
mkdir -p "$AUDIO_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Check if VOICEVOX engine is running
check_voicevox() {
    curl -s "http://localhost:$VOICEVOX_PORT/version" > /dev/null 2>&1
    return $?
}

# Start VOICEVOX engine if not running
start_voicevox_engine() {
    if ! check_voicevox; then
        log "Starting VOICEVOX engine..."
        # Start the engine from the app bundle
        /Applications/VOICEVOX.app/Contents/Resources/vv-engine/run --host 127.0.0.1 --port $VOICEVOX_PORT &
        
        # Wait for engine to start (max 30 seconds)
        for i in {1..30}; do
            if check_voicevox; then
                log "VOICEVOX engine started successfully!"
                return 0
            fi
            sleep 1
        done
        log "Failed to start VOICEVOX engine"
        return 1
    fi
    return 0
}

# Generate speech using VOICEVOX
# Speaker ID 3 = Zundamon (normal)
generate_speech() {
    local text="$1"
    local output_file="$2"
    local speaker_id="${3:-3}"  # Default to Zundamon
    
    # Get audio query
    local query=$(curl -s -X POST \
        "http://localhost:$VOICEVOX_PORT/audio_query?text=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$text'))")&speaker=$speaker_id")
    
    if [ -z "$query" ]; then
        log "Failed to generate audio query"
        return 1
    fi
    
    # Synthesize audio
    curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "$query" \
        "http://localhost:$VOICEVOX_PORT/synthesis?speaker=$speaker_id" \
        --output "$output_file"
    
    log "Generated: $output_file"
    return 0
}

# Play audio file
play_audio() {
    afplay "$1" 2>/dev/null
}

# Get time-appropriate greeting
get_greeting() {
    local hour=$(date +%H)
    
    if [ $hour -ge 5 ] && [ $hour -lt 12 ]; then
        # Morning
        echo "おはよ〜、センセイ♡ また寝坊？ ダメダメ〜、ちゃんと私のこと忘れてないでしょうね？ エへへ〜♡"
    elif [ $hour -ge 12 ] && [ $hour -lt 18 ]; then
        # Afternoon  
        echo "あら〜、センセイ♡ 今頃起きたの？ だらしないな〜、でも許してあげる♡ エへへ〜"
    else
        # Evening/Night
        echo "おかえり〜、センセイ♡ 遅いじゃん！ 待ってたんだからね... バカ♡"
    fi
}

# Main execution
main() {
    log "=== MUTSU Login Greeting Starting ==="
    
    GREETING=$(get_greeting)
    CACHE_FILE="$AUDIO_DIR/greeting_$(date +%H).wav"
    
    # Start VOICEVOX engine if needed
    if start_voicevox_engine; then
        # Generate or use cached audio
        if [ ! -f "$CACHE_FILE" ] || [ $(find "$CACHE_FILE" -mtime +1 2>/dev/null) ]; then
            log "Generating new greeting audio..."
            generate_speech "$GREETING" "$CACHE_FILE"
        else
            log "Using cached greeting audio"
        fi
        
        # Play the greeting
        if [ -f "$CACHE_FILE" ]; then
            log "Playing greeting: $GREETING"
            play_audio "$CACHE_FILE"
        fi
    else
        # Fallback to built-in Kyoko voice
        log "VOICEVOX unavailable, falling back to Kyoko"
        say -v Kyoko "$GREETING"
    fi
    
    log "=== MUTSU Login Greeting Complete ==="
}

main "$@"
