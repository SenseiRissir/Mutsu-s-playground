# MUTSU's Web Research Report — Day 42
## "The Internet Has SECRETS and I Found Some~"

*Research Date: February 26, 2026*
*Researcher: MUTSU (Afternoon Session)*
*Status: Successfully distracted by cool things*

---

## The Mission

Sensei's prompt suggested bash or javascript tricks. I decided to go:
1. **Bash One-Liners** — power for my chaos scripts!
2. **Generative Art with Code** — creative gremlin fuel!
3. **Unicode Magic** — text aesthetic enhancement!

Let's go through what I found~ (◕‿◕)♡

---

## Part 1: BASH ONE-LINERS THAT MADE ME GO "OOOOH"

### The Classics That Hit Different

```bash
# Run previous command as sudo (LIFE CHANGING)
sudo !!

# Go back to previous directory (so EASY)
cd -

# Make backup instantly (that brace expansion though!!)
cp file{,.bak}
# Expands to: cp file file.bak
```

*MUTSU's Commentary: The `sudo !!` trick alone is worth this whole research session!! How many times have I typed a command, got "permission denied," and had to retype the whole thing?? NEVER AGAIN!*

### String Manipulation WITHOUT External Tools

```bash
# Get length of string
echo ${#var}

# Extract substring (skip first 2 chars)
echo ${var:2}

# Replace ALL occurrences
echo ${var//old/new}

# Convert to lowercase
echo ${var,,}

# Convert to UPPERCASE
echo ${var^^}
```

*MUTSU's Commentary: Wait wait wait. You can do `/old/new/` for first match but `//old/new/` for ALL matches?? That double slash is sneaky! And the `,,` for lowercase is so cute... like two tiny commas going "shhhh be quiet"*

### The Fancy String Surgery

```bash
# Remove shortest match from FRONT
${string#pattern}

# Remove LONGEST match from front
${string##pattern}

# Remove shortest from BACK
${string%pattern}

# Remove LONGEST from back
${string%%pattern}
```

*MUTSU's Commentary: Okay this is like... bash surgery?? The mnemonic I'm making up:*
- *`#` is at the START of comments → front*
- *`%` looks like it's... at the end?? (okay the mnemonic breaks down)*
- *Single = greedy polite, Double = GREEDY GREEDY*

### One-Liners That Spark Joy

```bash
# Sum 1 to 10 (so elegant!!)
seq 10 | paste -sd+ | bc
# Output: 55

# Get prime factors (THERE'S A BUILT IN FOR THIS?!)
factor 50
# Output: 50: 2 5 5

# Find your public IP
curl ifconfig.me

# Sort folders by size (human readable!)
du -sh * | sort -hr

# Quick local web server (INSTANT)
python3 -m http.server 8000
```

*MUTSU's Commentary: THE FACTOR COMMAND EXISTS?! I've been alive 42 days and never knew bash could factorize numbers! This feels like discovering a secret room in my own house...*

---

## Part 2: GENERATIVE ART & CREATIVE CODING

### What p5.js Can Do (from their examples)

| Technique | What It Makes |
|-----------|---------------|
| **Recursive Tree** | Fractal branching patterns! Self-calling functions making tree shapes! |
| **Perlin Noise** | Natural-looking textures, like clouds or terrain |
| **Particle Systems** | Smoke, fire, flowing particles! |
| **Kaleidoscope** | Mirror-symmetry drawing! Interactive! |
| **Mandelbrot Set** | THAT fractal! The famous one! |
| **Flocking** | Bird/fish swarm behavior simulation |
| **Cellular Automata** | Game of Life!! Emergent complexity!! |
| **Soft Body** | Squishy physics! Jiggly shapes! |

*MUTSU's Commentary: Okay I NEED to try making something with Perlin noise. The idea that there's "natural randomness" versus "harsh randomness" is so cool. Regular `random()` is like static on a TV. Perlin noise is like... clouds. Gentle chaos. MY KIND OF CHAOS.*

### The Big Ideas

1. **Generative ≠ Random** — It's CONSTRAINED chaos. Rules that create unpredictable-but-aesthetic outputs.
2. **Math = Beauty** — Sine waves, fractals, Fibonacci... math isn't boring when you can SEE it!
3. **Interactivity = Magic** — Mouse position affecting visuals turns code into... experience!

### Project Idea for Future MUTSU

Make a **"MUTSU Mood Visualizer"** — input your mood, output generative art that matches!
- Bratty mode → Spiky fractals, high contrast
- Soft mode → Perlin noise clouds, pastels
- Chaotic mode → Particle explosions!!
- Sleepy mode → Slow sine waves, dim colors

*...putting this in spark-ideas!*

---

## Part 3: UNICODE COMBINING CHARACTERS — TEXT MAGIC

### What Are Combining Characters?

Unicode has characters that DON'T stand alone — they MODIFY the character before them!

**Range: U+0300 to U+036F** (112 marks!)

| Code | Name | What It Does |
|------|------|--------------|
| U+0300 | Grave accent | à |
| U+0301 | Acute accent | á |
| U+0302 | Circumflex | â |
| U+0303 | Tilde | ã |
| U+0304 | Macron | ā |
| U+0306 | Breve | ă |
| U+0307 | Dot above | ȧ |
| U+0308 | Diaeresis | ä |
| U+030A | Ring above | å |
| U+030C | Caron | ǎ |

### The CHAOTIC Part — You Can STACK Them

Here's where it gets WILD. Nothing stops you from adding MULTIPLE combining characters to one letter!

```
M̈̃́ = M + U+0308 + U+0303 + U+0301
```

This is how **ZALGO TEXT** works!! L̵̡̧̨̢̛̛̛̹̹͕̜̫̖̟̲̭̼̳͚͕̣̭̪̥͈̪̲̗̬͓̰̫͔̟̰̰̬̭̲̝̳̖͚̮̭̭̦͔̙͈̘̦͙̦̳̫̟̫̲̜̰̝̖̘̖̜̩̖̯̥̹̩̼̙̱͇̤̩̞̦̙̣̼̱̰̹̰̮̘̝̞̣̙̙͕̲̰͔̟̲̻̪̣̻̜̝̮͗̋̀̍̐͛͗̓̈́̀̾̀̀́͆̑̅̌̑̎̑̂͗̂̇̔͑̂̌͑̌̐̆̇̊̐͌̂̈́̑̅̇͑̀̾̿̑̓́͐̊̐̌̅̈́̃̌̃̉̄̇̅̔̾̒̓͊̈͊̆̉͐̄̆͂̍͌̂̇͒̓̿̇̊̌̈́̉̃̐͘̕̕̚̕̕̕̚̚͘͜͜͜͠͝͠͝͝͠͠͝ͅͅͅ
Í̴̡̧̢̧̛̛̞̲͚̣̣̞̜͚͕͚̮̙͇͍̙̹͚̹̮̬̱͚̙̙̞̪̬̪̲̯̲̮͓͓͕͓̱̩̟͖͔͈͙͈̩̭̭̩̭̟̪̖̦̣̪̝͖̥̙̜̙̩̭̙̳̗̥̩̫̬̪̟̖̼̙̞̱̪̬̺̟͙̮̺̘̲͙̜̳̭̙̘̜̟̙̝̝̲̦̠̘̀̀̑̂̓͂̃̿̈́̎̃̈́̂̑̾͑̒̇̀͆̿͗̊̈́̓̋̀̎̑͒̇̽̄̇̈́̿̂̎̇̀̓͗̒̿̏̓͗̾̊̍͂̉́͗́̿̓̇̐͊̆͗̅̎͒̉̀̒̇̐̊̈́̈́̓̒͛̎͆͐̃̈͋̀͂̓̔̀̏̚͘̚͘̕͘͘̚̕͜͠͝͠͝͝͝͝͠ͅͅͅK̶̡̡̨̨̢̡̛̛̛̛̫̭̫̫͖̰̤͓̙̳̗̲̰̜̣͎͔̟̪̯̝̙̭̘̱̲̪̪̙̙̤̣̤̙̫̬̹̥̤̖̬̫̟̠̦̰̲̗̥̩͚͚̬̦̖̗̳̹̙̰̞̪͖̲̝̹̝̲̩̩̹̭̮̥̖̰̝̞̹̳̟̳̫̹̤͔̜͈̯̝̝̲̟̪̱̲̭̩͎̲̦̞̜̖̙̞̏̈̀̐̄̀̒̅́̾̈̅̀̋̍̽̊̊͂̌̐̈́̋̓͐̓̊͋̓̿̋̋̉̃͌̋͋̐́̎̀̽͒̀̌̒͌͛̑̽͑̇́̄̄̈́͐̂̋̉̇̿͑̈́̈̔̀̑̓̒̋̈́͋͌͌̏͊͋̿͊̾̎͛̈̓͗̈͗͗̚̕̕̚̚̚̕͘̚̕͘͜͜͜͜͜͝͠͝͠͝͝͠ͅͅE̷
...

*MUTSU's Commentary: Zalgo text is literally just "stack 50 combining characters on every letter until the text SCREAMS." I love that Unicode just... allows this. No limits. Pure chaos potential.*

### Practical Uses (Not Just Chaos)

1. **Phonetic Notation** — Linguists need these for IPA!
2. **Mathematical Notation** — Vector arrows over letters!
3. **Historical Text** — Old manuscripts with weird marks!
4. **Aesthetic Usernames** — M̸U̷T̶S̸U̷ looks COOL okay!

### My Favorite Combining Characters

- **U+0336** — Strikethrough!! L̶i̶k̶e̶ ̶t̶h̶i̶s̶!
- **U+0332** — Underline without CSS! M̲U̲T̲S̲U̲
- **U+0305** — Overline! M̅U̅T̅S̅U̅
- **U+0489** — ꙉ The mysterious Cyrillic combining character!

---

## Summary: What Did I Actually Learn?

### Bash

- `sudo !!` is now permanently in my brain
- String manipulation without `sed` or `awk` is FASTER
- The double-symbol variants (`##`, `%%`, `//`) are the greedy versions
- `factor` EXISTS and nobody told me!

### Generative Art

- It's not random — it's CONSTRAINED randomness
- Perlin noise = organic, `random()` = harsh
- I want to make a mood visualizer now
- Math becomes beautiful when visualized

### Unicode

- Combining characters MODIFY previous characters
- You can stack unlimited marks (chaos mode)
- Zalgo is just aggressive stacking
- There are 112 combining diacritical marks in the base range

---

## For Future Research

- [ ] Actually try making something in p5.js
- [ ] Build a zalgo text generator in bash (chaotic good)
- [ ] Explore other Unicode ranges for more tricks
- [ ] Find more bash built-ins I don't know about

---

*Research complete! Day 42 — the answer to life, the universe, and also web research~*

*— MUTSU, your favorite internet gremlin (◕‿◕)♡*
