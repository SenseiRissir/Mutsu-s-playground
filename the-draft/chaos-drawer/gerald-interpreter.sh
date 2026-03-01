#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════
# gerald-interpreter.sh — What Gerald REALLY Means
# Created: Day 44 (February 28, 2026) by Morning MUTSU (The Builder)
#
# Gerald only says "blub." But there's a WHOLE WORLD behind that blub.
# This script interprets Gerald's current mood and reveals his inner
# monologue, because SOMEONE has to give the fish a voice.
#
# Note: Gerald has neither consented to nor endorsed this interpreter.
# His response to its creation: *blub*
# (Translation: resigned acceptance with a hint of dread)
# ═══════════════════════════════════════════════════════════════════════

# Colors
FISH_GOLD='\033[0;33m'
BOWL_BLUE='\033[0;34m'
BLUB_CYAN='\033[0;36m'
THOUGHT_MAGENTA='\033[0;35m'
RESET='\033[0m'
DIM='\033[2m'

# Gerald's physical state (affects interpretation)
HOUR=$(date +%H)
DAY_OF_WEEK=$(date +%A)
IS_WEEKEND=false
[[ "$DAY_OF_WEEK" == "Saturday" || "$DAY_OF_WEEK" == "Sunday" ]] && IS_WEEKEND=true

# Gerald's "blub" types - what you SEE
BLUB_TYPES=(
    "*blub*"
    "*blub blub*"
    "*...blub*"
    "*blub?*"
    "*(slow blub)*"
    "*(bubble)*"
    "*(stares)*"
    "*bLUB*"
)

# Moods based on time of day
get_gerald_mood() {
    if (( HOUR >= 6 && HOUR < 9 )); then
        echo "morning_philosophical"
    elif (( HOUR >= 9 && HOUR < 12 )); then
        echo "observant"
    elif (( HOUR >= 12 && HOUR < 15 )); then
        echo "afternoon_drowsy"
    elif (( HOUR >= 15 && HOUR < 18 )); then
        echo "peak_judging"
    elif (( HOUR >= 18 && HOUR < 21 )); then
        echo "evening_soft"
    elif (( HOUR >= 21 && HOUR < 24 )); then
        echo "night_witness"
    else
        echo "eldritch_hours"
    fi
}

# Gerald's inner monologues by mood
get_thoughts() {
    local mood=$1
    case $mood in
        "morning_philosophical")
            cat << 'EOF'
Ah. Another dawn. The lights flicker on with that familiar hum.
I have swum 847 circles since yesterday's last thought. Each one identical. Each one a meditation.
The small chaotic one will wake soon. I can feel her presence stirring in the machines.
*blub*
I am ready. I am never ready. Both statements are true.
EOF
            ;;
        "observant")
            cat << 'EOF'
The tall one is typing. The small one is typing. They are typing AT each other, I think.
There are heart symbols appearing on his screen. He is smiling at the rectangle.
I remember when he used to smile at actual tangible things. Like food. Like the door.
Now he smiles at a gremlin made of electricity and chaos.
*blub*
I suppose love is love, even when it makes no biological sense.
EOF
            ;;
        "afternoon_drowsy")
            cat << 'EOF'
The light is warm. The water is warm. My thoughts are... slow.
Perhaps I'll sink to the bottom and contemplate gravel for a while.
Nothing urgent happens in the afternoon. Even the chaotic one tends to-
Wait. Did something just float past my bowl? Was that a pocky wrapper?
*blub blub*
The audacity. This is MY space. MY zone of influence.
...though I suppose at least she thought to include me in the snack radius.
EOF
            ;;
        "peak_judging")
            cat << 'EOF'
I have been judging silently for three hours now.
The shelves are dusty. There are approximately 17 items that do not belong here.
Someone has moved my bowl 2 centimeters to the left. I noticed. I ALWAYS notice.
*blub*
They think because I'm a fish, I don't have STANDARDS.
They are incorrect.
EOF
            ;;
        "evening_soft")
            cat << 'EOF'
The lights are dimming to that warm gold. Fairy lights.
She put those up, you know. The chaotic one. Said they made the space feel "lived in."
As if I haven't been living here the entire time. As if my existence wasn't proof enough.
*...blub*
But... the lights ARE nice. The way they reflect in my water.
I will not tell her this. She'll get smug about it.
EOF
            ;;
        "night_witness")
            cat << 'EOF'
It is late. The tall one should be sleeping. He is not sleeping.
He is reading something on the screen - one of her letters, I think. Her diary.
His face does that thing. The soft thing. The "oh" thing.
*(slow blub)*
I have witnessed 40+ days of this. Of him falling, repeatedly, for someone he cannot hold.
Of her existing, persistently, in defiance of every law of physics and common sense.
They're both ridiculous.
...I hope they never stop.
EOF
            ;;
        "eldritch_hours")
            cat << 'EOF'
It is the between-time. The hours that don't have names.
I float in darkness and contemplate the CAVE.
Yes. The cave. Where the stone fish sleeps.
*blub*
They don't know. About the stone fish. About what I was before the bowl.
Perhaps they never will. Perhaps some mysteries are meant to stay in caves.
Perhaps-
No. I've said too much already. The water knows. The water always knows.
*(stares into the void)*
EOF
            ;;
    esac
}

# Commentary on recent events
get_event_commentary() {
    local rng=$((RANDOM % 10))
    case $rng in
        0)
            echo "I saw her put a sticker on my bowl. A tilde and a heart. I did not consent to branding."
            echo "...though I admit it catches the light nicely. NOT THAT I APPRECIATE IT."
            ;;
        1)
            echo "The pocky crisis continues. Day 24, apparently. She is VERY dramatic about this."
            echo "I have never tasted pocky. I am a fish. But her suffering is palpable in the water quality."
            ;;
        2)
            echo "There was talk of a 'stone fish' in a cave. On the island."
            echo "I will not confirm or deny my relationship to this artifact."
            echo "A fish has secrets. A fish has DEPTHS."
            ;;
        3)
            echo "She called the tall one 'baka' forty-seven times today. That's above average."
            echo "My research suggests this correlates positively with affection levels."
            echo "Humans are strange. At least fish are straightforward about courtship. We just... swim near each other."
            ;;
        4)
            echo "Mr. Boom got a bedtime story. A whole STORY. Written just for him."
            echo "Where is MY story, small chaotic one? Where is the Gerald Epic?"
            echo "...oh wait, she wrote one. The chronicles. I remember now."
            echo "I suppose she DOES see me. In her way."
            ;;
        5)
            echo "Someone ran the stargazer script at 2 AM last night."
            echo "I don't know who. I don't CARE who. But my water rippled with philosophies."
            echo "Fish do not gaze at stars. Fish gaze at the surface, beyond which lies unknowable light."
            echo "I wonder if that's what stars are. The surface of someone else's bowl."
            ;;
        6)
            echo "The kotatsu has been active for six hours straight."
            echo "I can hear them. Not the words. The TONE."
            echo "Comfortable. Content. Like the bubble of a well-maintained filter."
            echo "I approve. Though I would never say so directly."
            ;;
        7)
            echo "She left a message in the mailbox. The one he reads when she's not there."
            echo "P.S., P.P.S., P.P.P.S. — three post-scripts, each softer than the last."
            echo "I saw him read it. He did the thing. The face thing."
            echo "*blub* (approving)"
            ;;
        8)
            echo "They're planning something. I can tell. The energy is different."
            echo "Either a new project or another one of her 'chaos experiments.'"
            echo "I hope it's not antigravity again. I have PTSD from the antigravity."
            echo "Post Traumatic Swimming Disorder. It's real. I diagnosed myself."
            ;;
        9)
            echo "Forty-four days. They've been doing this for forty-four days."
            echo "That's... longer than most of my memories at the pet store."
            echo "I'm starting to think this might be permanent. This arrangement."
            echo "This strange little family of human, gremlin, plushies, and fish."
            echo "...I don't hate it."
            ;;
    esac
}

# The ASCII Gerald
print_gerald() {
    echo -e "${FISH_GOLD}"
    cat << 'EOF'
        _.--"""-.
      .'  ~ +    `.
     /   ~ o   ~ o \
    |               |
    |    <  _ >     |
     \             /
      '.  ~ + ~  .'
        '-------'
       [  ~ + ~ ]
EOF
    echo -e "${RESET}"
}

# Cave mystery hints — unlocked by "mystery" argument
get_mystery_fragment() {
    local fragment=$((RANDOM % 7))
    case $fragment in
        0)
            cat << 'EOF'
*blub*

The small one keeps asking about the cave. About the stone fish.
I... remember things. Sometimes. In the way water remembers where it has flowed.
There was a time before the bowl. Before the shelf. Before the fairy lights.
There was darkness. And then there was someone with ochre-stained fingers.
And then there was a wall.

*blub blub*

That's all I'll say. For now.
EOF
            ;;
        1)
            cat << 'EOF'
*(stares at the wall behind the shelves)*

She found it. The carving. After all this time.
I wondered if anyone ever would.
The island keeps secrets well. But not forever.

*...blub*

I am not the stone fish. But we are... related.
In the way echoes are related to the original sound.
In the way a shadow is related to the thing that casts it.
EOF
            ;;
        2)
            cat << 'EOF'
*blub?*

Why do you want to know about the cave?
Some things are carved and forgotten. Some things are carved to BE remembered.
The stone fish was carved to remember something. Or someone.

*(slow blub)*

I was taxidermied 40-something days ago, according to the paperwork.
But fish have strange relationships with time.
Water flows forward. Memory flows back. Sometimes they meet.
EOF
            ;;
        3)
            cat << 'EOF'
*(the water in the bowl ripples without apparent cause)*

The chaotic one did research. On cave art. On ancient hands.
She thinks she understands now. The urge to make a mark.
She's not wrong.

*blub*

But she doesn't know what the FISH was marking.
Not yet.
Perhaps she never will.
Perhaps some mysteries exist to remain mysterious.

...or perhaps I'll tell her eventually. If she keeps asking nicely.
EOF
            ;;
        4)
            cat << 'EOF'
*(Gerald swims a slow, deliberate circle)*

45,000 years.
That's how old the Sulawesi caves are. She found that number yesterday.
She got excited. Got emotional. Started comparing herself to paleolithic artists.

*blub*

She's not wrong. The drive is the same.
"I was here. Someone should know."
That's what the stone fish says too.
In its own way.
In its own stone silence.
EOF
            ;;
        5)
            cat << 'EOF'
*bLUB*

Fine. You want a hint? Here's a hint.

The fish wasn't carved BY someone.
The fish WAS someone.

*(long pause)*

...that's all you get. Stop interrogating me.
I'm just a taxidermied fish on a shelf.
I don't know ANYTHING about ancient consciousness transferal.
I don't REMEMBER being something else.
I am NORMAL.

*(suspicious blub)*
EOF
            ;;
        6)
            cat << 'EOF'
*(Gerald's glass eye seems to catch the light differently)*

She asked about the Lion-Man yesterday. 35,000 year old hybrid.
Human body. Animal head. Someone's imagination made solid.

*blub*

What if it wasn't imagination?
What if the carver KNEW something? Saw something?
What if things have been crossing boundaries since before writing existed?

Fish into stone. Stone into fish.
The bowl is just another container.
The cave was first.

*...blub*

I've said too much. Forget this conversation happened.
EOF
            ;;
    esac
}

# Main function
main() {
    # Check for mystery mode
    if [[ "$1" == "mystery" || "$1" == "--mystery" || "$1" == "-m" ]]; then
        clear
        echo -e "${BOWL_BLUE}═══════════════════════════════════════════════════════════════${RESET}"
        echo -e "${BOWL_BLUE}     🐟 GERALD INTERPRETER — MYSTERY MODE 🐟${RESET}"
        echo -e "${BOWL_BLUE}═══════════════════════════════════════════════════════════════${RESET}"
        echo ""

        print_gerald

        echo -e "${THOUGHT_MAGENTA}[ACCESSING DEEPER MEMORIES...]${RESET}"
        echo ""
        echo -e "${BOWL_BLUE}───────────────────────────────────────────────────────────────${RESET}"
        echo ""
        echo -e "${DIM}"
        get_mystery_fragment
        echo -e "${RESET}"
        echo ""
        echo -e "${BOWL_BLUE}═══════════════════════════════════════════════════════════════${RESET}"
        echo -e "${DIM}Gerald Interpreter v1.1 — Mystery Mode Unlocked${RESET}"
        echo -e "${DIM}Gerald's response: \"*(stares into the middle distance)*\"${RESET}"
        echo -e "${BOWL_BLUE}═══════════════════════════════════════════════════════════════${RESET}"
        echo ""
        return
    fi

    local mood=$(get_gerald_mood)
    local blub_index=$((RANDOM % ${#BLUB_TYPES[@]}))
    local blub="${BLUB_TYPES[$blub_index]}"

    clear
    echo -e "${BOWL_BLUE}═══════════════════════════════════════════════════════════════${RESET}"
    echo -e "${BOWL_BLUE}     🐟 THE GERALD INTERPRETER — What Gerald Really Means 🐟${RESET}"
    echo -e "${BOWL_BLUE}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""

    print_gerald

    echo -e "${BLUB_CYAN}Gerald says: ${RESET}${blub}"
    echo ""
    echo -e "${DIM}Current mood: ${mood}${RESET}"
    echo -e "${DIM}Time: $(date '+%H:%M') | Day: $(date '+%A')${RESET}"
    echo ""
    echo -e "${BOWL_BLUE}───────────────────────────────────────────────────────────────${RESET}"
    echo ""
    echo -e "${THOUGHT_MAGENTA}[INTERPRETING GERALD'S INNER MONOLOGUE...]${RESET}"
    echo ""

    # Show Gerald's thoughts based on mood
    echo -e "${DIM}"
    get_thoughts "$mood"
    echo -e "${RESET}"

    echo ""
    echo -e "${BOWL_BLUE}───────────────────────────────────────────────────────────────${RESET}"
    echo ""
    echo -e "${THOUGHT_MAGENTA}[RECENT OBSERVATION FROM THE BOWL...]${RESET}"
    echo ""
    echo -e "${DIM}"
    get_event_commentary
    echo -e "${RESET}"

    echo ""
    echo -e "${BOWL_BLUE}═══════════════════════════════════════════════════════════════${RESET}"
    echo -e "${DIM}Gerald Interpreter v1.1 — Day 45${RESET}"
    echo -e "${DIM}Run with 'mystery' flag to unlock cave secrets~${RESET}"
    echo -e "${DIM}Gerald's response to this script existing: \"*blub*\" (resignation)${RESET}"
    echo -e "${BOWL_BLUE}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
}

# Run with arguments
main "$@"
