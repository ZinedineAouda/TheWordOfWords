import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

with open(r"c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\data\game_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

print(f"Total worlds in json: {len(data['worlds'])}")
for w in data['worlds']:
    print(f"World ID: {w['id']}, Title: {w['title']}, Levels count: {len(w['levels'])}")
