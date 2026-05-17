import json

with open(r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\data\game_data.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

images = []
for world in data['worlds']:
    for level in world['levels']:
        for exercise in level['exercises']:
            images.append(exercise.get('imageAsset'))

from collections import Counter
counts = Counter(images)
for img, count in counts.items():
    if count > 1:
        print(f"{img}: {count}")
