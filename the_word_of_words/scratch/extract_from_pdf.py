import fitz
import os
import sys

# Set encoding for output
sys.stdout.reconfigure(encoding='utf-8')

pdf_dir = r'c:\Users\zined\Documents\GitHub\bisbis naw\game data and docs'
output_dir = r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\scratch\extracted_exercises'
os.makedirs(output_dir, exist_ok=True)

pdfs = [f for f in os.listdir(pdf_dir) if f.lower().endswith('.pdf')]

for pdf_name in pdfs:
    print(f"Extracting from {pdf_name}...")
    try:
        doc = fitz.open(os.path.join(pdf_dir, pdf_name))
        for i in range(len(doc)):
            page = doc[i]
            # Find rectangles
            paths = page.get_drawings()
            
            count = 0
            for path in paths:
                for item in path["items"]:
                    if item[0] == "re": # rectangle
                        rect = item[1]
                        # Filter by size - exercise boxes are usually large
                        if rect.width > 150 and rect.height > 150 and rect.width < 500 and rect.height < 500:
                            # Render this specific area
                            pix = page.get_pixmap(clip=rect, dpi=300)
                            filename = f"{pdf_name.replace('.pdf', '')}_p{i}_box{count}.png"
                            pix.save(os.path.join(output_dir, filename))
                            print(f"  Saved {filename} ({rect.width:.1f}x{rect.height:.1f})")
                            count += 1
        doc.close()
    except Exception as e:
        print(f"  Error processing {pdf_name}: {e}")

print("Done.")
