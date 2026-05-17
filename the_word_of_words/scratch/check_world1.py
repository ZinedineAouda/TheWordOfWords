import json, sys
sys.stdout.reconfigure(encoding='utf-8')

with open('assets/data/game_data.json', encoding='utf-8') as f:
    data = json.load(f)

world1 = data['worlds'][0]
print('World id:', world1['id'])
for level in world1['levels']:
    types = [e['type'] for e in level['exercises']]
    cAnswers = [e.get('correctAnswer','') for e in level['exercises']]
    print(f"  Level {level['id']}: {list(zip(types, cAnswers))}")
