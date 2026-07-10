import json
import os

json_path = r"c:\Users\zined\Documents\GitHub\bisbis naw\the_word_of_words\assets\data\game_data.json"

if not os.path.exists(json_path):
    print("Error: game_data.json not found!")
    exit(1)

with open(json_path, "r", encoding="utf-8") as f:
    data = json.load(f)

# Define world_6 with visually verified Alif Madd exercises
world_6 = {
    "id": "world_6",
    "title": "عالم حركات الحروف",
    "description": "تعلم التنوين والمد بالألف والواو والياء",
    "iconAsset": "assets/icons/switch_world.png",
    "themeColor": "9C27B0",
    "isLocked": False,
    "levels": [
        {
            "id": "world_6_lvl_1",
            "title": "التنوين بالكسر",
            "isLocked": False,
            "exercises": [
                {
                    "id": "ex_w6_l1_1",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالكسر",
                    "correctAnswer": "مكانٍ",
                    "options": ["مكانٍ", "ذهبت", "إلى"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l1_2",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالكسر",
                    "correctAnswer": "غصنٍ",
                    "options": ["غصنٍ", "رأيت", "عصفوراً"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l1_3",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالكسر",
                    "correctAnswer": "سريرٍ",
                    "options": ["سريرٍ", "نمت", "على"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l1_4",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالكسر",
                    "correctAnswer": "مطعمٍ",
                    "options": ["مطعمٍ", "أكلت", "طعاماً"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l1_5",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالكسر",
                    "correctAnswer": "كثيرٍ",
                    "options": ["كثيرٍ", "كثيرٌ", "كثيراً"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l1_6",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالكسر",
                    "correctAnswer": "قريبٍ",
                    "options": ["قريبٍ", "قريبٌ", "قريباً"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l1_7",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالكسر",
                    "correctAnswer": "طريقٍ",
                    "options": ["طريقٍ", "طريقٌ", "طريقاً"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l1_8",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالكسر",
                    "correctAnswer": "قطارٍ",
                    "options": ["قطارٍ", "قطارٌ", "قطاراً"],
                    "imageAsset": None,
                    "isLocked": False
                }
            ]
        },
        {
            "id": "world_6_lvl_2",
            "title": "التنوين بالفتح",
            "isLocked": False,
            "exercises": [
                {
                    "id": "ex_w6_l2_1",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالفتح",
                    "correctAnswer": "كتاباً",
                    "options": ["كتاباً", "جديداً", "قرأت"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l2_2",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالفتح",
                    "correctAnswer": "حقيبةً",
                    "options": ["حقيبةً", "حملت", "كبيرةً"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l2_3",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالفتح",
                    "correctAnswer": "حصاناً",
                    "options": ["حصاناً", "ركبت", "سريعاً"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l2_4",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالفتح",
                    "correctAnswer": "عصيراً",
                    "options": ["عصيراً", "شربت", "بارداً"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l2_5",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالفتح",
                    "correctAnswer": "تمساحاً",
                    "options": ["تمساحاً", "تمساحٌ", "تمساحٍ"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l2_6",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالفتح",
                    "correctAnswer": "غراباً",
                    "options": ["غراباً", "غرابٌ", "غرابٍ"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l2_7",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالفتح",
                    "correctAnswer": "بيتاً",
                    "options": ["بيتاً", "بيتٌ", "بيتٍ"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l2_8",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالفتح",
                    "correctAnswer": "خبزاً",
                    "options": ["خبزاً", "خبزٌ", "خبزٍ"],
                    "imageAsset": None,
                    "isLocked": False
                }
            ]
        },
        {
            "id": "world_6_lvl_3",
            "title": "التنوين بالضم",
            "isLocked": False,
            "exercises": [
                {
                    "id": "ex_w6_l3_1",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالضم",
                    "correctAnswer": "كتابٌ",
                    "options": ["كتابٌ", "هذا", "جديدٌ"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l3_2",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالضم",
                    "correctAnswer": "بنتٌ",
                    "options": ["بنتٌ", "هذه", "ذكيةٌ"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l3_3",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالضم",
                    "correctAnswer": "قطةٌ",
                    "options": ["قطةٌ", "هذه", "جميلةٌ"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l3_4",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالضم",
                    "correctAnswer": "نظيفٌ",
                    "options": ["نظيفٌ", "البيت", "ومرتبٌ"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l3_5",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالضم",
                    "correctAnswer": "ضفدعٌ",
                    "options": ["ضفدعٌ", "ضفدعاً", "ضفدعٍ"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l3_6",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالضم",
                    "correctAnswer": "فأرٌ",
                    "options": ["فأرٌ", "فأراً", "فأرٍ"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l3_7",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالضم",
                    "correctAnswer": "مدرسةٌ",
                    "options": ["مدرسةٌ", "مدرسةً", "مدرسةٍ"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l3_8",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها تنوين بالضم",
                    "correctAnswer": "إشارةٌ",
                    "options": ["إشارةٌ", "إشارةً", "إشارةٍ"],
                    "imageAsset": None,
                    "isLocked": False
                }
            ]
        },
        {
            "id": "world_6_lvl_4",
            "title": "المد بالواو",
            "isLocked": False,
            "exercises": [
                {
                    "id": "ex_w6_l4_1",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها مد بالواو",
                    "correctAnswer": "أزور",
                    "options": ["أزور", "أنا", "أصحابي"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l4_2",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها مد بالواو",
                    "correctAnswer": "يقول",
                    "options": ["يقول", "أخي", "حقاً"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l4_3",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها مد بالواو",
                    "correctAnswer": "نجوم",
                    "options": ["نجوم", "في", "السماء"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l4_4",
                    "type": "syllableCloud",
                    "question": "د.......وس",
                    "correctAnswer": "رو",
                    "options": ["رو", "ري", "را"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l4_5",
                    "type": "syllableCloud",
                    "question": "ص.......ور",
                    "correctAnswer": "دو",
                    "options": ["دو", "دي", "دا"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l4_6",
                    "type": "syllableCloud",
                    "question": "س.......ود",
                    "correctAnswer": "جو",
                    "options": ["جو", "جي", "جا"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l4_7",
                    "type": "syllableCloud",
                    "question": "ع.......ون",
                    "correctAnswer": "يو",
                    "options": ["يو", "يي", "يا"],
                    "imageAsset": None,
                    "isLocked": False
                }
            ]
        },
        {
            "id": "world_6_lvl_5",
            "title": "المد بالياء",
            "isLocked": False,
            "exercises": [
                {
                    "id": "ex_w6_l5_1",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها مد بالياء",
                    "correctAnswer": "كبير",
                    "options": ["كبير", "هذا", "رجل"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l5_2",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها مد بالياء",
                    "correctAnswer": "جاري",
                    "options": ["جاري", "أنا", "أساعد"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l5_3",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها مد بالياء",
                    "correctAnswer": "لطيف",
                    "options": ["لطيف", "الطفل", "جميل"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l5_4",
                    "type": "syllableCloud",
                    "question": "ي.......ش",
                    "correctAnswer": "عيـ",
                    "options": ["عيـ", "عو", "عا"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l5_5",
                    "type": "syllableCloud",
                    "question": "ي.......ر",
                    "correctAnswer": "سيـ",
                    "options": ["سيـ", "سو", "سا"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l5_6",
                    "type": "syllableCloud",
                    "question": "ر.......م",
                    "correctAnswer": "حيـ",
                    "options": ["حيـ", "عو", "عا"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l5_7",
                    "type": "syllableCloud",
                    "question": "ح.......م",
                    "correctAnswer": "كيـ",
                    "options": ["كيـ", "كو", "كا"],
                    "imageAsset": None,
                    "isLocked": False
                }
            ]
        },
        {
            "id": "world_6_lvl_6",
            "title": "المد بالألف",
            "isLocked": False,
            "exercises": [
                {
                    "id": "ex_w6_l6_1",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها مد بالألف",
                    "correctAnswer": "جاء",
                    "options": ["جاء", "أبي", "مبكراً"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l6_2",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها مد بالألف",
                    "correctAnswer": "سامي",
                    "options": ["سامي", "ذهب", "للبيت"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l6_3",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها مد بالألف",
                    "correctAnswer": "نام",
                    "options": ["نام", "الولد", "الصغير"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l6_4",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي بها مد بالألف",
                    "correctAnswer": "جمال",
                    "options": ["جمال", "وقف", "بالقرب"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l6_5",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي تحتوي على الألف الممدودة",
                    "correctAnswer": "صفا",
                    "options": ["صفا", "كتاب"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l6_6",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي تحتوي على الألف الممدودة",
                    "correctAnswer": "جنا",
                    "options": ["جنا", "نافذة"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l6_7",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي تحتوي على الألف الممدودة",
                    "correctAnswer": "دعا",
                    "options": ["دعا", "سيارة"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l6_8",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي تحتوي على الألف الممدودة",
                    "correctAnswer": "شكا",
                    "options": ["شكا", "الرمان"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l6_9",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي تحتوي على الألف الممدودة",
                    "correctAnswer": "رسا",
                    "options": ["رسا", "الثلج"],
                    "imageAsset": None,
                    "isLocked": False
                },
                {
                    "id": "ex_w6_l6_10",
                    "type": "imageChoice",
                    "question": "اختر الكلمة التي تحتوي على الألف الممدودة",
                    "correctAnswer": "نما",
                    "options": ["نما", "النهر"],
                    "imageAsset": None,
                    "isLocked": False
                }
            ]
        }
    ]
}

# Avoid duplicate world addition
existing_ids = [w['id'] for w in data['worlds']]
if 'world_6' not in existing_ids:
    data['worlds'].append(world_6)
    print("Appending world_6...")
else:
    # Replace existing world_6
    idx = existing_ids.index('world_6')
    data['worlds'][idx] = world_6
    print("Replacing existing world_6...")

with open(json_path, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("game_data.json updated successfully!")
