from PIL import Image
import os

base_dir = "C:/Users/zined/.gemini/antigravity/brain/03be0dc0-ce21-433b-b731-da6fffb56c92/"
target_dir = "c:/Users/zined/Documents/GitHub/bisbis naw/the_word_of_words/assets/images/exercises/"

if not os.path.exists(target_dir):
    os.makedirs(target_dir)

def crop_and_save(set_filename, mapping):
    path = os.path.join(base_dir, set_filename)
    if not os.path.exists(path):
        print(f"Skipping {set_filename}, not found.")
        return
    
    with Image.open(path) as img:
        # Assume 2x2 grid
        w, h = img.size
        cw, ch = w // 2, h // 2
        
        crops = {
            "tl": (0, 0, cw, ch),
            "tr": (cw, 0, w, ch),
            "bl": (0, ch, cw, h),
            "br": (cw, ch, w, h)
        }
        
        for pos, filename in mapping.items():
            if filename:
                crop = img.crop(crops[pos])
                crop.save(os.path.join(target_dir, filename))
                print(f"Saved {filename} from {set_filename} ({pos})")

# Mappings
crop_and_save("optimized_transportation_set_1777281280450.png", {
    "tl": "objects_airplane.png",
    "tr": "objects_car.png",
    "bl": "objects_bus.png",
    "br": "objects_bike.png"
})

crop_and_save("optimized_fruits_set_1777281299301.png", {
    "tl": "food_apple.png",
    "tr": "food_banana.png",
    "bl": "food_grapes.png",
    "br": "food_cherries.png"
})

crop_and_save("optimized_animals_set_1777281313735.png", {
    "tl": "animals_horse.png",
    "tr": "animals_octopus.png",
    "bl": "animals_fox.png",
    "br": None
})

crop_and_save("optimized_nature_set_1777282150470.png", {
    "tl": "nature_tree.png",
    "tr": "nature_flower.png",
    "bl": "nature_grass.png",
    "br": "nature_log.png"
})

crop_and_save("optimized_vegetables_set_1777282166830.png", {
    "tl": "food_carrot.png",
    "tr": "food_potatoes.png",
    "bl": "food_tomato.png",
    "br": "vegetables_onion.png"
})

crop_and_save("optimized_objects_set_2_1777282182320.png", {
    "tl": "nature_moon.png",
    "tr": "objects_log.png",
    "bl": "animals_deer.png",
    "br": "objects_train.png"
})
