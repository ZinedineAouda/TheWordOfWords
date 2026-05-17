import json
import sys

def validate_json(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        print("JSON is valid.")
        print(f"Number of worlds: {len(data.get('worlds', []))}")
        for i, world in enumerate(data.get('worlds', [])):
            print(f"World {i+1}: {world.get('title', 'No Title')} - {len(world.get('levels', []))} levels")
    except Exception as e:
        print(f"JSON is invalid: {e}")

if __name__ == "__main__":
    validate_json(sys.argv[1])
