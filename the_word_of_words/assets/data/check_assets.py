import json
import os

json_path = r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\data\game_data.json'
base_path = r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words'

with open(json_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

for world in data['worlds']:
    for level in world['levels']:
        for exercise in level['exercises']:
            img = exercise.get('imageAsset')
            if img:
                full_path = os.path.join(base_path, img.replace('/', os.sep))
                print(f"Checking {full_path}")
                if os.path.exists(full_path):
                    size = os.path.getsize(full_path)
                    if size < 500:
                        print(f"Low size asset: {img} ({size} bytes) in {level['id']} - {exercise['id']}")
                else:
                    print(f"Missing asset: {img} in {level['id']} - {exercise['id']}")
