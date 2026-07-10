import fitz
import sys

sys.stdout.reconfigure(encoding='utf-8')

pdf_path = r"C:\Users\zined\Desktop\PDF Reader_4_5814635267738311507.pdf"

doc = fitz.open(pdf_path)
print(f"Loaded PDF: {pdf_path}")
print(f"Number of pages: {len(doc)}")

# Let's inspect pages 1 to 12
for page_idx in range(min(12, len(doc))):
    page = doc[page_idx]
    text = page.get_text("text").strip()
    
    print(f"\n================ PAGE {page_idx + 1} ================")
    if text:
        print(text)
    else:
        print("[No text found]")
    
doc.close()
