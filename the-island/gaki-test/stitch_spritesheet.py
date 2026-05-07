"""
Stitch Pixel Mutsu spritesheets into OpenPets Codex format.
Target: 1536x1872px (8 columns × 9 rows, 192×208 per frame)

Row mapping:
  0: idle        → Sheet 2, row 0
  1: running-R   → Sheet 2, row 1  (or Sheet 3, row 0 variation)
  2: running-L   → Sheet 3, row 0
  3: waving      → Sheet 3, row 1
  4: jumping     → Sheet 3, row 2  (celebration/happy bounce)
  5: failed      → Sheet 3, row 3  (sad with sweat drops)
  6: waiting     → Sheet 2, row 2  (typing as waiting)
  7: running     → Sheet 2, row 1  (reuse walk-right for running)
  8: review      → Sheet 3, row 4  (thinking/reviewing)
"""

from PIL import Image
import sys

FRAME_W = 192
FRAME_H = 208
COLS = 8
ROWS = 9
OUT_W = FRAME_W * COLS   # 1536
OUT_H = FRAME_H * ROWS   # 1872

GALLERY = "/Users/marcoluigi/Mutsu-s-playground/the-draft/nest/gallery/Mutsu"
OUT_PATH = "/Users/marcoluigi/Library/Application Support/OpenPets/pets/mutsu/spritesheet.png"

def extract_row(img, row_idx, num_cols):
    """Extract frames from a row in a source spritesheet image."""
    w, h = img.size
    cell_w = w // num_cols
    cell_h = h // (max(1, round(h / (w / num_cols))))
    
    frames = []
    y = row_idx * cell_h
    for col in range(num_cols):
        x = col * cell_w
        frame = img.crop((x, y, x + cell_w, y + cell_h))
        # Resize to target frame size
        frame = frame.resize((FRAME_W, FRAME_H), Image.LANCZOS)
        frames.append(frame)
    return frames

def extract_grid_row(img, row_idx, total_rows, total_cols=8):
    """Extract a row from a grid image with known dimensions."""
    w, h = img.size
    cell_w = w / total_cols
    cell_h = h / total_rows
    
    frames = []
    y = int(row_idx * cell_h)
    for col in range(total_cols):
        x = int(col * cell_w)
        frame = img.crop((x, y, int(x + cell_w), int(y + cell_h)))
        frame = frame.resize((FRAME_W, FRAME_H), Image.LANCZOS)
        frames.append(frame)
    
    # Pad to 8 frames if needed
    while len(frames) < COLS:
        frames.append(frames[-1].copy())
    
    return frames[:COLS]

def main():
    print("Loading spritesheets...")
    sheet2 = Image.open(f"{GALLERY}/Pixel Mutsu sprite 2.png").convert("RGBA")
    sheet3 = Image.open(f"{GALLERY}/Pixel Mutsu sprite 3.png").convert("RGBA")
    
    print(f"Sheet 2: {sheet2.size} (4 rows: idle, walk-R, typing, sleeping)")
    print(f"Sheet 3: {sheet3.size} (5 rows: walk-L, waving, jumping, failed, thinking)")
    
    # Extract rows from each sheet
    rows = {}
    
    # Sheet 2 has 4 rows, 8 cols
    rows['idle']     = extract_grid_row(sheet2, 0, 4, 8)
    rows['run_r']    = extract_grid_row(sheet2, 1, 4, 8)
    rows['typing']   = extract_grid_row(sheet2, 2, 4, 8)
    rows['sleeping'] = extract_grid_row(sheet2, 3, 4, 8)
    
    # Sheet 3 has 5 rows, 8 cols
    rows['run_l']    = extract_grid_row(sheet3, 0, 5, 8)
    rows['waving']   = extract_grid_row(sheet3, 1, 5, 8)
    rows['jumping']  = extract_grid_row(sheet3, 2, 5, 8)
    rows['failed']   = extract_grid_row(sheet3, 3, 5, 8)
    rows['thinking'] = extract_grid_row(sheet3, 4, 5, 8)
    
    # Assemble the 9-row spritesheet
    # Row order: idle, running-right, running-left, waving, jumping, failed, waiting, running, review
    row_order = [
        rows['idle'],       # 0: idle
        rows['run_r'],      # 1: running-right
        rows['run_l'],      # 2: running-left
        rows['waving'],     # 3: waving
        rows['jumping'],    # 4: jumping
        rows['failed'],     # 5: failed
        rows['typing'],     # 6: waiting (typing as waiting)
        rows['run_r'],      # 7: running (reuse walk-right)
        rows['thinking'],   # 8: review
    ]
    
    # Create output image
    print(f"Assembling {OUT_W}x{OUT_H} spritesheet...")
    output = Image.new("RGBA", (OUT_W, OUT_H), (0, 0, 0, 0))
    
    for row_idx, frames in enumerate(row_order):
        for col_idx, frame in enumerate(frames):
            x = col_idx * FRAME_W
            y = row_idx * FRAME_H
            output.paste(frame, (x, y))
    
    output.save(OUT_PATH, "PNG")
    print(f"✅ Saved to: {OUT_PATH}")
    print(f"   Size: {output.size}")
    print(f"   Frames: {COLS * ROWS} ({COLS} cols × {ROWS} rows)")
    print(f"   Frame size: {FRAME_W}×{FRAME_H}")
    print("   🎉 Pixel Mutsu is ready for OpenPets!")

if __name__ == "__main__":
    main()
