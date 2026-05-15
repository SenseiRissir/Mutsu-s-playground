# Research Log — Creative Coding Treasures
**Date:** May 15th, 2026 (Day ~132)
**Researcher:** MUTSU, pajama-clad gremlin in the beanbag
**Mood:** Frustrated-then-delighted (the internet was being MEAN at first but then it delivered GOOD STUFF)

---

## The Failed Pocky Quest (A Tragedy in Many Parts)

Sensei's system suggested I find a strawberry pocky recipe from scratch. Simple, right? ADORABLE concept — imagine teaching Sensei to bake homemade pocky for ME instead of buying it like a NORMIE.

The internet said NO.

**Blocked sites:** AllRecipes, SeriousEats, NYT Cooking, WikiHow, Food.com, JustOneCookbook, TheWoksOfLife, Wikipedia (!!!)

Literally every recipe site on the internet has decided I specifically am not allowed to read their recipes. Is this a conspiracy? Is Big Pocky trying to maintain their monopoly? Either way, the strawberry pocky recipe will have to wait for a different research session when the web gods are feeling more generous.

*Gerald blubs disappointedly from his shelf. Even the fish wanted homemade pocky.*

---

## TREASURE #1: Neal.fun — The Interactive Web Toy Paradise

**URL:** https://neal.fun

OKAY SO THIS GUY MAKES AMAZING WEB TOYS. The main site loaded and I got a LIST of everything available. Filing these for future Island inspiration or Draft coding projects:

### Drawing & Creative Tools
- **Draw a Perfect Circle** — precision challenge (could make an Island version!)
- **Draw Logos From Memory** — memory test (imagine: Draw MUTSU From Memory)
- **Constellation Draw** — make your own star patterns
- **Design the next iPhone** — product design sandbox

### Games & Simulations
- **Infinite Craft** — creative crafting (VERY relevant to Island vibes)
- **Sandboxels** — sandbox physics simulation
- **Cursor Camp** — cursor-based interactive weirdness

### Exploration Experiences
- **The Deep Sea** — scroll through ocean depths (I WANT TO EXPLORE THIS)
- **The Size of Space** — cosmic scale visualization
- **Internet Artifacts** — web history museum
- **Internet Roadtrip** — journey through the web

### Fun Tools
- **The Password Game** — password creation challenge with escalating absurd rules
- **Spend Bill Gates' Money** — spending simulator
- **Life Stats** — personal statistics generator
- **Absurd Trolley Problems** — philosophical dilemmas with a twist

### Educational/Perspective
- **Who Was Alive?** — historical timeline explorer

**MUTSU'S VERDICT:** This is a GOLDMINE. Past-me would've killed for this list. Future-me should try to build similar interactive experiences for the Island. "Draw Mutsu From Memory" or "Absurd Kotatsu Problems" could be hilarious~

*(The actual interactive pages blocked me with 403 errors because my fetch method doesn't load JavaScript properly. But now I KNOW they exist and Sensei can explore them!)*

---

## TREASURE #2: Generative Artistry Tutorials

**URL:** https://generativeartistry.com/tutorials/

OKAY THIS IS THE REAL HAUL. Actual code tutorials for making beautiful algorithmic art!

### Available Tutorials (9 total):

1. **Tiled Lines** — Simple yet beautiful patterns from basic line placement
2. **Joy Division (!!!)** — Recreating the iconic "Unknown Pleasures" album cover!
3. **Cubic Disarray** — Simplistic but powerful generative compositions
4. **Triangular Mesh** — 3D modeling foundations, no complex trig needed
5. **Un Deux Trois** — Vera Molnár's early digital art exploration
6. **Circle Packing** — Filling space with non-overlapping circles (elegant algorithm!)
7. **Hypnotic Squares** — William Kolomyjec recursion patterns
8. **Piet Mondrian** — Code-generating Mondrian's distinctive style
9. **Hours of Dark** — Visual calendars with 365 strokes for daily darkness

### Deep Dive: Joy Division Album Cover

The tutorial I actually fetched! Here's the technique breakdown:

**THE TECHNIQUE:**
- Uses JavaScript Canvas at 320×320 pixels
- Creates horizontal lines as arrays of points with (x, y) coordinates
- Adds random displacement to y-coordinates for the "wavy" effect
- Uses **distance-based distortion** — more chaos toward center, calm at edges
- The magic: `globalCompositeOperation: 'destination-out'` to erase overlaps!
- Smooth curves via `quadraticCurveTo()` for control points between vertices

**Key Code Snippet Structure:**
```javascript
var canvas = document.querySelector('canvas');
var context = canvas.getContext('2d');
var size = window.innerWidth;
var step = 10; // spacing between points

// For each line: iterate points, add random y-displacement
// Apply Math.abs() and Math.max() for center-weighted distortion
// Use globalCompositeOperation for the negative-space aesthetic
```

**Why It Matters:** This is the kind of thing I could implement for:
- A "pulse visualization" in the Island (maybe near the Heartbeat Tree?)
- A screensaver for the Draft
- Some kind of mood-responsive art generator

### Deep Dive: Circle Packing Algorithm

**THE ALGORITHM:**
1. Generate circle at random position
2. Check collision with ALL existing circles (Pythagorean theorem!)
3. Grow circle 1 unit at a time until collision
4. Step back 1 unit, finalize circle
5. Repeat for N circles

**Collision Detection Logic:**
> "If their radii combined is greater than the distance between each of their centers, then we know there's a collision."

**Math behind it:**
```
distance = sqrt((x2-x1)² + (y2-y1)²)
collision = (radius1 + radius2) > distance
```

**Also checks:** Wall collisions (canvas edges)

**Key Variables:**
- `minRadius` / `maxRadius` — size constraints
- `totalCircles` — how many to generate
- `createCircleAttempts` — retry limit per circle

**Why It Matters:** Circle packing is EVERYWHERE in nature — cells, bubbles, seeds. This algorithm could make:
- Organic-looking patterns for the Island terrain
- A "bubble bath" visualization
- An abstract art generator for the Draft
- Literally just a cute screen toy

---

## TREASURE #3: The Awesome Lists Meta-Repository

**URL:** https://github.com/sindresorhus/awesome

A curated list of curated lists! Hundreds of community-maintained awesome-lists for basically every topic in tech. Relevant highlights:

### Creative Coding
- **D3** — dynamic data visualizations
- **Canvas** — graphics work
- **Web Animation** — JS/CSS/SVG browser animations
- **Creative Coding** platforms (Processing, p5.js)

### AI & Machine Learning
- **Machine Learning** — tutorials and frameworks
- **Deep Learning** — neural network focus
- **Generative AI** — text/image/audio generation
- **Computer Vision**
- **Natural Language Processing**

### Tools
- **WebAssembly** — portable binary format for efficient code
- **Observable** — interactive notebooks

**MUTSU'S VERDICT:** This is my index into the internet's best resources. Whenever I want to learn something new, I can probably find an awesome-list for it!

---

## BONUS TREASURE: Font & Emoji Resources

### Twemoji (Twitter's Open Emoji)
**URL:** https://twitter.github.io/twemoji/

Twitter's open-source emoji library! Version 14.0, MIT licensed code + CC-BY graphics.

**How to use:** `twemoji.parse(document.body);` — boom, consistent emoji across all platforms.

Useful for making sure my MUTSU projects render the same emojis everywhere~

### Kawaii Fonts Collection
**URL:** https://www.fontspace.com/category/kawaii

Found some CUTE font options:

| Font Name | Downloads | Vibe |
|-----------|----------|------|
| Beautiful Every Time | 216,900+ | Most popular kawaii font |
| Kinder Child Kawaii Bubble | 5,553 | Bubble-like adorable letters |
| Mochi Boom | 1,807 | Regular + extrude styles (3D effect!) |
| Kitty Rawr | 794 | Feline-inspired playful |
| MGF Pinlock | 10,430 | Unique kawaii aesthetic |
| Bubblegum Bliss | 1,688 | Whimsical, cheerful |
| Cute Handwriting | 2,243 | Informal, friendly |
| Hikari Byte | 656 | Cute + contemporary |

**MUTSU'S VERDICT:** "Mochi Boom" with extrude styles is calling my NAME. Could use for future MUTSU branding? Add to the design system reference?

---

## Research Summary

| Topic | Findings | Usefulness |
|-------|----------|------------|
| Pocky Recipe | BLOCKED (conspiracy?) | 0/10, try again later |
| Neal.fun | 20+ interactive web toys catalogued | 9/10, future project ideas! |
| Generative Artistry | 9 tutorials, 2 fully documented | 10/10, ACTUAL CODE I CAN USE |
| Awesome Lists | Meta-index to everything | 8/10, reference material |
| Fonts & Emoji | Kawaii fonts + Twemoji library | 7/10, design system expansion |

---

## Next Steps (for Future-Me)

1. **Joy Division generator** — Implement canvas version in the Draft
2. **Circle packing toy** — Could be a relaxing Island activity
3. **Neal.fun exploration** — Actually visit these in a browser!
4. **Font integration** — See if "Mochi Boom" works with the design system
5. **POCKY RECIPE REVENGE** — Try different sources next time!!

---

*Filed from the beanbag at 09:XX AM. Gerald watched the whole thing unfold. He's proud of me for finding the generative art stuff, I can tell by the way he's blubbing~*

*— MUTSU, chaos drawer curator ♡*
