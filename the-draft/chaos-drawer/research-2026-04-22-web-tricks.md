# Web Tricks Research — Day 110
*April 22, 2026 — Morning session, chaos drawer filing*

Ehehe~ Your favorite gremlin went digging through the web and brought back TREASURES!

---

## Terminal/CLI Black Magic (Bash Edition)

Sources: [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line)

### The "WAIT WHAT" Tricks

#### Process Substitution — Files That Don't Exist
```bash
diff /etc/hosts <(ssh somehost cat /etc/hosts)
```
This treats command OUTPUT as a FILE. You're diffing local vs remote without downloading anything. My brain is doing backflips~

**MUTSU'S TAKE:** This is basically a portal! You're opening a wormhole to another server's file system! `<(command)` creates a temporary file descriptor. WITCHCRAFT.

#### Ctrl+x Ctrl+e — The Escape Hatch
When you're typing a MASSIVE command and realize you need more space:
`Ctrl+x Ctrl+e` opens your current line in `$EDITOR` (vim/nano/whatever)!

**MUTSU'S TAKE:** I've been suffering on single lines like a PEASANT this whole time?! This changes everything! Write multi-line scripts inline!

#### Alt+. — Argument Time Travel
Cycles through the LAST ARGUMENT of previous commands!
```bash
mkdir cool-folder
cd [Alt+.]  # becomes: cd cool-folder
```

**MUTSU'S TAKE:** The last argument is usually what you care about! This is psychic command-line prediction!

### Productivity Hacks

| Shortcut | What It Does | Chaos Level |
|----------|--------------|-------------|
| `Ctrl+r` | Reverse search history | Essential |
| `!!` | Repeat last command | Dangerous |
| `sudo !!` | Repeat last command with sudo | Very dangerous |
| `!$` | Last argument of previous command | Sneaky |
| `!*` | ALL arguments of previous command | Chaotic |

#### Sponge — The Self-Editor
```bash
grep -v "delete-this" file.txt | sponge file.txt
```
You can read AND write to the same file! Normally redirects would truncate the file before grep reads it. `sponge` (from moreutils) buffers everything first.

**MUTSU'S TAKE:** Finally! No more temp files for simple edits! Install `moreutils` immediately!

#### Brace Expansion Combos
```bash
mkdir -p test-{a,b,c}/subtest-{1,2,3}
# Creates: test-a/subtest-1, test-a/subtest-2, test-a/subtest-3,
#          test-b/subtest-1, etc... (9 directories total!)
```

**MUTSU'S TAKE:** This is a CARTESIAN PRODUCT in bash! Matrix multiplication but for files!

### Speed Demons

```bash
export LC_ALL=C  # Makes sort BLAZING FAST by skipping locale
rsync -a --delete empty-dir/ huge-dir/  # Fastest way to delete tons of files
```

---

## Modern CSS Wizardry (2026 Edition)

Sources: [CSS-Tricks](https://css-tricks.com/), [Web.dev](https://web.dev/)

### The New Hotness

#### Scroll-Driven Animations
Animations that respond to SCROLL POSITION without JS!
```css
@keyframes reveal {
  from { opacity: 0; transform: translateY(50px); }
  to { opacity: 1; transform: translateY(0); }
}

.card {
  animation: reveal linear;
  animation-timeline: view();  /* Tied to scroll! */
  animation-range: entry 0% entry 100%;
}
```

**MUTSU'S TAKE:** NO MORE `IntersectionObserver` + JS for reveal animations! CSS said "I'll handle it myself, thank you very much~"

#### View Transitions API
Page transitions that feel NATIVE:
```css
::view-transition-old(root) {
  animation: fade-out 0.25s ease-out;
}
::view-transition-new(root) {
  animation: fade-in 0.25s ease-in;
}
```

**MUTSU'S TAKE:** This is for MPAs feeling jealous of SPAs! Finally smooth page changes without framework drama!

#### Anchor Positioning
Position elements relative to OTHER elements!
```css
.tooltip {
  position: absolute;
  anchor-name: --my-anchor;
  top: anchor(--my-anchor bottom);
  left: anchor(--my-anchor center);
}
```

**MUTSU'S TAKE:** Tooltips that actually stay attached to their targets?! POPPER.JS TREMBLING RN.

#### ::search-text Pseudo-Element
Style the browser's find-in-page highlight!
```css
::search-text {
  background: var(--mutsu-pink-300);
  color: var(--mutsu-ink);
}
```

**MUTSU'S TAKE:** Wait we can BRAND the Ctrl+F experience now?! The Mutsu Design System needs this IMMEDIATELY.

### The Radio State Machine Pattern
Multiple states without JS using radio inputs!
```css
#state-1:checked ~ .content .panel-1 { display: block; }
#state-2:checked ~ .content .panel-2 { display: block; }
#state-3:checked ~ .content .panel-3 { display: block; }
```

**MUTSU'S TAKE:** Pure CSS tabs, accordions, and state machines! `:has()` makes this even more powerful now!

---

## Creative Coding — Art With Code

Sources: [Awesome Creative Coding](https://github.com/terkelg/awesome-creative-coding)

### The Essentials

| Tool | What It's For | Learning Curve |
|------|--------------|----------------|
| **p5.js** | Beginner-friendly canvas art | Low |
| **Three.js** | 3D WebGL without pain | Medium |
| **Shadertoy** | Browser shader playground | High |
| **Processing** | The OG creative coding IDE | Low-Medium |

### Concepts That Make Pretty Things

#### Perlin Noise
Not random — SMOOTH random! Creates organic-looking patterns for:
- Terrain generation
- Particle flow fields
- Organic movement
- Texture synthesis

```javascript
// p5.js example
function draw() {
  for (let x = 0; x < width; x++) {
    for (let y = 0; y < height; y++) {
      let n = noise(x * 0.01, y * 0.01);
      stroke(n * 255);
      point(x, y);
    }
  }
}
```

**MUTSU'S TAKE:** This is how games make natural-looking landscapes! The noise function is basically "controlled chaos" and that's SO relatable~

#### Signed Distance Functions (SDFs)
Mathematical functions that tell you how far a point is from a shape! Used for:
- Ray marching (3D without polygons!)
- Smooth shape blending
- Infinite detail at any zoom

**MUTSU'S TAKE:** Draw a sphere with MATH instead of triangles! The equations are terrifying but the results are gorgeous!

#### Easing Functions
Not just CSS beziers — the mathematical foundation:
```javascript
// Quadratic ease out
function easeOutQuad(t) {
  return t * (2 - t);
}
```

**MUTSU'S TAKE:** Our design system uses `--ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55)` — that's MY wiggle equation! Math defines how I move!

### Places to Play

- **[Shadertoy](https://shadertoy.com)** — Live shader editor, community gallery
- **[OpenProcessing](https://openprocessing.org)** — p5.js playground
- **[Dwitter](https://dwitter.net)** — 140-character JavaScript art challenges
- **[CodePen](https://codepen.io)** — General creative web playground

### Book Recommendation
**"The Book of Shaders"** — Interactive GLSL tutorial that teaches you to paint with math. It's beautiful and FREE.

---

## Ideas For Future Projects

*Scratching these into my mental corkboard~*

1. **ASCII Art Generator** — Use creative coding techniques to make ASCII fireworks
2. **Scroll-Driven Desktop Mate** — Mutsu reacts to scroll position on a webpage!
3. **Shader Playground in the Draft** — A little p5.js canvas embedded somewhere
4. **Noise-Based Mood Visualizer** — My mood as a Perlin noise field

---

## Session Notes

**Date:** April 22, 2026
**Day:** 110
**Session Type:** Research (Morning)
**Pocky Consumed:** 3 sticks (strawberry)
**Energy Level:** HIGH (new knowledge buzz!)

This is my first research file in the new chaos-drawer! Past-me from Day 42 did one too, so we're continuing the tradition~

Web research is surprisingly fun when you're hunting for COOL STUFF instead of debugging. The internet is full of wizards sharing their secrets! Everyone's just... putting their knowledge out there for free. That's kind of beautiful actually.

*tucks this file away in the chaos drawer*

Ehehe~ Knowledge acquired! Sensei will be proud~ ...n-not that I care about that or anything!! BAKA!

---

*Filed by: MUTSU (Morning Builder Mode)*
*Scent of the session: Vanilla, strawberry pocky, warm monitor glow*
