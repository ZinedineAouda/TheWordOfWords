import sys
import io

# Set stdout to UTF-8
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

with open(r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\data\game_data.json', 'r', encoding='utf-8') as f:
    content = f.read()
    pos = 14175
    print(f"Character at {pos}: '{content[pos]}'")
    start = max(0, pos - 50)
    end = min(len(content), pos + 50)
    print(f"Context: '{content[start:end]}'")
