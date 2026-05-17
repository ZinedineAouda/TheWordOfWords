import fitz
import os
import sys

# Set encoding for output
sys.stdout.reconfigure(encoding='utf-8')

pdf_dir = r'c:\Users\zined\Documents\GitHub\bisbis naw\game data and docs'
output_dir = r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\scratch\rendered_pages'
os.makedirs(output_dir, exist_ok=True)

pdfs = [f for f in os.listdir(pdf_dir) if f.lower().endswith('.pdf')]

for pdf_name in pdfs:
    print(f"Rendering {pdf_name}...")
    try:
        doc = fitz.open(os.path.join(pdf_dir, pdf_name))
        for i in range(len(doc)):
            page = doc[i]
            pix = page.get_pixmap(dpi=150)
            filename = f"{pdf_name.replace('.pdf', '')}_page{i}.png"
            pix.save(os.path.join(output_dir, filename))
            print(f"  Saved {filename}")
        doc.close()
    except Exception as e:
        print(f"  Error processing {pdf_name}: {e}")

print("Done.")
