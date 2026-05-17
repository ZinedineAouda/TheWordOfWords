import os

used_images = [
    "objects_airplane.png", "objects_car.png", "objects_bus.png", "objects_bicycle.png",
    "food_cherries.png", "food_banana.png", "food_grapes.png", "food_apple.png",
    "animals_horse.png", "animals_octopus.png", "animals_fox.png", "animals_giraffe.png",
    "nature_log.png", "nature_flower.png", "nature_tree.png", "nature_grass.png",
    "food_carrot.png", "food_potatoes.png", "food_tomato.png", "vegetables_onion.png",
    "objects_tent.png", "objects_drum.png", "objects_ball.png", "objects_light_v2.png",
    "animals_penguin_v2.png", "objects_box_v2.png", "animals_chick_v2.png", "animals_deer.png",
    "objects_train.png", "objects_scissors_v2.png", "animals_whale_v2.png", "objects_shirt_v2.png",
    "animals_cat_v2.png", "objects_honey_v2.png", "food_milk_v2.png", "animals_sheep_v2.png",
    "animals_dog_v2.png", "objects_picture_v2.png", "objects_bag.png", "animals_bee_v2.png",
    "hunger.png", "body_eye.png", "nature_moon.png", "food_bread.png", "colors_red.png"
]

exercise_dir = r"c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\images\exercises"

for filename in os.listdir(exercise_dir):
    if filename not in used_images:
        file_path = os.path.join(exercise_dir, filename)
        try:
            os.remove(file_path)
            print(f"Deleted unused image: {filename}")
        except Exception as e:
            print(f"Error deleting {filename}: {e}")

print("Cleanup complete!")
