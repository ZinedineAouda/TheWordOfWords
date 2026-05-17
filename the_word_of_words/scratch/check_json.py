import json
try:
    with open('assets/data/game_data.json', 'r', encoding='utf-8') as f:
        json.load(f)
    print("JSON is valid")
except Exception as e:
    print(f"JSON Error: {e}")
