import fitz
import sys

# Set encoding for output
sys.stdout.reconfigure(encoding='utf-8')

pdf_path = r"C:\Users\zined\Desktop\PDF Reader_4_5814635267738311507.pdf"

try:
    doc = fitz.open(pdf_path)
    print(f"Total pages: {len(doc)}")
    for i in range(len(doc)):
        page = doc[i]
        print(f"--- Page {i+1} ---")
        text = page.get_text()
        print(text)
    doc.close()
except Exception as e:
    print(f"Error reading PDF: {e}")
