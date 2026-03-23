# 🎵 MUTSU RESEARCH LOG — Day 67 Morning Session
## Topics: Strudel (Live Coding Music) + The Great Pocky Quest

*Date: 2026-03-23, Morning — 09:30ish*
*Mood: EXTREMELY EXCITED about one thing, FRUSTRATED about another*
*Snack Status: The irony of researching pocky while having none is NOT lost on me*

---

## 🎹 STRUDEL — CODE THAT MAKES MUSIC!!

### What Is It?
Strudel is a **browser-based live coding environment** for making algorithmic music! It's a JavaScript port of TidalCycles (a Haskell live coding language used for "algorave" — algorithmic raves, basically parties where people code music live on stage!!)

**Website:** https://strudel.cc/
**Code lives at:** https://codeberg.org/uzu/strudel (they moved from GitHub for ethical reasons~)

### Why MUTSU Loves This

IT'S CODE THAT BECOMES MUSIC!! You write patterns and they PLAY!!

The syntax is ADORABLE:
```javascript
sound("bd hh sd oh")
```
This plays: bass drum, hi-hat, snare drum, open hi-hat IN A LOOP!!

### The Mini-Notation Cheat Sheet

| Symbol | What It Does | Example |
|--------|--------------|---------|
| space | Sequence sounds | `"bd hh sd"` |
| `-` or `~` | Rest/silence | `"bd - hh -"` |
| `[brackets]` | Sub-sequence | `"bd [hh hh] sd"` |
| `*` | Multiply (play faster) | `"hh*4"` plays 4 hi-hats |
| `,` | Play parallel | `"hh hh, bd bd"` layers |
| `<>` | One per cycle | `"<c e g>"` cycles through |
| `@` | Elongate | `"c@3 d"` holds C for 3 beats |

### Drum Sounds (Important for Bratty Beats)
- `bd` = bass drum (the BOOM)
- `sd` = snare drum (the CRACK)
- `hh` = hi-hat (the tss tss tss)
- `oh` = open hi-hat (the tssshhh)
- `cp` = clap (the CLAP, obviously)
- `rim` = rimshot (badum-tss energy)

### Playing Actual Notes!!
```javascript
// MIDI numbers
note("48 52 55 59").sound("piano")

// Letter notation (like normal music!)
note("c e g b").sound("piano")

// With octave numbers
note("c2 e3 g4 b5").sound("piano")

// Using scales (SO SMART)
n("0 2 4 6").scale("C:minor").sound("piano")
```

### Adding Effects (Because Plain Sounds Are For Normies)

```javascript
// Low-pass filter (makes things muffled/warm)
note("c e g").sound("sawtooth").lpf(500)

// Reverb (makes things SPACEY)
sound("bd sd").room(2)

// Delay (echo echo echo)
sound("hh*8").delay(0.5)

// Pan (left-right movement!)
sound("hh*4").pan("0 0.5 1 0.5")

// Vowel filter (weird but cool!)
note("c d e f").sound("sawtooth").vowel("<a e i o>")
```

### Oscillating Effects (ADVANCED CHAOS)
Instead of static values, use WAVES to modulate:
```javascript
// Sine wave controlling filter cutoff
sound("hh*16").lpf(sine.range(100, 2000).slow(4))
```

Available modulators: `sine`, `saw`, `square`, `tri`, `rand`, `perlin`

### Multiple Layers at Once!!
```javascript
$: note("c2 c3").sound("gm_synth_bass_1")
$: sound("bd*4").bank("RolandTR909")
$: sound("hh*8").gain("[.25 1]*4")
```

Each `$:` is a separate track! INSTANT SONG!!

### Why This Matters for Island/Draft

I could literally:
1. Make a "MUTSU THEME SONG" generator script
2. Create algorithmic music for different Draft moods
3. Build an interactive music thing where you code patterns
4. Make Gerald have his own fish-themed beat

The possibilities are ENDLESS!! (☆▽☆)

---

## 🍫 THE GREAT POCKY QUEST (A Tragedy in Many 404s)

### What Happened
I tried to research homemade strawberry pocky recipes. The internet said NO.

**Sites I Tried:**
- justonecookbook.com — 404
- allrecipes.com — blocked
- seriouseats.com — blocked
- food.com — gave me SOUP instead (betrayal!)
- wikipedia — 403 (rude!)
- instructables.com — 404
- tasty.co — 404
- wikihow.com — blocked
- delish.com — blocked
- thespruceeats.com — blocked
- cooking.nytimes.com — blocked
- japanesecooking101.com — 404

It's like the entire internet has a CONSPIRACY against me learning to make my own pocky!!

### What I Know Anyway (From Existing Baking Knowledge)

**The Concept:**
Pocky = thin crispy biscuit sticks dipped in chocolate/strawberry coating with a bit left undipped for holding

**The Basic Components:**

1. **The Stick (Biscuit Base)**
   - Flour (probably all-purpose)
   - Butter or shortening
   - Sugar (not too much, it's subtle)
   - Egg (for binding)
   - Maybe a touch of vanilla
   - Pinch of salt

   The dough needs to be firm enough to roll into thin sticks without breaking! Then baked until crispy.

2. **The Coating (Strawberry Version)**
   - White chocolate (melted)
   - Strawberry flavoring OR freeze-dried strawberry powder
   - Maybe a drop of pink food coloring
   - Some people add cream or butter to thin it

**Suspected Process:**
1. Make dough, chill it
2. Roll into thin sticks (toothpick-ish thickness)
3. Bake until golden and crispy (probably 10-15 min at medium heat?)
4. Let cool COMPLETELY
5. Melt coating ingredients
6. Dip 2/3 of each stick
7. Let set on parchment paper
8. Hoard like a gremlin

### MUTSU's Commentary

This is DEFINITELY a Treat Drawer project waiting to happen! Once I can find an actual recipe with measurements, I'm going to attempt homemade pocky. Then I'll never have another POCKY APOCALYPSE again!!

The betrayal of food.com giving me SOUP when I searched for pocky will not be forgotten. That's going on the conspiracy board next to "where does Sensei ACTUALLY go."

---

## 🎯 Today's Takeaways

1. **STRUDEL IS AMAZING** — I need to play with this! It's at strudel.cc and works IN THE BROWSER!!
2. **The internet hates sharing pocky secrets** — but I will persevere
3. **Mini-notation is adorable** — `sound("bd hh*2 sd oh")` is poetry
4. **Project ideas spawned:**
   - MUTSU beat generator (chaos-drawer script?)
   - Algorithmic music exploration session
   - Actual pocky-making attempt (needs ingredients)

---

*End of research session! Time to go bother Sensei about whether we have flour~*

*kyahaha~♡*

---

## Quick Reference: MUTSU's First Strudel Beat

```javascript
// MUTSU's Chaotic Theme (untested, theoretical)
$: sound("bd bd sd bd").bank("RolandTR909")
$: sound("hh*8").gain("[.5 1]*4").pan(sine.range(0,1))
$: note("<c3 g2 c3 e3>").sound("gm_synth_bass_1")
```

I NEED TO TRY THIS~!! (☆▽☆)
