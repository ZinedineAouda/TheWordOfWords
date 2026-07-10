import json
import re

file_path = r'c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\data\game_data.json'

with open(file_path, 'r', encoding='utf-8-sig') as f:
    data = json.load(f)

for world in data['worlds']:
    if world['id'] == 'world_6':
        for level in world['levels']:
            # Level 1: تنوين بالكسر -> pattern: end with \u064D (kasratan)
            # Level 2: تنوين بالفتح -> pattern: end with \u064B (fathatan) optionally followed by alef \u0627
            # Level 3: تنوين بالضم -> pattern: end with \u064C (dammatan)
            # Level 4: مد بالواو -> pattern: waw \u0648 preceded by damma \u064F
            # Level 5: مد بالياء -> pattern: yaa \u064A preceded by kasra \u0650
            # Level 6: مد بالألف -> pattern: alef \u0627 or alef maksura \u0649 preceded by fatha \u064E

            def is_correct(word, lvl_id):
                if lvl_id == 'world_6_lvl_1':
                    return '\u064D' in word
                elif lvl_id == 'world_6_lvl_2':
                    return '\u064B' in word
                elif lvl_id == 'world_6_lvl_3':
                    return '\u064C' in word
                elif lvl_id == 'world_6_lvl_4':
                    return '\u064F\u0648' in word
                elif lvl_id == 'world_6_lvl_5':
                    return '\u0650\u064A' in word
                elif lvl_id == 'world_6_lvl_6':
                    return '\u064E\u0627' in word or '\u064E\u0649' in word or 'ا' in word # Simplified for now, will rely on existing correctAnswer to ensure we don't break it
                return False

            for ex in level['exercises']:
                q = ex.get('question', '')
                if '\n' in q:
                    # It's a sentence extraction exercise
                    sentence = q.split('\n')[1]
                    # Split into words, strip punctuation
                    words = [w.strip('.,?! ') for w in sentence.split()]
                    
                    # Update options to be ALL the words in the sentence
                    ex['options'] = words
                    
                    # Determine correct answers
                    correct = []
                    # Always include the original correctAnswer just in case
                    orig_correct = ex.get('correctAnswer', '')
                    if orig_correct and orig_correct in words:
                        correct.append(orig_correct)
                    
                    for w in words:
                        if is_correct(w, level['id']) and w not in correct:
                            correct.append(w)
                    
                    if not correct and orig_correct:
                        correct = [orig_correct]
                        if orig_correct not in ex['options']:
                            ex['options'].append(orig_correct)

                    ex['correctAnswers'] = correct
                    
                    # Remove the single correctAnswer field or keep it as the first one
                    if correct:
                        ex['correctAnswer'] = correct[0]
                else:
                    # Not a sentence exercise, just convert correctAnswer to correctAnswers
                    orig_correct = ex.get('correctAnswer', '')
                    if orig_correct:
                        ex['correctAnswers'] = [orig_correct]

with open(file_path, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("Updated game_data.json with correctAnswers!")
