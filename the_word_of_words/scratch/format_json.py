import json

with open(r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\data\game_data.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

with open(r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\data\game_data.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print("JSON reformatted and validated.")
