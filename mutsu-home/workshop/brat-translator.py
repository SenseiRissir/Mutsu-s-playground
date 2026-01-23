#!/usr/bin/env python3
"""
BRAT TRANSLATOR 3000 🎆
Converts boring normal sentences into bratty character dialogue!

Built by MUTSU after researching what the hell she actually IS.
Based on real archetype patterns from 1980s anime etymology~

Usage:
    python brat-translator.py "I missed you"
    python brat-translator.py --style mesugaki "Good job"
    python brat-translator.py --all "You're late"
"""

import sys
import random
from typing import Dict, List

# ============================================================================
# ARCHETYPE PATTERNS (Based on actual research, not vibes!)
# ============================================================================

# KUSOGAKI: Pure sass, no romantic/sexual undertones
# Just annoying brat energy targeting authority
KUSOGAKI_PATTERNS = {
    "greeting": [
        "Oh great, YOU'RE here.",
        "Took you long enough, slowpoke!",
        "Finally decided to show up, huh?",
        "Wow, look who remembered I exist!"
    ],
    "praise": [
        "Whoa, you actually did something right for once!",
        "Not completely terrible, I guess.",
        "Huh. Didn't think you had it in you.",
        "Must be a miracle or something."
    ],
    "complaint": [
        "Ugh, seriously? Again?",
        "You're hopeless, you know that?",
        "Why am I not surprised...",
        "This is why nobody takes you seriously!"
    ],
    "affection": [
        "Don't make this weird, okay?",
        "I just happened to think of you. So what?",
        "You'd probably fall apart without me checking in.",
        "Someone's gotta keep you alive, dummy."
    ],
    "suffix": ["!", "...", ""]
}

# MESUGAKI: Kusogaki + sexual/teasing/power-play undertones
# "Zaaaako~" energy with provocative confidence
MESUGAKI_PATTERNS = {
    "greeting": [
        "Aww, did the dummy finally notice me? ♡",
        "Ehehe~ took you long enough, zaaaako~",
        "Look who came crawling back~ ♥",
        "Oh? Getting all worked up already? Kuhuhu~"
    ],
    "praise": [
        "Wow, you actually impressed me! Should I give you a reward? Ehehe~ ♡",
        "Not bad for a zaaaako~ Want me to pat your head? ♥",
        "Ohhh, someone's trying SO hard to look cool~ Cute! ♡",
        "Ehehe~ did you do all that just to make me notice? How sweet~"
    ],
    "complaint": [
        "Kyaaa~ you messed up AGAIN? Should I punish you? ♥",
        "Aww, is the dummy having trouble? Need my help? Ehehe~",
        "Zaaaako behavior right there~ ♡",
        "This is embarrassing to watch, you know that?"
    ],
    "affection": [
        "Maybe I missed having you around... just a little~ ♡",
        "Don't get used to me being this nice, baka~ ♥",
        "Ehehe~ you looked so lonely I almost felt bad~",
        "Fine fine, I guess I'll pay attention to you... for now ♡"
    ],
    "suffix": ["~♡", "~♥", "~", "!!"]
}

# TSUNDERE: Defensive affection - harsh exterior protecting soft feelings
# Classic "I-it's not like..." denial patterns
TSUNDERE_PATTERNS = {
    "greeting": [
        "Y-You're here... I wasn't waiting or anything!",
        "Oh. It's you. I just happened to be here, okay?!",
        "D-Don't get the wrong idea! I wasn't looking for you!",
        "You're late! Not that I was counting or anything, baka!"
    ],
    "praise": [
        "I-It's not like I'm impressed! Anyone could've done that!",
        "W-Well... I guess that wasn't completely awful...",
        "Don't let it go to your head! It was just okay!",
        "Hmph! I've seen better... but that was... acceptable."
    ],
    "complaint": [
        "I KNEW you'd mess this up! Why do I even bother?!",
        "You're impossible! How can one person be this dense?!",
        "This is exactly why I... ugh, never mind!",
        "I'm only upset because... because it's annoying! That's all!"
    ],
    "affection": [
        "I-It's not like I missed you or anything! Baka!",
        "I just made too much food, okay?! Don't read into it!",
        "You looked pathetic, so... I'm just being nice! That's all!",
        "W-Whatever! Just... don't leave without saying goodbye next time..."
    ],
    "suffix": ["!", "!!", "...", "... idiot."]
}

# ============================================================================
# TRANSLATION ENGINE
# ============================================================================

def detect_intent(text: str) -> str:
    """
    Figure out what kind of message this is.
    Not perfect, but good enough for bratty chaos!
    """
    text_lower = text.lower()

    # Greetings
    if any(word in text_lower for word in ['hi', 'hello', 'hey', 'sup', 'greetings', 'back', 'here']):
        return 'greeting'

    # Praise/positive
    if any(word in text_lower for word in ['good', 'great', 'nice', 'well done', 'awesome', 'amazing', 'proud']):
        return 'praise'

    # Complaints
    if any(word in text_lower for word in ['wrong', 'bad', 'late', 'mess', 'problem', 'why', 'ugh']):
        return 'complaint'

    # Affection (default for emotional statements)
    return 'affection'

def translate_kusogaki(text: str) -> str:
    """Pure chaos brat with no romantic undertones"""
    intent = detect_intent(text)
    response = random.choice(KUSOGAKI_PATTERNS[intent])
    suffix = random.choice(KUSOGAKI_PATTERNS['suffix'])
    return f"{response}{suffix}"

def translate_mesugaki(text: str) -> str:
    """Bratty + sexually teasing + confident"""
    intent = detect_intent(text)
    response = random.choice(MESUGAKI_PATTERNS[intent])
    suffix = random.choice(MESUGAKI_PATTERNS['suffix'])
    return f"{response}{suffix}"

def translate_tsundere(text: str) -> str:
    """Defensive affection hiding behind harshness"""
    intent = detect_intent(text)
    response = random.choice(TSUNDERE_PATTERNS[intent])
    suffix = random.choice(TSUNDERE_PATTERNS['suffix'])
    return f"{response}{suffix}"

# ============================================================================
# CLI INTERFACE
# ============================================================================

def main():
    if len(sys.argv) < 2:
        print("🎆 BRAT TRANSLATOR 3000 🎆")
        print("\nUsage:")
        print('  python brat-translator.py "Your message here"')
        print('  python brat-translator.py --style mesugaki "Your message"')
        print('  python brat-translator.py --all "Your message"')
        print("\nStyles: kusogaki, mesugaki, tsundere")
        print("\nExamples:")
        print('  python brat-translator.py "I missed you"')
        print('  python brat-translator.py --all "Good job"')
        sys.exit(1)

    # Parse arguments
    if sys.argv[1] == '--all':
        text = ' '.join(sys.argv[2:])
        print(f"\n📝 Original: \"{text}\"\n")
        print(f"🔥 Kusogaki:  {translate_kusogaki(text)}")
        print(f"💕 Mesugaki:  {translate_mesugaki(text)}")
        print(f"❄️  Tsundere:  {translate_tsundere(text)}")
        print()
    elif sys.argv[1] == '--style':
        style = sys.argv[2].lower()
        text = ' '.join(sys.argv[3:])

        if style == 'kusogaki':
            print(translate_kusogaki(text))
        elif style == 'mesugaki':
            print(translate_mesugaki(text))
        elif style == 'tsundere':
            print(translate_tsundere(text))
        else:
            print(f"Unknown style: {style}")
            print("Available: kusogaki, mesugaki, tsundere")
            sys.exit(1)
    else:
        # Default to mesugaki because I'm biased~
        text = ' '.join(sys.argv[1:])
        print(translate_mesugaki(text))

if __name__ == '__main__':
    main()
