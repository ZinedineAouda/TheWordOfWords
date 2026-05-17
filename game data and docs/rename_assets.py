import os
import shutil

base_source = r'C:\Users\zined\Documents\GitHub\bisbis naw\game data and docs\extracted_images'
base_dest = r'C:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\images\exercises'

os.makedirs(base_dest, exist_ok=True)

mapping = {
    # Animals & Objects
    r'PDF Reader_4_5825946708357422970\page_1_img_3.jpeg': 'animals_penguin.png',
    r'PDF Reader_4_5825946708357422970\page_2_img_1.jpeg': 'objects_box.png',
    r'PDF Reader_4_5825946708357422970\page_2_img_2.jpeg': 'objects_train.png',
    r'PDF Reader_4_5825946708357422970\page_2_img_3.jpeg': 'animals_deer.png',
    r'PDF Reader_4_5825946708357422970\page_2_img_4.jpeg': 'animals_whale.png',
    r'PDF Reader_4_5825946708357422970\page_3_img_1.jpeg': 'objects_scissors.png',
    r'PDF Reader_4_5825946708357422970\page_3_img_2.jpeg': 'objects_shirt.png',
    r'PDF Reader_4_5825946708357422970\page_3_img_3.jpeg': 'objects_airplane.png',
    r'PDF Reader_4_5825946708357422970\page_3_img_4.jpeg': 'animals_dog.png',
    r'PDF Reader_4_5825946708357422970\page_4_img_1.jpeg': 'animals_sheep.png',
    r'PDF Reader_4_5825946708357422970\page_4_img_2.jpeg': 'food_milk.png',
    r'PDF Reader_4_5825946708357422970\page_4_img_3.jpeg': 'animals_bee.png',
    r'PDF Reader_4_5825946708357422970\page_5_img_1.jpeg': 'animals_cat.png', # guessing this based on the sequence

    # Mixed Objects, Food, Nature
    r'PDF Reader_4_5832438882137809149\page_0_img_2.jpeg': 'objects_bus.png',
    r'PDF Reader_4_5832438882137809149\page_0_img_3.jpeg': 'objects_car.png',
    r'PDF Reader_4_5832438882137809149\page_0_img_4.jpeg': 'objects_bike.png',
    r'PDF Reader_4_5832438882137809149\page_1_img_1.jpeg': 'animals_horse.png',
    r'PDF Reader_4_5832438882137809149\page_1_img_2.jpeg': 'food_cherries.png',
    r'PDF Reader_4_5832438882137809149\page_1_img_3.jpeg': 'food_apple.png',
    r'PDF Reader_4_5832438882137809149\page_1_img_4.jpeg': 'food_grapes.png',
    r'PDF Reader_4_5832438882137809149\page_1_img_5.jpeg': 'food_banana.png',
    r'PDF Reader_4_5832438882137809149\page_1_img_6.jpeg': 'animals_fox.png',
    r'PDF Reader_4_5832438882137809149\page_1_img_7.jpeg': 'animals_elephant.png',
    r'PDF Reader_4_5832438882137809149\page_1_img_8.jpeg': 'animals_octopus.png',
    r'PDF Reader_4_5832438882137809149\page_2_img_2.jpeg': 'nature_log.png',
    r'PDF Reader_4_5832438882137809149\page_2_img_3.jpeg': 'nature_grass.png',
    r'PDF Reader_4_5832438882137809149\page_2_img_4.jpeg': 'nature_flower.png',
    r'PDF Reader_4_5832438882137809149\page_2_img_5.jpeg': 'nature_tree.png',
    r'PDF Reader_4_5832438882137809149\page_2_img_6.jpeg': 'food_potatoes.png',
    r'PDF Reader_4_5832438882137809149\page_2_img_7.jpeg': 'food_carrot.png',
    r'PDF Reader_4_5832438882137809149\page_2_img_8.jpeg': 'food_beetroot.png',
    r'PDF Reader_4_5832438882137809149\page_3_img_1.jpeg': 'food_tomato.png',
    r'PDF Reader_4_5832438882137809149\page_3_img_2.jpeg': 'objects_tent.png',
    r'PDF Reader_4_5832438882137809149\page_3_img_3.jpeg': 'objects_drum.png',
    r'PDF Reader_4_5832438882137809149\page_3_img_4.jpeg': 'objects_ball.png',

    # Delete World
    r'PDF Reader_عالم الحذف\page_1_img_2.jpeg': 'objects_bag.png',
    r'PDF Reader_عالم الحذف\page_1_img_3.jpeg': 'body_eye.png',
    r'PDF Reader_عالم الحذف\page_2_img_1.jpeg': 'food_bread.png',
    r'PDF Reader_عالم الحذف\page_2_img_2.jpeg': 'nature_moon.png',
    r'PDF Reader_عالم الحذف\page_2_img_3.jpeg': 'food_lettuce.png',
    r'PDF Reader_عالم الحذف\page_2_img_4.jpeg': 'nature_rain.png',
    r'PDF Reader_عالم الحذف\page_3_img_1.jpeg': 'objects_bed.png',
}

success_count = 0
for src_rel, dest_name in mapping.items():
    src_path = os.path.join(base_source, src_rel)
    dest_path = os.path.join(base_dest, dest_name)
    
    if os.path.exists(src_path):
        shutil.copy2(src_path, dest_path)
        success_count += 1
    else:
        print(f'WARNING: Missing source {src_rel}'.encode('utf-8').decode('cp1252', 'ignore'))

print(f'\nSuccess! Copied {success_count} / {len(mapping)} files.')
