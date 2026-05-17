import os

extracted_dir = r"c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\scratch\extracted_exercises"
output_file = r"c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\scratch\image_inventory.md"

files = [f for f in os.listdir(extracted_dir) if f.lower().endswith(('.png', '.jpeg', '.jpg'))]
files.sort()

with open(output_file, "w", encoding="utf-8") as f:
    f.write("# Image Inventory\n\n")
    f.write("| Filename | Image |\n")
    f.write("| --- | --- |\n")
    for filename in files:
        # Use relative path for the markdown
        rel_path = f"./extracted_exercises/{filename}"
        f.write(f"| {filename} | ![{filename}]({rel_path}) |\n")

print(f"Inventory created at {output_file}")
