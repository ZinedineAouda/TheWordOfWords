import json
import random

path = r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\data\game_data.json'

with open(path, 'r', encoding='utf-8') as f:
    data = json.load(f)

for world in data['worlds']:
    for level in world['levels']:
        for exercise in level['exercises']:
            options = exercise.get('options', [])
            if len(options) == 2:
                # Randomly decide to shuffle or not
                if random.choice([True, False]):
                    exercise['options'] = [options[1], options[0]]
            elif len(options) > 2:
                random.shuffle(exercise['options'])

# Specific fix for World 2 (Switch World) - Making it about metathesis
if len(data['worlds']) > 1:
    w2 = data['worlds'][1]
    w2['title'] = "عالم القلب (Switch World)"
    
    # Define some metathesis pairs
    pairs = [
        {"img": "nature_moon.png", "q": "حلم", "dist": "ملح"},
        {"img": "animals_horse.png", "q": "فرس", "dist": "سفر"},
        {"img": "objects_bag.png", "q": "سفر", "dist": "فرس"},
        {"img": "objects_tent.png", "q": "تبن", "dist": "بنت"},
        {"img": "food_milk.png", "q": "حليب", "dist": "حلبي"} # Not quite metathesis but close
    ]
    
    for i, level in enumerate(w2['levels']):
        for j, exercise in enumerate(level['exercises']):
            pair_idx = (i * 2 + j) % len(pairs)
            pair = pairs[pair_idx]
            exercise['imageAsset'] = f"assets/images/exercises/{pair['img']}"
            exercise['question'] = "ما هذه الكلمة؟"
            opts = [pair['q'], pair['dist']]
            random.shuffle(opts)
            exercise['options'] = opts
            exercise['correctAnswer'] = pair['q']

with open(path, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("Shuffled options and updated World 2.")
