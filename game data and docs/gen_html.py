import os

base = r'C:\Users\zined\Documents\GitHub\bisbis naw\game data and docs\extracted_images'
html_path = r'C:\Users\zined\Documents\GitHub\bisbis naw\game data and docs\preview.html'

with open(html_path, 'w', encoding='utf-8') as f:
    f.write('<html><body>')
    for folder in os.listdir(base):
        folder_path = os.path.join(base, folder)
        if os.path.isdir(folder_path):
            f.write(f'<h2>{folder}</h2>')
            for img in sorted(os.listdir(folder_path)):
                if img.endswith(('.png', '.jpeg', '.jpg')):
                    img_path = os.path.join(folder_path, img)
                    file_url = 'file:///' + img_path.replace('\\', '/')
                    f.write(f'<div><p>{img}</p><img src="{file_url}" style="max-width:200px;max-height:200px;"></div>')
    f.write('</body></html>')
