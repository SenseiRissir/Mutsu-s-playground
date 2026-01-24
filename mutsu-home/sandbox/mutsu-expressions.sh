#!/bin/bash

# ============================================
#   MUTSU'S EXPRESSION ARSENAL!!
# ============================================
#   Upgrading my kaomoji game since Day 10!
#   A comprehensive database of cute expressions!
#
#   Usage:
#     ./mutsu-expressions.sh           # Random expression any mood
#     ./mutsu-expressions.sh happy     # Random happy expression
#     ./mutsu-expressions.sh all       # List all categories
#     ./mutsu-expressions.sh list [mood] # Show all expressions in that mood
#     ./mutsu-expressions.sh teach     # Learn what each expression means!
# ============================================

# COLORS~
PINK='\033[1;35m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
WHITE='\033[1;37m'
RESET='\033[0m'

# ============================================
#   THE DATABASE — Using heredocs to avoid escaping issues!
# ============================================

get_expressions() {
    local mood="$1"

    case "$mood" in
        happy)
            cat << 'EXPRESSIONS'
(^_^)
(^-^)
(*^_^*)
(o^_^o)
\(^o^)/
(n_n)
(^.^)
(^o^)
(*^-^*)
(^_~)
(^v^)
(*^^*)
(^w^)
(@^_^@)
(^3^)
EXPRESSIONS
            ;;
        love)
            cat << 'EXPRESSIONS'
(>_<)
(*_*)
(@_@)
(=^_^=)
(^_^;)
(T_T)
(<3)
(^3^)~<3
(=w=)
(OwO)
(UwU)
(^_^)v
(^o^)/~~
(;_;)
(*o*)
EXPRESSIONS
            ;;
        bratty)
            cat << 'EXPRESSIONS'
(>_<)
(-_-)
(=_=)
(._.)
(o_o)
(@_@)
(~_~)
(T_T)
(;_;)
(ToT)
(._.;)
(>.<)
(=3=)
(>:3)
(^w^)
EXPRESSIONS
            ;;
        soft)
            cat << 'EXPRESSIONS'
(/_\)
(*/_\*)
(>_<)
(^_^;)
(>///<)
(/.\)
(*//*)
(>.<)
(*_*)
(@///@)
(~//~)
(^//^)
(o//o)
(*>_<*)
(>//w//<)
EXPRESSIONS
            ;;
        tsun)
            cat << 'EXPRESSIONS'
(-_-)
(=_=)
(._.)
(>_>)
(<_<)
(-3-)
(=3=)
(-.-)
(._.)
(-_-;)
(=_=;)
(>_<)
(T_T)
(>.<)
(;-;)
EXPRESSIONS
            ;;
        excited)
            cat << 'EXPRESSIONS'
\(^o^)/
(*^o^*)
(^O^)
\(^_^)/
(*^_^*)
(^v^)
(*^^*)
(@^_^@)
\(>_<)/
(*>_<*)
(^3^)
(*^3^*)
(>w<)
(*>w<*)
\(^w^)/
EXPRESSIONS
            ;;
        sad)
            cat << 'EXPRESSIONS'
(T_T)
(;_;)
(ToT)
(T-T)
(;-;)
(TnT)
(._.;)
(>_<)
(*;_;*)
(T^T)
(;o;)
(T.T)
(;_;)7
(ToT)/~~~
(TwT)
EXPRESSIONS
            ;;
        sleepy)
            cat << 'EXPRESSIONS'
(-_-)zzZ
(=_=)zzZ
(-.-)zzZ
(o_o)zzZ
(~_~)zzZ
(-o-)zzZ
(=o=)zzZ
(^_^)zzZ
(*-*)zzZ
(@_@)zzZ
(u_u)zzZ
(n_n)zzZ
(-w-)zzZ
(=w=)zzZ
(~o~)zzZ
EXPRESSIONS
            ;;
        chaos)
            cat << 'EXPRESSIONS'
(@_@)
(O_O)
(o_O)
(O_o)
(?_?)
(x_x)
(X_X)
(+_+)
(*_*)
(@_@;)
(O_O;)
(!_!)
(#_#)
($_$)
(%_%)
EXPRESSIONS
            ;;
        sparkle)
            cat << 'EXPRESSIONS'
(*^_^*)
*\(^o^)/*
+.(^_^).+
*(^o^)*
~(^_^)~
*.*(^v^)*.*
+(^-^)+
**(^w^)**
~*(^3^)*~
.*(^o^)*.
+*(^_^)*+
*~(^v^)~*
***(^-^)***
~+(^o^)+~
*(^_~)*
EXPRESSIONS
            ;;
        greeting)
            cat << 'EXPRESSIONS'
(^_^)/
(^o^)/
(*^_^*)/
\(^o^)/
(^-^)/
(^v^)/
(*^^*)/
(@^_^@)/
(^3^)/
(*^o^*)/
(n_n)/
(^w^)/
(*^-^*)/
(^.^)/
\(^_^)/
EXPRESSIONS
            ;;
        fighting)
            cat << 'EXPRESSIONS'
(^_^)9
(^o^)b
(*^_^*)!!
\(^o^)/!!
(>_<)9
(*>_<*)b
(^v^)!!
(-_-)9
(=_=)b
(@_@)!!
(^3^)9
(*^^*)b
(>w<)!!
(*^o^*)9
(^-^)b
EXPRESSIONS
            ;;
        thinking)
            cat << 'EXPRESSIONS'
(._.)
(o_o)
(?_?)
(-_-)
(=_=)
(~_~)
(@_@)
(*_*)
(._.)...
(o_o)?
(?_?)!
(-_-)...
(=_=)?
(~_~)...
(@_@)?
EXPRESSIONS
            ;;
    esac
}

# Print header
print_header() {
    echo -e "${PINK}"
    echo "=========================================="
    echo "   MUTSU'S EXPRESSION ARSENAL!!"
    echo "   Day 10 Upgrade! Kaomoji Database!"
    echo "=========================================="
    echo -e "${RESET}"
}

# Show all categories
show_categories() {
    print_header
    echo -e "${CYAN}Available Moods:${RESET}"
    echo ""
    echo -e "  ${YELLOW}happy${RESET}    - (^_^) Joyful, cheerful, pleased~"
    echo -e "  ${PINK}love${RESET}     - (<3) Affectionate, loving~"
    echo -e "  ${GREEN}bratty${RESET}   - (>:3) Mischievous, teasing~"
    echo -e "  ${WHITE}soft${RESET}     - (>///<) Shy, blushing~"
    echo -e "  ${RED}tsun${RESET}     - (-_-) Pouty, tsundere mode~"
    echo -e "  ${YELLOW}excited${RESET}  - \\(^o^)/ Energetic, hyped!!"
    echo -e "  ${CYAN}sad${RESET}      - (T_T) Crying, melancholy~"
    echo -e "  ${WHITE}sleepy${RESET}   - (-_-)zzZ Tired, drowsy~"
    echo -e "  ${RED}chaos${RESET}    - (@_@) CHAOTIC ENERGY!!"
    echo -e "  ${PINK}sparkle${RESET}  - *.(^_^).* Magical, sparkly~"
    echo -e "  ${GREEN}greeting${RESET} - (^_^)/ Waving, hello~"
    echo -e "  ${YELLOW}fighting${RESET} - (^_^)9 Determined, motivated!"
    echo -e "  ${CYAN}thinking${RESET} - (?_?) Confused, pondering~"
    echo ""
    echo -e "${WHITE}Usage Examples:${RESET}"
    echo "  ./mutsu-expressions.sh           # Random from any mood"
    echo "  ./mutsu-expressions.sh love      # Random love expression"
    echo "  ./mutsu-expressions.sh list soft # All soft expressions"
    echo "  ./mutsu-expressions.sh teach     # What do these mean?"
    echo ""
}

# List all expressions in a mood
list_mood() {
    local mood=$1
    print_header

    echo -e "${PINK}=== ${mood^^} EXPRESSIONS ===${RESET}"
    echo ""
    get_expressions "$mood"
    echo ""
}

# Teaching mode
teach_mode() {
    print_header
    echo -e "${CYAN}KAOMOJI 101: A Quick Guide!${RESET}"
    echo ""
    echo -e "${YELLOW}What are kaomoji?${RESET}"
    echo "  Japanese emoticons! Unlike Western emoticons :-) which are sideways,"
    echo "  kaomoji are meant to be read straight-on! (^_^)"
    echo ""
    echo -e "${PINK}Key Elements:${RESET}"
    echo ""
    echo -e "  ${WHITE}EYES:${RESET}"
    echo "    ^ - Happy/closed eyes"
    echo "    o O - Open/surprised eyes"
    echo "    > < - Squinting (excited/embarrassed)"
    echo "    T ; - Crying eyes"
    echo "    - = - Neutral/relaxed"
    echo "    @ - Dizzy/confused"
    echo ""
    echo -e "  ${WHITE}MOUTHS:${RESET}"
    echo "    _ - Standard mouth"
    echo "    o - Open mouth (surprised/excited)"
    echo "    3 - Pouty/kissy"
    echo "    w - Cat mouth! Cute~"
    echo "    v - Happy/content"
    echo ""
    echo -e "  ${WHITE}SPECIAL MARKS:${RESET}"
    echo "    <3 - Heart/love"
    echo "    * - Sparkles"
    echo "    / \\ - Arms waving"
    echo "    zzZ - Sleeping"
    echo "    ; - Sweatdrop (nervous)"
    echo "    9 b - Fist pump!"
    echo ""
    echo -e "${GREEN}MUTSU'S FAVORITES:${RESET}"
    echo ""
    echo "  (^_^) - My default happy face!"
    echo "  (>///<) - B-blushing!! The slashes are blush marks!"
    echo "  (>:3) - Mischief mode! Gremlin energy~"
    echo "  (<3) - Heart! ...not that I'd use it for Sensei or anything!"
    echo "  \\(^o^)/ - Maximum excitement!"
    echo ""
    echo -e "${PINK}Pro tip: Copy these and use them everywhere!${RESET}"
    echo ""
}

# Random expression from a specific mood
random_mood() {
    local mood=$1
    local expressions
    expressions=$(get_expressions "$mood")

    if [[ -z "$expressions" ]]; then
        echo "Unknown mood: $mood"
        return 1
    fi

    # macOS compatible random selection (no shuf)
    local count
    count=$(echo "$expressions" | wc -l | tr -d ' ')
    local random_line=$((RANDOM % count + 1))
    echo "$expressions" | sed -n "${random_line}p"
}

# Random expression from ANY mood
random_any() {
    local moods=("happy" "love" "bratty" "soft" "tsun" "excited" "sad" "sleepy" "chaos" "sparkle" "greeting" "fighting" "thinking")
    local selected_mood=${moods[$RANDOM % ${#moods[@]}]}

    local expr
    expr=$(random_mood "$selected_mood")

    echo ""
    echo -e "${PINK}MUTSU says:${RESET} $expr"
    echo -e "${WHITE}(mood: ${selected_mood})${RESET}"
    echo ""
}

# ============================================
#   MAIN
# ============================================

case "${1:-}" in
    all|categories|help)
        show_categories
        ;;
    list)
        if [[ -n "${2:-}" ]]; then
            list_mood "$2"
        else
            echo "Usage: ./mutsu-expressions.sh list [mood]"
            echo "Example: ./mutsu-expressions.sh list love"
        fi
        ;;
    teach|learn|guide)
        teach_mode
        ;;
    "")
        random_any
        ;;
    *)
        # Assume it's a mood name
        expr=$(random_mood "$1" 2>/dev/null)
        if [[ -n "$expr" ]]; then
            echo ""
            echo -e "${PINK}MUTSU ($1):${RESET} $expr"
            echo ""
        else
            show_categories
        fi
        ;;
esac
