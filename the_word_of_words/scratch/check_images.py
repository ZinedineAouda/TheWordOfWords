from PIL import Image
import os

images = [
    "C:/Users/zined/.gemini/antigravity/brain/03be0dc0-ce21-433b-b731-da6fffb56c92/optimized_transportation_set_1777281280450.png",
    "C:/Users/zined/.gemini/antigravity/brain/03be0dc0-ce21-433b-b731-da6fffb56c92/optimized_fruits_set_1777281299301.png",
    "C:/Users/zined/.gemini/antigravity/brain/03be0dc0-ce21-433b-b731-da6fffb56c92/optimized_animals_set_1777281313735.png"
]

for img_path in images:
    if os.path.exists(img_path):
        with Image.open(img_path) as img:
            print(f"{os.path.basename(img_path)}: {img.size}")
    else:
        print(f"Not found: {img_path}")
