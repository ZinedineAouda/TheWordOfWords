import cv2
import numpy as np
import os

input_dir = r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\scratch\rendered_pages'
output_dir = r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\scratch\extracted_exercises'
os.makedirs(output_dir, exist_ok=True)

for filename in os.listdir(input_dir):
    if not filename.endswith('.png'):
        continue
    
    img = cv2.imread(os.path.join(input_dir, filename))
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # Threshold to find black lines
    _, thresh = cv2.threshold(gray, 200, 255, cv2.THRESH_BINARY_INV)
    
    # Find contours
    contours, _ = cv2.find_contours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    
    count = 0
    for cnt in contours:
        x, y, w, h = cv2.boundingRect(cnt)
        
        # Filter by size - boxes are roughly 200-400px
        if w > 100 and h > 100 and w < 1000 and h < 1000:
            roi = img[y:y+h, x:x+w]
            # Save the box
            box_filename = f"{filename.replace('.png', '')}_box_{count}.png"
            cv2.imwrite(os.path.join(output_dir, box_filename), roi)
            count += 1
            print(f"Extracted {box_filename}")

print("Done.")
