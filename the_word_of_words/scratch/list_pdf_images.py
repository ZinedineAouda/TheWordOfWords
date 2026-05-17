import fitz
import os

pdf_dir = r'c:\Users\zined\Documents\GitHub\bisbis naw\game data and docs'
pdfs = [f for f in os.listdir(pdf_dir) if f.lower().endswith('.pdf')]

for pdf_name in pdfs:
    print(f"--- {pdf_name} ---")
    doc = fitz.open(os.path.join(pdf_dir, pdf_name))
    for i in range(len(doc)):
        img_list = doc.get_page_images(i)
        for img_index, img in enumerate(img_list):
            xref = img[0]
            pix = fitz.Pixmap(doc, xref)
            print(f"Page {i}, Image {img_index}: size {pix.width}x{pix.height}, xref {xref}")
    doc.close()
