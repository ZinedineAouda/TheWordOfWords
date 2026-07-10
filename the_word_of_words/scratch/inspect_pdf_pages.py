import fitz
import sys
import os

sys.stdout.reconfigure(encoding='utf-8')

pdf_path = r"C:\Users\zined\Desktop\PDF Reader_4_5814635267738311507.pdf"

if not os.path.exists(pdf_path):
    print(f"File not found: {pdf_path}")
    sys.exit(1)

doc = fitz.open(pdf_path)
print(f"Loaded PDF: {pdf_path}")
print(f"Number of pages: {len(doc)}")

for page_idx in range(len(doc)):
    page = doc[page_idx]
    text = page.get_text("text").strip()
    image_list = page.get_images(full=True)
    drawings = page.get_drawings()
    
    print(f"\n================ PAGE {page_idx + 1} ================")
    print(f"Images count: {len(image_list)}")
    print(f"Drawings count: {len(drawings)}")
    print("--- TEXT CONTENT ---")
    if text:
        print(text)
    else:
        print("[No text found]")
    
doc.close()
