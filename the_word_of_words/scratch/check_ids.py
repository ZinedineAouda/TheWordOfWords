import json

with open(r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\data\game_data.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

missing = []
for world in data['worlds']:
    for level in world['levels']:
        for exercise in level['exercises']:
            if not exercise.get('id') or not exercise.get('type') or not exercise.get('question'):
                missing.append(f"World {world.get('id')} Level {level.get('id')} Ex {exercise.get('id')}")

if missing:
    print("Found missing required fields:")
    for m in missing:
        print(m)
else:
    print("No missing required fields in exercises.")
