import subprocess
import os
from PIL import Image

INPUT_IMAGE = "input.png"          # Put your photo name here
OUTPUT_IMAGE = "output_gray.png"   # The final hardware-calculated image

def image_to_txt(img_path):
    print("[1/4] Extracting image pixels...")
    img = Image.open(img_path).convert("RGB")
    # Resizing slightly helps the VHDL simulation complete in seconds
    img = img.resize((569, 433)) 
    width, height = img.size
    
    with open("input_pixels.txt", "w") as f:
        f.write(f"{width} {height}\n")
        for y in range(height):
            for x in range(width):
                r, g, b = img.getpixel((x, y))
                f.write(f"{r} {g} {b}\n")
    return width, height

def run_ghdl_simulation():
    print("[2/4] Compiling and running VHDL hardware simulation...")
    
    # Order-safe compilation command
    compile_cmd = "ghdl -a shifter.vhd greyadder.vhd toplevel_rgbtogrey.vhd gry_tb.vhd"
    elaborate_cmd = "ghdl -e gry_tb"
    run_cmd = "ghdl -r gry_tb"
    
    # Execute commands sequentially
    subprocess.run(compile_cmd, shell=True, check=True)
    subprocess.run(elaborate_cmd, shell=True, check=True)
    subprocess.run(run_cmd, shell=True, check=True)

def txt_to_image():
    print("[3/4] Reconstructing grayscale image from VHDL output...")
    if not os.path.exists("output_pixels.txt"):
        print("Error: VHDL simulation did not produce output_pixels.txt!")
        return

    with open("output_pixels.txt", "r") as f:
        lines = f.readlines()

    width, height = map(int, lines[0].split())
    gray_img = Image.new("L", (width, height))

    pixel_idx = 1
    for y in range(height):
        for x in range(width):
            gray_val = int(lines[pixel_idx].strip())
            gray_img.putpixel((x, y), gray_val)
            pixel_idx += 1

    gray_img.save(OUTPUT_IMAGE)
    print(f"[4/4] Success! Open '{OUTPUT_IMAGE}' to see your hardware processed photo.")

if __name__ == "__main__":
    if not os.path.exists(INPUT_IMAGE):
        print(f"Please drop an image named '{INPUT_IMAGE}' inside this folder first!")
    else:
        image_to_txt(INPUT_IMAGE)
        run_ghdl_simulation()
        txt_to_image()