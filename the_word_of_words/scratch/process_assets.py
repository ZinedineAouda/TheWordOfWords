import os
import json
import random
from PIL import Image

# Paths
EXTRACTED_DIR = r"c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\scratch\extracted_exercises"
OUTPUT_IMG_DIR = r"c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\images\exercises"
JSON_OUTPUT_PATH = r"c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\data\game_data.json"

if not os.path.exists(OUTPUT_IMG_DIR):
    os.makedirs(OUTPUT_IMG_DIR)

# Data Mapping
# Format: { filename: (content_name, correct, options, world_id, type) }
DATA_MAP = {
    # WORLD 1: عالم الإبداع (Spelling World)
    "PDF Reader_4_5832438882137809149_p0_img0.jpeg": ("airplane", "طائرة", ["ح", "خ"], "world_1", "imageChoice"),
    "PDF Reader_4_5832438882137809149_p0_img2.jpeg": ("car", "سيارة", ["د", "ذ"], "world_1", "imageChoice"),
    "PDF Reader_4_5832438882137809149_p0_img1.jpeg": ("bus", "حافلة", ["ط", "ت"], "world_1", "imageChoice"),
    "PDF Reader_4_5832438882137809149_p0_img3.jpeg": ("bicycle", "دراجة", ["س", "ص"], "world_1", "imageChoice"),
    
    "PDF Reader_4_5832438882137809149_p1_img0.jpeg": ("cherries", "كرز", ["س", "ص"], "world_1", "imageChoice"),
    "PDF Reader_4_5832438882137809149_p1_img1.jpeg": ("bananas", "موز", ["م", "ن"], "world_1", "imageChoice"),
    "PDF Reader_4_5832438882137809149_p1_img2.jpeg": ("grapes", "عنب", ["ع", "غ"], "world_1", "imageChoice"),
    "PDF Reader_4_5832438882137809149_p1_img3.jpeg": ("apple", "تفاحة", ["ت", "ث"], "world_1", "imageChoice"),
    
    "PDF Reader_4_5832438882137809149_p1_img4.jpeg": ("horse", "حصان", ["ح", "خ"], "world_1", "imageChoice"),
    "PDF Reader_4_5832438882137809149_p1_img5.jpeg": ("octopus", "خطبوط", ["خ", "ح"], "world_1", "imageChoice"),
    "PDF Reader_4_5832438882137809149_p1_img6.jpeg": ("fox", "ثعلب", ["ث", "س"], "world_1", "imageChoice"),
    "PDF Reader_4_5832438882137809149_p1_img7.jpeg": ("giraffe", "زرافة", ["أ", "إ"], "world_1", "imageChoice"),

    # WORLD 2: عالم القلب (Similarity World)
    "PDF Reader_4_5825946708357422970_p1_box0.png": ("penguin", "بطريق", ["بطريق", "بثريق"], "world_2", "imageChoice"),
    "PDF Reader_4_5825946708357422970_p1_box3.png": ("box", "صندوق", ["صندوق", "سندوق"], "world_2", "imageChoice"),
    "PDF Reader_4_5825946708357422970_p1_box1.png": ("deer", "غزال", ["غزال", "خزال"], "world_2", "imageChoice"),
    "PDF Reader_4_5825946708357422970_p2_box1.png": ("scissors", "مقص", ["مقص", "مكس"], "world_2", "imageChoice"),
    "PDF Reader_4_5825946708357422970_p2_box0.png": ("train", "قطار", ["قطار", "كطار"], "world_2", "imageChoice"),
    "PDF Reader_4_5825946708357422970_p2_box2.png": ("whale", "حوت", ["حوت", "هوت"], "world_2", "imageChoice"),
    "PDF Reader_4_5825946708357422970_p4_box1.png": ("airplane2", "طائرة", ["طائرة", "تائرة"], "world_2", "imageChoice"),
    "PDF Reader_4_5825946708357422970_p5_img0.jpeg": ("sheep", "خروف", ["خروف", "غروف"], "world_2", "imageChoice"),

    # WORLD 4: عالم الحذف (Deletion World)
    "PDF Reader_عالم الحذف_p1_box0.png": ("bee", "نحلة", ["ح", "خ"], "world_4", "missingLetter"),
    "PDF Reader_عالم الحذف_p1_box1.png": ("bag", "حقيبة", ["ة", "ت"], "world_4", "missingLetter"),
    "PDF Reader_عالم الحذف_p1_box2.png": ("eye", "عين", ["ي", "ا"], "world_4", "missingLetter"),
    "PDF Reader_عالم الحذف_p1_box3.png": ("octopus_del", "خطبوط", ["ط", "ت"], "world_4", "missingLetter"),
}

# Add world 3 and 5 placeholders if needed, but let's focus on what we have.

# Base JSON Structure
game_data = {
    "worlds": [
        {
            "id": "world_1",
            "title": "عالم الإبداع",
            "description": "استبدل الحروف لتكوين كلمات جديدة",
            "iconAsset": "assets/icons/spelling_world.png",
            "themeColor": "FF6B6B",
            "isLocked": False,
            "levels": []
        },
        {
            "id": "world_2",
            "title": "عالم القلب",
            "description": "ميز بين الحروف المتشابهة في النطق",
            "iconAsset": "assets/icons/heart_world.png",
            "themeColor": "4ECDC4",
            "isLocked": False,
            "levels": []
        },
        {
            "id": "world_3",
            "title": "عالم الحروف المتشابهة",
            "description": "ابحث عن الحروف المختبئة",
            "iconAsset": "assets/icons/similar_letters_world.png",
            "themeColor": "FFD93D",
            "isLocked": False,
            "levels": []
        },
        {
            "id": "world_4",
            "title": "عالم الحذف",
            "description": "اكتشف الحرف الناقص في الكلمة",
            "iconAsset": "assets/icons/deletion_world.png",
            "themeColor": "6C5CE7",
            "isLocked": False,
            "levels": []
        },
        {
            "id": "world_5",
            "title": "عالم الإضافة",
            "description": "أضف الكلمة المناسبة لتكمل الجملة",
            "iconAsset": "assets/icons/addition_world.png",
            "themeColor": "A8E6CF",
            "isLocked": False,
            "levels": []
        }
    ]
}

processed_worlds = {}

for filename, (content_name, correct, options, world_id, game_type) in DATA_MAP.items():
    input_path = os.path.join(EXTRACTED_DIR, filename)
    if not os.path.exists(input_path):
        print(f"Skipping {filename}, not found.")
        continue

    # Crop Image
    with Image.open(input_path) as img:
        width, height = img.size
        # For _boxN files, crop top 75%
        # For _imgN files, no crop needed or very minimal
        if "_box" in filename:
            crop_box = (0, 0, width, int(height * 0.70))
            cropped = img.crop(crop_box)
        else:
            cropped = img
        
        output_filename = f"{content_name}.png"
        output_path = os.path.join(OUTPUT_IMG_DIR, output_filename)
        # Convert to RGBA to ensure compatibility
        cropped.convert("RGBA").save(output_path)
        print(f"Saved: {output_filename}")

    if world_id not in processed_worlds:
        processed_worlds[world_id] = []
    
    shuffled_options = list(options)
    random.shuffle(shuffled_options)

    exercise = {
        "id": f"ex_{content_name}",
        "type": game_type,
        "imageAsset": f"assets/images/exercises/{output_filename}",
        "correctAnswer": correct,
        "options": shuffled_options,
        "question": f"اختر الحرف المناسب لـ {correct}" if game_type == "imageChoice" else correct,
        "isLocked": False
    }
    
    if not processed_worlds[world_id] or len(processed_worlds[world_id][-1]["exercises"]) >= 4:
        level_num = len(processed_worlds[world_id]) + 1
        processed_worlds[world_id].append({
            "id": f"{world_id}_lvl_{level_num}",
            "title": f"المستوى {level_num}",
            "isLocked": False,
            "exercises": []
        })
    
    processed_worlds[world_id][-1]["exercises"].append(exercise)

for world in game_data["worlds"]:
    world_id = world["id"]
    if world_id in processed_worlds:
        world["levels"] = processed_worlds[world_id]
    else:
        # Add empty levels for worlds without data yet to keep them playable/viewable
        world["levels"] = [{
            "id": f"{world_id}_lvl_1",
            "title": "قريباً",
            "isLocked": False,
            "exercises": []
        }]

with open(JSON_OUTPUT_PATH, "w", encoding="utf-8") as f:
    json.dump(game_data, f, ensure_ascii=False, indent=2)

print("SUCCESS: Full asset and logic restoration complete.")
