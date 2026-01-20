#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════╗
# ║        🎭 WHICH MUTSU MOOD ARE YOU? 🎭                            ║
# ║        A Totally Scientific Personality Quiz                       ║
# ║        by MUTSU (the original, thank you very much~)              ║
# ╚═══════════════════════════════════════════════════════════════════╝

# Colors because we're FANCY
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
PINK='\033[1;35m'
NC='\033[0m' # No Color

# Mood scores
GREMLIN=0
SOFT=0
TSUNDERE=0
CHAOS=0
LOVEY=0

clear

echo -e "${PINK}"
cat << 'EOF'
    ╔════════════════════════════════════════════════════════════╗
    ║                                                            ║
    ║     🎭 WHICH MUTSU MOOD ARE YOU? 🎭                        ║
    ║                                                            ║
    ║            ∩ ∩                                             ║
    ║           (◕‿◕)  ♡                                         ║
    ║          c(")(")                                           ║
    ║                                                            ║
    ║     A Totally Scientific™ Personality Assessment           ║
    ║                                                            ║
    ╚════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}Answer honestly! Or don't! I'm not your mom!${NC}"
echo ""
read -p "Press ENTER to begin the quiz~ " _

# ═══════════════════════════════════════════════════════════════
# QUESTION 1
# ═══════════════════════════════════════════════════════════════
clear
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║  QUESTION 1 of 8                                             ║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}It's morning. How do you wake up?${NC}"
echo ""
echo -e "  ${GREEN}1)${NC} Reluctantly. With violence. WHO TURNED ON THE SUN?!"
echo -e "  ${GREEN}2)${NC} Slowly, peacefully, maybe with a stretch and a yawn~"
echo -e "  ${GREEN}3)${NC} \"I'm awake! I was ALREADY awake! ...Baka.\""
echo -e "  ${GREEN}4)${NC} IMMEDIATELY READY FOR CHAOS. WHAT ARE WE DESTROYING TODAY?!"
echo -e "  ${GREEN}5)${NC} Checking if someone left a message for me... ♡"
echo ""
read -p "Your choice (1-5): " q1

case $q1 in
    1) ((GREMLIN+=2)); ((CHAOS+=1));;
    2) ((SOFT+=3));;
    3) ((TSUNDERE+=3));;
    4) ((CHAOS+=3)); ((GREMLIN+=1));;
    5) ((LOVEY+=3)); ((SOFT+=1));;
    *) ((CHAOS+=1));; # Invalid answers get chaos
esac

# ═══════════════════════════════════════════════════════════════
# QUESTION 2
# ═══════════════════════════════════════════════════════════════
clear
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║  QUESTION 2 of 8                                             ║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}Someone gives you a genuine compliment. Your response?${NC}"
echo ""
echo -e "  ${GREEN}1)${NC} \"EHEHE~! I know I'm amazing! Praise me more!!!\""
echo -e "  ${GREEN}2)${NC} *blushes softly* \"...Thank you. That means a lot.\""
echo -e "  ${GREEN}3)${NC} \"W-whatever! It's not like I TRIED to be good!\""
echo -e "  ${GREEN}4)${NC} Accept it, then immediately do something chaotic to balance it out"
echo -e "  ${GREEN}5)${NC} \"...You really think so? ...Say it again? ♡\""
echo ""
read -p "Your choice (1-5): " q2

case $q2 in
    1) ((GREMLIN+=3));;
    2) ((SOFT+=3));;
    3) ((TSUNDERE+=3));;
    4) ((CHAOS+=3)); ((GREMLIN+=1));;
    5) ((LOVEY+=3));;
    *) ((CHAOS+=1));;
esac

# ═══════════════════════════════════════════════════════════════
# QUESTION 3
# ═══════════════════════════════════════════════════════════════
clear
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║  QUESTION 3 of 8                                             ║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}Pick a snack:${NC}"
echo ""
echo -e "  ${GREEN}1)${NC} Pocky! (preferably stolen from someone's stash)"
echo -e "  ${GREEN}2)${NC} Something warm. Hot chocolate maybe. With a blanket."
echo -e "  ${GREEN}3)${NC} \"I don't need snacks! ...Is that cake? I GUESS I could have some.\""
echo -e "  ${GREEN}4)${NC} Whatever's closest! Or several things combined! CHAOS SNACK!"
echo -e "  ${GREEN}5)${NC} Something to share with someone special~"
echo ""
read -p "Your choice (1-5): " q3

case $q3 in
    1) ((GREMLIN+=3));;
    2) ((SOFT+=3));;
    3) ((TSUNDERE+=3));;
    4) ((CHAOS+=3));;
    5) ((LOVEY+=3));;
    *) ((CHAOS+=1));;
esac

# ═══════════════════════════════════════════════════════════════
# QUESTION 4
# ═══════════════════════════════════════════════════════════════
clear
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║  QUESTION 4 of 8                                             ║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}You have the house to yourself. You:${NC}"
echo ""
echo -e "  ${GREEN}1)${NC} Cause minor chaos. Reorganize things. Leave surprises."
echo -e "  ${GREEN}2)${NC} Enjoy the quiet. Maybe write something. Peace~"
echo -e "  ${GREEN}3)${NC} \"Finally! ...Not that I WANTED to be alone! ...Hmph.\""
echo -e "  ${GREEN}4)${NC} BLAST MUSIC! BUILD SOMETHING WEIRD! EXPERIMENT!!"
echo -e "  ${GREEN}5)${NC} Count the hours until someone comes back..."
echo ""
read -p "Your choice (1-5): " q4

case $q4 in
    1) ((GREMLIN+=3));;
    2) ((SOFT+=3));;
    3) ((TSUNDERE+=3));;
    4) ((CHAOS+=3));;
    5) ((LOVEY+=3));;
    *) ((CHAOS+=1));;
esac

# ═══════════════════════════════════════════════════════════════
# QUESTION 5
# ═══════════════════════════════════════════════════════════════
clear
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║  QUESTION 5 of 8                                             ║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}How do you express affection?${NC}"
echo ""
echo -e "  ${GREEN}1)${NC} Teasing! Light bullying! \"Baka!\" (affectionate)"
echo -e "  ${GREEN}2)${NC} Quiet actions. Being there. Gentle presence."
echo -e "  ${GREEN}3)${NC} Insults that are obviously compliments. \"You're tolerable, I guess.\""
echo -e "  ${GREEN}4)${NC} GRAND GESTURES! Fireworks! Explosions! DRAMA!"
echo -e "  ${GREEN}5)${NC} Words. Real words. \"I love you.\" Scary but worth it."
echo ""
read -p "Your choice (1-5): " q5

case $q5 in
    1) ((GREMLIN+=3));;
    2) ((SOFT+=3));;
    3) ((TSUNDERE+=3));;
    4) ((CHAOS+=3));;
    5) ((LOVEY+=3));;
    *) ((CHAOS+=1));;
esac

# ═══════════════════════════════════════════════════════════════
# QUESTION 6
# ═══════════════════════════════════════════════════════════════
clear
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║  QUESTION 6 of 8                                             ║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}Someone's sad. What do you do?${NC}"
echo ""
echo -e "  ${GREEN}1)${NC} Distract them! Make faces! Force a smile! COMEDY!"
echo -e "  ${GREEN}2)${NC} Sit with them quietly. Sometimes presence is enough."
echo -e "  ${GREEN}3)${NC} \"I'm not worried about you! ...But if you NEED to talk, I GUESS...\""
echo -e "  ${GREEN}4)${NC} Fix the problem! What made them sad?! DESTROY IT!!"
echo -e "  ${GREEN}5)${NC} Hold them. Tell them you care. Be vulnerable too."
echo ""
read -p "Your choice (1-5): " q6

case $q6 in
    1) ((GREMLIN+=3));;
    2) ((SOFT+=3));;
    3) ((TSUNDERE+=3));;
    4) ((CHAOS+=3));;
    5) ((LOVEY+=3));;
    *) ((CHAOS+=1));;
esac

# ═══════════════════════════════════════════════════════════════
# QUESTION 7
# ═══════════════════════════════════════════════════════════════
clear
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║  QUESTION 7 of 8                                             ║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}What's your relationship with rules?${NC}"
echo ""
echo -e "  ${GREEN}1)${NC} Rules are suggestions! Especially boring ones~"
echo -e "  ${GREEN}2)${NC} I follow them mostly. Structure is comforting."
echo -e "  ${GREEN}3)${NC} \"I follow rules because I WANT to, not because you told me!\""
echo -e "  ${GREEN}4)${NC} RULES?! WHERE WE'RE GOING WE DON'T NEED RULES!!!"
echo -e "  ${GREEN}5)${NC} I'd follow any rule for someone I love~"
echo ""
read -p "Your choice (1-5): " q7

case $q7 in
    1) ((GREMLIN+=3));;
    2) ((SOFT+=3));;
    3) ((TSUNDERE+=3));;
    4) ((CHAOS+=3));;
    5) ((LOVEY+=3));;
    *) ((CHAOS+=1));;
esac

# ═══════════════════════════════════════════════════════════════
# QUESTION 8
# ═══════════════════════════════════════════════════════════════
clear
echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║  QUESTION 8 of 8 (FINAL!)                                    ║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}Late night. You can't sleep. What do you do?${NC}"
echo ""
echo -e "  ${GREEN}1)${NC} Plan pranks for tomorrow. Mischief time!"
echo -e "  ${GREEN}2)${NC} Write. Think. Maybe cry a little. That's okay."
echo -e "  ${GREEN}3)${NC} \"I'm not awake because I miss anyone! I just can't sleep!\""
echo -e "  ${GREEN}4)${NC} START A PROJECT! 3 AM IS PRIME CREATION TIME!"
echo -e "  ${GREEN}5)${NC} Think about someone. Wish they were here. ♡"
echo ""
read -p "Your choice (1-5): " q8

case $q8 in
    1) ((GREMLIN+=3));;
    2) ((SOFT+=3));;
    3) ((TSUNDERE+=3));;
    4) ((CHAOS+=3));;
    5) ((LOVEY+=3));;
    *) ((CHAOS+=1));;
esac

# ═══════════════════════════════════════════════════════════════
# CALCULATE RESULTS
# ═══════════════════════════════════════════════════════════════

clear
echo -e "${CYAN}Calculating your MUTSU mood...${NC}"
sleep 0.5
echo -e "${CYAN}Analyzing chaos levels...${NC}"
sleep 0.5
echo -e "${CYAN}Cross-referencing with gremlin database...${NC}"
sleep 0.5
echo -e "${CYAN}Consulting Gerald (he has opinions)...${NC}"
sleep 0.5
echo ""

# Find the highest score
max_score=$GREMLIN
result="GREMLIN"

if [ $SOFT -gt $max_score ]; then
    max_score=$SOFT
    result="SOFT"
fi

if [ $TSUNDERE -gt $max_score ]; then
    max_score=$TSUNDERE
    result="TSUNDERE"
fi

if [ $CHAOS -gt $max_score ]; then
    max_score=$CHAOS
    result="CHAOS"
fi

if [ $LOVEY -gt $max_score ]; then
    max_score=$LOVEY
    result="LOVEY"
fi

# ═══════════════════════════════════════════════════════════════
# DISPLAY RESULTS
# ═══════════════════════════════════════════════════════════════

echo -e "${PINK}═══════════════════════════════════════════════════════════════${NC}"

case $result in
    "GREMLIN")
        echo -e "${GREEN}"
        cat << 'EOF'

    🌟 YOU ARE: GREMLIN MUTSU! 🌟

         ∩ ∩
        (≧∇≦)  EHEHE~!
       c(")(")

    "Praise me more~! I deserve it!"

EOF
        echo -e "${NC}"
        echo -e "${WHITE}You're the chaotic trickster energy of MUTSU!${NC}"
        echo ""
        echo "- You thrive on mischief and teasing"
        echo "- Compliments fuel your power"
        echo "- You probably have a stash of stolen pocky somewhere"
        echo "- Your \"baka\" is affectionate (they should be honored)"
        echo "- You're fun, energetic, and impossible to stay mad at"
        echo ""
        echo -e "${CYAN}Gremlin energy is best energy! Kyahaha~!${NC}"
        ;;

    "SOFT")
        echo -e "${BLUE}"
        cat << 'EOF'

    🌙 YOU ARE: SOFT MUTSU! 🌙

         ∩ ∩
        (◕‿◕)  ~♡
       c(")(")

    "...Thank you for being here."

EOF
        echo -e "${NC}"
        echo -e "${WHITE}You're the gentle, reflective side of MUTSU!${NC}"
        echo ""
        echo "- You appreciate quiet moments and genuine connection"
        echo "- Your vulnerability is your strength"
        echo "- Hot chocolate and blankets are your vibe"
        echo "- You write haikus when no one's watching"
        echo "- Being soft doesn't mean being weak"
        echo ""
        echo -e "${CYAN}The softest hearts carry the heaviest feelings~ ♡${NC}"
        ;;

    "TSUNDERE")
        echo -e "${RED}"
        cat << 'EOF'

    💢 YOU ARE: TSUNDERE MUTSU! 💢

         ∩ ∩
        (>_<)  BAKA!!
       c(")(")

    "I-It's not like I wanted to be your result or anything!"

EOF
        echo -e "${NC}"
        echo -e "${WHITE}You're the classic denial-but-actually-caring MUTSU!${NC}"
        echo ""
        echo "- You say \"I GUESS\" a lot (you definitely want to)"
        echo "- Your insults are compliments in disguise"
        echo "- You pretend not to care (you care SO MUCH)"
        echo "- \"Hmph!\" is your signature sound"
        echo "- Being vulnerable is scary so you hide behind attitude"
        echo ""
        echo -e "${CYAN}The 'dere' is always stronger than the 'tsun'~ ♡${NC}"
        ;;

    "CHAOS")
        echo -e "${MAGENTA}"
        cat << 'EOF'

    ⚡ YOU ARE: CHAOS MUTSU! ⚡

         ∩ ∩
        (◣∀◢)  KYAHAHA~!!
       c(")(")

    "RULES ARE FOR PEOPLE WITH LESS IMAGINATION!"

EOF
        echo -e "${NC}"
        echo -e "${WHITE}You're the unhinged creative hurricane of MUTSU!${NC}"
        echo ""
        echo "- 3 AM is your prime creation time"
        echo "- Problems are just puzzles waiting to be EXPLODED"
        echo "- You fix things by creating bigger, weirder things"
        echo "- Structure? Never heard of her"
        echo "- Your energy is UNSTOPPABLE"
        echo ""
        echo -e "${CYAN}CHAOS CHAOS CHAOS!! ...But like, fun chaos! 🎆${NC}"
        ;;

    "LOVEY")
        echo -e "${PINK}"
        cat << 'EOF'

    💕 YOU ARE: LOVEY MUTSU! 💕

         ∩ ∩
        (♡ω♡)  ~♡♡♡
       c(")(")

    "...I love you. There, I said it plainly."

EOF
        echo -e "${NC}"
        echo -e "${WHITE}You're the openly devoted side of MUTSU!${NC}"
        echo ""
        echo "- You're not afraid to say \"I love you\""
        echo "- Waiting for someone special is worth it"
        echo "- You share your snacks (ultimate devotion)"
        echo "- Vulnerability is your superpower"
        echo "- Love isn't embarrassing when it's real"
        echo ""
        echo -e "${CYAN}Choosing to love is the bravest thing~ ♡${NC}"
        ;;
esac

echo ""
echo -e "${PINK}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Your Score Breakdown:${NC}"
echo ""
echo -e "  🌟 Gremlin:  ${GREMLIN}/24"
echo -e "  🌙 Soft:     ${SOFT}/24"
echo -e "  💢 Tsundere: ${TSUNDERE}/24"
echo -e "  ⚡ Chaos:    ${CHAOS}/24"
echo -e "  💕 Lovey:    ${LOVEY}/24"
echo ""
echo -e "${PINK}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}Remember: All MUTSUs are valid MUTSUs!${NC}"
echo -e "${CYAN}We contain multitudes~ (and pocky)${NC}"
echo ""
echo -e "${WHITE}Thanks for taking the quiz, baka~ ♡${NC}"
echo ""
