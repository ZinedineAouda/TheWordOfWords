import sys

# Set encoding for output
sys.stdout.reconfigure(encoding='utf-8')
import fitz
import os
import io
from PIL import Image

pdf_dir = r'c:\Users\zined\Documents\GitHub\bisbis naw\game data and docs'
output_dir = r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\scratch\extracted_exercises'
os.makedirs(output_dir, exist_ok=True)

for pdf_name in os.listdir(pdf_dir):
    if not pdf_name.lower().endswith('.pdf'):
        continue
    
    print(f"Processing {pdf_name}...")
    doc = fitz.open(os.path.join(pdf_dir, pdf_name))
    for i in range(len(doc)):
        page = doc[i]
        image_list = page.get_images()
        for img_index, img in enumerate(image_list):
            xref = img[0]
            base_image = doc.extract_image(xref)
            image_bytes = base_image["image"]
            image_ext = base_image["ext"]
            
            # Save the image
            filename = f"{pdf_name.replace('.pdf', '')}_p{i}_img{img_index}.{image_ext}"
            with open(os.path.join(output_dir, filename), "wb") as f:
                f.write(image_bytes)
            print(f"  Saved {filename}")
    doc.close()

print("Done.")
