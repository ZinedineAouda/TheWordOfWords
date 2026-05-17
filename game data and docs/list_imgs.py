import os

d = r'C:\Users\zined\Documents\GitHub\bisbis naw\game data and docs\extracted_images'
out = r'C:\Users\zined\Documents\GitHub\bisbis naw\game data and docs\dir_list.txt'

with open(out, 'w', encoding='utf-8') as f:
    for folder in os.listdir(d):
        folder_path = os.path.join(d, folder)
        if os.path.isdir(folder_path):
            f.write(f'{folder}:\n')
            for item in os.listdir(folder_path):
                f.write(f'  {item}\n')
