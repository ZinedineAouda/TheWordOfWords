import os
import re
import json
import base64

png_1x1 = base64.b64decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=')
# 1-byte valid mp3 is not really possible, but 0-byte file might not crash the audioplayers plugin, or maybe a tiny valid mp3
# A minimal valid mp3 frame:
mp3_minimal = bytes.fromhex('FFFB904400000000')

project_dir = r"c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words"
assets_to_create = set()

# Parse game_data.json
game_data_path = os.path.join(project_dir, 'assets', 'data', 'game_data.json')
try:
    with open(game_data_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    for world in data.get('worlds', []):
        if 'iconAsset' in world:
            assets_to_create.add(world['iconAsset'])
        for level in world.get('levels', []):
            for exercise in level.get('exercises', []):
                if 'imageAsset' in exercise and exercise['imageAsset']:
                    assets_to_create.add(exercise['imageAsset'])
                if 'audioAsset' in exercise and exercise['audioAsset']:
                    assets_to_create.add(exercise['audioAsset'])
except Exception as e:
    print(f"Error reading game_data.json: {e}")

# Parse dart files for hardcoded assets
for root, dirs, files in os.walk(os.path.join(project_dir, 'lib')):
    for file in files:
        if file.endswith('.dart'):
            with open(os.path.join(root, file), 'r', encoding='utf-8') as f:
                content = f.read()
                # Find all occurrences of 'assets/...' or 'audio/...' 
                # (since AudioService().playSound('audio/click.mp3') was used)
                matches = re.findall(r"'(assets/[^']+)'|\"(assets/[^\"]+)\"", content)
                for match in matches:
                    assets_to_create.add(match[0] or match[1])
                
                audio_matches = re.findall(r"'(audio/[^']+)'|\"(audio/[^\"]+)\"", content)
                for match in audio_matches:
                    assets_to_create.add('assets/' + (match[0] or match[1]))

for asset in assets_to_create:
    full_path = os.path.join(project_dir, asset)
    os.makedirs(os.path.dirname(full_path), exist_ok=True)
    if not os.path.exists(full_path):
        with open(full_path, 'wb') as f:
            if asset.endswith('.png') or asset.endswith('.jpg'):
                f.write(png_1x1)
            elif asset.endswith('.mp3'):
                f.write(mp3_minimal)
            else:
                f.write(b'')
        print(f"Created: {asset}")

print("Done.")
