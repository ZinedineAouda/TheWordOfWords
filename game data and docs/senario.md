
# 📖 FULL USER SCENARIO: "أحمد's Journey"

## Scene 1: Opening the App

**أحمد** (7 years old) taps the app icon. A colorful splash screen appears with a bouncing heart logo "عالم القلب". Gentle Arabic music plays. The main menu shows 5 world icons arranged like a map: a heart (locked), a magnifying glass (locked), a plus sign (locked), an eraser (locked), and a pencil (unlocked - glowing).

## Scene 2: First Level - "عالم الإدباء" (Spelling World)

أحمد taps the pencil world. A friendly voice says "عالم الإدباء!" He sees Level 1 with 3 empty stars. He taps it.

**Exercise 1:** An airplane image appears with "_ائرة" and a box showing "ح". Two letter buttons: "ح" and "خ". He taps "ح". Green flash! "أحسنت!" +10 coins. The word "طائرة" completes with a fly-out animation.

**Exercise 2:** A car image with "_يارة" and "د". He taps "د". Correct! +10 coins. Progress: 2/15.

**Exercise 3:** A bus with "_افلة" and "ط". He accidentally taps "ت". Red shake. "حاول مرة أخرى". He tries "ط". Correct! +10 coins.

...After 15 exercises, he gets 2 stars (2 wrong answers). +50 level bonus. Total coins: 170.

## Scene 3: Exploring Locked Worlds

أحمد tries to tap "عالم القلب" (heart). A popup: "أكمل 3 مستويات في عالم الإدباء لفتح هذا العالم!" (Complete 3 levels to unlock). He goes back, plays Level 2 and 3. Now has 3 stars total across levels. "عالم القلب" unlocks with a sparkle animation!

## Scene 4: "عالم القلب" - Picture Matching

He enters the heart world. Level 1 shows a penguin. Two words: "بطريق" and "بثريق". He remembers the penguin says "ططط" not "ثثث". Taps "بطريق". Correct! Green highlight. +10 coins.

Level 2: Box image. "صندوق" vs "سندوق". He thinks hard... "ص" for صندوق! Correct!

He completes 5 levels, gets 12 stars total. Achievement popup: "جامع النجوم! +100 coins!" Total: 520 coins.

## Scene 5: Checking Achievements

أحمد taps the trophy icon. Sees:

* ✅ "أول خطوة" - Complete 1 level (claimed)
* ✅ "جامع النجوم" - Earn 10 stars (claimed, +100)
* ⏳ "بطل السرعة" - Complete level under 30s (2/5 levels)
* ⏳ "كامل العالم" - 3 stars all levels in one world (locked)
* ⏳ "قارئ العربية" - Complete all 5 worlds (locked)

He taps "جامع النجوم" claim button. Coins fly to his coin counter. Total: 620 coins.

## Scene 6: The Store

أحمد taps the shop icon (shopping cart). Two tabs: "صوري" (My Pics) and "ألواني" (My Themes).

**Profile Pics tab:**

* Penguin (50) - he has it (default)
* Bee (75) - locked, gray
* Cat (100) - locked, gray
* Deer (125) - locked, gray
* Whale (150) - locked, gray
* Airplane (175) - locked, gray
* Sheep (200) - locked, gray
* Painter Boy (250) - locked, gray

He taps Bee. "هل تريد شراء نحلة بـ 75 عملة؟" Yes! Purchase animation. Bee unlocked, auto-equipped. His profile icon changes to a bee. Total coins: 545.

**Themes tab:**

* Forest Green (100) - locked
* Ocean Blue (100) - locked
* Sunset Orange (150) - locked
* Starry Night (200) - locked
* Candy Pink (250) - locked
* Space Purple (300) - locked

Not enough for themes yet. He goes back to play more.

## Scene 7: Playing More for Themes

أحمد plays "عالم الحروف المتشابهة" (Similar Letters). Finds letters in circles. It's harder! He gets 1 star on first try. "حاول مرة أخرى" appears. He replays, gets 3 stars! +75 coins.

After 2 more worlds, he has 890 coins. Buys "Starry Night" theme for 200. The whole app background changes to dark blue with twinkling stars! He feels proud.

## Scene 8: Daily Return

Next day, أحمد opens app. "مرحباً بعودتك! +100 عملة يومية!" He checks new achievement "المتابع المنتظم" for 3-day login streak. Plays 10 minutes, unlocks "عالم الحذف". His favorite!

---

# 🎮 FULL GAME LOGIC PROMPT FOR ANTIGRAVITY

**plain**Copy

```plain
BUILD A COMPLETE ARABIC LITERACY GAME APP USING FLUTTER + ANTIGRAVITY DESIGN SYSTEM.

═══════════════════════════════════════════════════════════════
SECTION 1: CORE ARCHITECTURE
═══════════════════════════════════════════════════════════════

STATE MANAGEMENT: Use Riverpod (flutter_riverpod) for all game state.

PROVIDERS NEEDED:
- userProvider: UserModel (coins, stars, levels, achievements, owned items, settings)
- gameSessionProvider: Current exercise, score, timer, lives
- audioProvider: TTS and SFX state
- settingsProvider: Sound on/off, theme, language

═══════════════════════════════════════════════════════════════
SECTION 2: DATA MODELS (Complete)
═══════════════════════════════════════════════════════════════

```dart
// USER & PROGRESS
class UserModel {
  final String id;
  int coins;
  int totalStars;
  List<String> unlockedWorldIds;
  Map<String, LevelProgress> levelProgress; // worldId_levelId → progress
  List<String> unlockedAchievements;
  List<String> claimedAchievements;
  String currentProfilePic;
  String currentTheme;
  List<String> ownedProfilePics;
  List<String> ownedThemes;
  int dailyStreak;
  DateTime lastLoginDate;
  
  UserModel({
    this.id = 'guest',
    this.coins = 0,
    this.totalStars = 0,
    this.unlockedWorldIds = const ['spelling_world'],
    this.levelProgress = const {},
    this.unlockedAchievements = const [],
    this.claimedAchievements = const [],
    this.currentProfilePic = 'penguin',
    this.currentTheme = 'default',
    this.ownedProfilePics = const ['penguin'],
    this.ownedThemes = const ['default'],
    this.dailyStreak = 0,
    required this.lastLoginDate,
  });
}

class LevelProgress {
  final String worldId;
  final String levelId;
  final int starsEarned; // 0-3
  final int bestScore;
  final int bestTimeSeconds;
  final bool isCompleted;
  final List<bool> exerciseResults; // true/false per exercise
  
  LevelProgress({
    required this.worldId,
    required this.levelId,
    this.starsEarned = 0,
    this.bestScore = 0,
    this.bestTimeSeconds = 999,
    this.isCompleted = false,
    this.exerciseResults = const [],
  });
}

// EXERCISE SYSTEM
enum ExerciseType {
  imageChoice,      // عالم القلب - tap correct word
  letterFind,       // عالم الحروف المتشابهة - find letters in grid
  sentenceAddition, // عالم الإضافة - complete sentence
  missingLetter,    // عالم الحذف - fill missing letter
  firstLetter,      // عالم الإدباء - write first letter
  soundDrag,        // Drag syllables to form word
}

class Exercise {
  final String id;
  final ExerciseType type;
  final String question;
  final String? imageAsset;
  final List<String> options;
  final String correctAnswer;
  final String? hint;
  final String? correctFeedback; // "أحسنت!"
  final String? wrongFeedback;   // "حاول مرة أخرى"
  final int coinReward;
  final int timeLimitSeconds; // 0 = no limit
  
  Exercise({
    required this.id,
    required this.type,
    required this.question,
    this.imageAsset,
    required this.options,
    required this.correctAnswer,
    this.hint,
    this.correctFeedback,
    this.wrongFeedback,
    this.coinReward = 10,
    this.timeLimitSeconds = 0,
  });
}

class Level {
  final String id;
  final String worldId;
  final String title;
  final List<Exercise> exercises;
  final int unlockRequirementStars; // stars needed to unlock
  final String? unlockMessage;
  
  Level({
    required this.id,
    required this.worldId,
    required this.title,
    required this.exercises,
    this.unlockRequirementStars = 0,
    this.unlockMessage,
  });
}

class World {
  final String id;
  final String title;
  final String subtitle;
  final String iconAsset;
  final Color themeColor;
  final List<Level> levels;
  final int unlockRequirementTotalStars;
  
  World({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    required this.themeColor,
    required this.levels,
    this.unlockRequirementTotalStars = 0,
  });
}

// STORE SYSTEM
enum StoreItemType { profilePic, theme }

class StoreItem {
  final String id;
  final String name;
  final StoreItemType type;
  final int price;
  final String assetPath;
  final String previewAsset;
  final String? description;
  
  StoreItem({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.assetPath,
    required this.previewAsset,
    this.description,
  });
}

// ACHIEVEMENTS
class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconAsset;
  final int coinReward;
  final bool Function(UserModel user) checkUnlocked;
  final bool isOneTime;
  
  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.coinReward,
    required this.checkUnlocked,
    this.isOneTime = true,
  });
}
```

═══════════════════════════════════════════════════════════════
SECTION 3: COMPLETE EXERCISE DATABASE
═══════════════════════════════════════════════════════════════

WORLD 1: "عالم الإدباء" (Spelling World) - UNLOCKED BY DEFAULT
Theme color: Colors.blue
Icon: pencil

Level 1: "وسائل النقل" (Transportation)

1. Exercise(imageChoice, "طائرة", "assets/images/airplane.png", ["ح", "خ"], "ح")
2. Exercise(imageChoice, "سيارة", "assets/images/car.png", ["د", "ذ"], "د")
3. Exercise(imageChoice, "حافلة", "assets/images/bus.png", ["ط", "ت"], "ط")
4. Exercise(imageChoice, "دراجة", "assets/images/bicycle.png", ["س", "ص"], "س")

Level 2: "الفواكه" (Fruits)

1. Exercise(imageChoice, "كرز", "assets/images/cherries.png", ["س", "ص"], "س")
2. Exercise(imageChoice, "موز", "assets/images/bananas.png", ["م", "ن"], "م")
3. Exercise(imageChoice, "عنب", "assets/images/grapes.png", ["ع", "غ"], "ع")
4. Exercise(imageChoice, "تفاحة", "assets/images/apple.png", ["ت", "ث"], "ت")

Level 3: "الحيوانات" (Animals)

1. Exercise(imageChoice, "حصان", "assets/images/horse.png", ["ح", "خ"], "ح")
2. Exercise(imageChoice, "خطبوط", "assets/images/octopus.png", ["خ", "ح"], "خ")
3. Exercise(imageChoice, "ثعلب", "assets/images/fox.png", ["ث", "س"], "ث")
4. Exercise(imageChoice, "زرافة", "assets/images/giraffe.png", ["أ", "إ"], "أ")

Level 4: "الطبيعة" (Nature)

1. Exercise(imageChoice, "شجرة", "assets/images/tree.png", ["ع", "غ"], "ع")
2. Exercise(imageChoice, "زهرة", "assets/images/flower.png", ["ش", "س"], "ش")
3. Exercise(imageChoice, "عشب", "assets/images/grass.png", ["خ", "ح"], "خ")
4. Exercise(imageChoice, "جذع", "assets/images/log.png", ["ز", "ذ"], "ز")

Level 5: "الخضر" (Vegetables)

1. Exercise(imageChoice, "جزر", "assets/images/carrot.png", ["ب", "ت"], "ب")
2. Exercise(imageChoice, "بطاطا", "assets/images/potatoes.png", ["ج", "ح"], "ج")
3. Exercise(imageChoice, "طماطم", "assets/images/tomato.png", ["ب", "ت"], "ب")
4. Exercise(imageChoice, "بصل", "assets/images/onion.png", ["ط", "ت"], "ط")

Level 6: "أسماء من حولنا" (Around Us)

1. Exercise(imageChoice, "خيمة", "assets/images/tent.png", ["ط", "ت"], "ط")
2. Exercise(imageChoice, "كبل", "assets/images/drum.png", ["ك", "ق"], "ك")
3. Exercise(imageChoice, "كرة", "assets/images/ball.png", ["ض", "ص"], "ض")
4. Exercise(imageChoice, "ضوء", "assets/images/lightbulb.png", ["خ", "ح"], "خ")

WORLD 2: "عالم القلب" (Heart World) - UNLOCK AFTER 3 STARS IN WORLD 1
Theme color: Colors.red
Icon: heart

Level 1:

1. Exercise(imageChoice, "بطريق", "assets/images/penguin.png", ["بطريق", "بثريق"], "بطريق")
2. Exercise(imageChoice, "صندوق", "assets/images/box.png", ["صندوق", "سندوق"], "صندوق")

Level 2:
3. Exercise(imageChoice, "غزال", "assets/images/deer.png", ["غزال", "خزال"], "غزال")
4. Exercise(imageChoice, "مقص", "assets/images/scissors.png", ["مقص", "مكس"], "مقص")

Level 3:
5. Exercise(imageChoice, "قطار", "assets/images/train.png", ["قطار", "كطار"], "قطار")
6. Exercise(imageChoice, "حوت", "assets/images/whale.png", ["حوت", "هوت"], "حوت")

Level 4:
7. Exercise(imageChoice, "طائرة", "assets/images/airplane2.png", ["طائرة", "تائرة"], "طائرة")
8. Exercise(imageChoice, "خروف", "assets/images/sheep.png", ["خروف", "غروف"], "خروف")

Level 5:
9. Exercise(imageChoice, "قميص", "assets/images/shirt.png", ["قميص", "قميس"], "قميص")
10. Exercise(imageChoice, "كلب", "assets/images/dog.png", ["كلب", "قلب"], "كلب")

Level 6:
11. Exercise(imageChoice, "عسل", "assets/images/honey.png", ["عسل", "عصل"], "عسل")
12. Exercise(imageChoice, "قطة", "assets/images/cat.png", ["قطة", "قتة"], "قطة")

Level 7:
13. Exercise(imageChoice, "حليب", "assets/images/milk.png", ["حليب", "هليب"], "حليب")
14. Exercise(imageChoice, "رسام", "assets/images/painter.png", ["رسام", "رصام"], "رسام")

WORLD 3: "عالم الحروف المتشابهة" (Similar Letters) - UNLOCK AFTER 8 STARS TOTAL
Theme color: Colors.orange
Icon: magnifying_glass

Level 1 (Find letters of "كلب"):
Grid: [ق, ك, م, ن, ف, ه, ب, ث, ل]
Target letters: ك, ل, ب

Level 2 (Find letters of "قلم"):
Grid: [ق, ك, م, ن, ف, ه, ب, ث, ل]
Target letters: ق, ل, م

Level 3 (ش/س/ث group):
Grid: [خ, ث, ش, م, ذ, خ, ذ, س, ث]
Target: words containing these letters

Level 4 (ر/ز/ذ group):
Grid: [د, و, ر, ر, ي, ف, و, ف, ك]
Target: ر

Level 5 (ج/ح/خ group):
Grid: [ج, ن, ح, ب, ظ, م, ظ, ب, ر]
Target: ج

Level 6 (ش/ض/أ group):
Grid: [ش, ض, أ, ض, ن, ي, ف, ش, ب]
Target: ش

Level 7 (Sound matching - connect letter to words):
Letter: ع
Words: [عام, غاب, جاع, خال, ظام, فاز]
Correct: عام, جاع

WORLD 4: "عالم الحذف" (Deletion World) - UNLOCK AFTER 15 STARS TOTAL
Theme color: Colors.purple
Icon: eraser

Level 1: "أحمر" - missing "أ" - choices: [س, د, ث, ص, و, ج, ء, ن, خ, أ]
Level 2: "حقيبة" - missing "ة" - choices: [ي, ط, م, ع, س, ث, ن, ة, ز, أ]
Level 3: "جائع" - missing "ء" - choices: [ذ, س, ت, م, ش, و, ع, ن, ظ, ا]
Level 4: "نحلة" - missing "ح" - choices: [س, ر, ح, و, ء, ن, ظ, ش, ذ, ق]
Level 5: "عين" - missing "ي" - choices: [ص, ك, ر, ط, ث, س, ع, م, ي, ز]
Level 6: "قمر" - missing "م" - choices: [ب, ج, ز, س, ل, ط, ذ, غ, و, م]
Level 7: "مطر" - missing "ط" - choices: [ح, ت, د, ض, أ, ط, و, ث, ة, ف]
Level 8: "خبز" - missing "ب" - choices: [ر, غ, ط, ح, ق, ف, ع, و, ء, خ]
Level 9: "خس" - missing "خ" - choices: [س, و, غ, ك, ح, ي, خ, ن, ض, ب]
Level 10: "سرير" - missing "ر" - choices: [ح, ر, و, ج, ة, ق, ط, ص, ي, ب]

WORLD 5: "عالم الإضافة" (Addition World) - UNLOCK AFTER 25 STARS TOTAL
Theme color: Colors.green
Icon: plus_sign

Level 1: "ذهب وليد إلى المدرسة" → add "صباحاً"
Level 2: "النجوم تظهر في السماء" → add "الزرقاء"
Level 3: "قفز الكنغر" → add "قفزةً عاليةً"
Level 4: "الحاسوب أسرع وأقوى جهاز" → add "في العالم"
Level 5: "جلسنا في ليالي الصحراء" → add "الباردة"
Level 6: "يوجد في البحر سمك" → add "خطيرة"
Level 7: "قضينا في الصيف عطلة" → add "ممتعة"
Level 8: "ذهبت العائلة في رحلة" → add "طويلة"
Level 9: "عادت مريم من المدرسة" → add "سعيدةً"
Level 10: "ركل عمر الكرة" → add "بعيداً"

═══════════════════════════════════════════════════════════════
SECTION 4: GAME FLOW & SCREENS
═══════════════════════════════════════════════════════════════

SCREEN 1: SPLASH SCREEN

* Animated heart logo bounce
* "عالم القلب" text fade in
* Auto-navigate to main menu after 2 seconds

SCREEN 2: MAIN MENU

* Background: current theme
* Top bar: profile pic (tap to change), coin count, settings gear
* Center: 5 world icons in arc/map layout
* Locked worlds: grayscale with lock icon, tap shows requirement
* Unlocked worlds: colored, pulse animation, tap enters
* Bottom nav: Play | Achievements | Store | Settings

SCREEN 3: WORLD SCREEN

* World title with theme color header
* Grid of levels (3x3 or 2x5)
* Each level shows: number, star rating (0-3), lock state
* Locked levels: gray, requirement text
* Completed levels: colored, stars filled
* Tap level → starts exercise sequence

SCREEN 4: EXERCISE SCREEN (Dynamic based on type)
Shared elements:

* Top: progress bar (dots), coin count, pause button
* Center: exercise content
* Bottom: hint button (costs 5 coins)

TYPE-SPECIFIC LAYOUTS:

ImageChoice (عالم القلب + عالم الإدباء):

* Image: 35% screen height, centered
* Two large buttons below: 45% width each, 80px height
* Arabic text, large font (32sp)
* Correct: green background, scale up 1.1, checkmark icon
* Wrong: red background, shake animation, X icon

LetterFind (عالم الحروف المتشابهة):

* Left: thinking boy image with thought bubble (target word)
* Right: 3x3 circle grid
* Circles: 80px diameter, white fill, black border
* Tap: green fill + check (correct), red fill + X (wrong)
* All correct found → level complete

MissingLetter (عالم الحذف):

* Top: image
* Middle: incomplete word with large dots "ح...ر"
* Bottom: 2 rows of 5 letter tiles
* Tiles: 60x60, white, rounded corners
* Tap correct: letter flies to gap, green glow
* Tap wrong: tile shakes, brief red

SentenceAddition (عالم الإضافة):

* Top: two clouds side by side
  * Left (white): base sentence
  * Right (blue): completed sentence
* Middle: "ما الكلمة المضافة؟"
* Bottom: 3 word buttons
* Correct: highlight added word in both sentences, green pulse

SCREEN 5: LEVEL COMPLETE

* Star animation (1-3 stars based on performance)
* Score breakdown: correct answers, time bonus, perfect bonus
* Coins earned: fly animation to coin counter
* Buttons: Replay | Next Level | Main Menu

SCREEN 6: ACHIEVEMENTS SCREEN

* Grid of achievement cards
* Locked: gray, requirement text
* Unlocked unclaimed: gold border, glow, "Claim" button
* Claimed: green check, dimmed
* Tap claim: coin fly animation, card flips to claimed state

SCREEN 7: STORE SCREEN

* Top: coin count, back button
* Tabs: "صور الملف الشخصي" | "السمات"
* Grid 2x3 of items
* Each item: preview image, name, price (or "تم الشراء"/"مُجهَّز")
* Tap item: detail modal with larger preview, description, buy/equip button
* Insufficient coins: "تحتاج المزيد!" with "العب المزيد" button

═══════════════════════════════════════════════════════════════
SECTION 5: SCORING & ECONOMY
═══════════════════════════════════════════════════════════════

COIN EARNINGS:

* Correct answer: +10
* Level complete: +50 base
* 3 stars on level: +25 bonus
* Perfect level (all correct first try): +50 bonus
* Achievement claim: varies (25-500)
* Daily login: +100, streak bonus +10 per day

STAR CALCULATION:

* 3 stars: 90%+ correct, under time limit
* 2 stars: 70-89% correct, or slow time
* 1 star: 50-69% correct
* 0 stars: <50% correct (must retry to advance)

UNLOCK REQUIREMENTS:

* World 2 (Heart): 3 stars in World 1
* World 3 (Similar): 8 total stars
* World 4 (Deletion): 15 total stars
* World 5 (Addition): 25 total stars
* Level N+1: Complete level N (any stars)

═══════════════════════════════════════════════════════════════
SECTION 6: AUDIO SYSTEM
═══════════════════════════════════════════════════════════════

Use flutter_tts package for Arabic TTS.

VOICE LINES:
Correct feedback (random):

* "أحسنت!"
* "رائع!"
* "ممتاز!"
* "أنت حقاً ذكي!"
* "أنت مدهش!"

Wrong feedback:

* "حاول مرة أخرى"

World entry:

* "عالم القلب!" / "عالم الحروف المتشابهة!" etc.

Achievement:

* "إنجاز جديد!"

Store:

* "تم الشراء بنجاح!"

SFX (use audioplayers package):

* Correct: bright chime
* Wrong: dull thud
* Star: sparkle sound
* Coin: coin clink
* Unlock: fanfare
* Button tap: soft click

═══════════════════════════════════════════════════════════════
SECTION 7: THEME SYSTEM
═══════════════════════════════════════════════════════════════

THEMES:

1. Default: White background, blue accents
2. Forest Green: #2E7D32 background, light green cards
3. Ocean Blue: #0277BD background, cyan cards
4. Sunset Orange: #E65100 background, amber cards
5. Starry Night: #1A237E background, gold stars animation, white cards
6. Candy Pink: #C2185B background, pink cards
7. Space Purple: #4A148C background, purple nebula, white cards

Apply theme via ThemeData with custom ColorScheme.

═══════════════════════════════════════════════════════════════
SECTION 8: ASSET REQUIREMENTS
═══════════════════════════════════════════════════════════════

IMAGES NEEDED (search/download these):
From the PDFs, extract or find similar images for:

Transportation: airplane, car, bus, bicycle
Fruits: cherries, bananas, grapes, apple
Animals: horse, octopus, fox, giraffe, penguin, deer, whale, sheep, dog, cat, bee
Nature: tree, flower, grass, log
Vegetables: carrot, potatoes, tomato, onion, lettuce
Objects: box, scissors, train, shirt, honey jar, milk carton, painter boy, tent, drum, ball, lightbulb, bed, school bag, moon, bread, red block
UI: stars (empty/filled), coins, lock, trophy, shop cart, settings gear, heart logo

NAMING CONVENTION:
assets/images/exercises/{category}_{name}.png
assets/images/ui/{name}.png
assets/images/store/{name}.png

═══════════════════════════════════════════════════════════════
SECTION 9: PERSISTENCE
═══════════════════════════════════════════════════════════════

Use shared_preferences for:

* UserModel JSON
* Settings
* Last login date (for daily rewards)

Use hive or sqflite for:

* Exercise history
* Detailed analytics (optional)

═══════════════════════════════════════════════════════════════
SECTION 10: IMPLEMENTATION ORDER
═══════════════════════════════════════════════════════════════

PHASE 1: Core

1. Data models
2. Riverpod providers
3. Local storage (shared_preferences)

PHASE 2: UI Foundation
4. Theme system
5. Main menu screen
6. World map screen

PHASE 3: Exercise Types
7. ImageChoice widget
8. FirstLetter widget (same as ImageChoice with single letters)
9. Level complete screen

PHASE 4: Advanced Exercises
10. LetterFind widget
11. MissingLetter widget
12. SentenceAddition widget

PHASE 5: Progression
13. Star/coin calculation
14. Lock/unlock logic
15. Level progression tracking

PHASE 6: Polish
16. Audio system (TTS + SFX)
17. Animations (flame or custom)
18. Achievement system

PHASE 7: Store
19. Store UI
20. Purchase logic
21. Profile pic/theme equipping

PHASE 8: Extras
22. Daily rewards
23. Settings (sound, language)
24. Parent dashboard (progress stats)

**plain**Copy

```plain

---

# 🔧 RECOMMENDED FLUTTER PACKAGES TO USE

| Package | Purpose | Command |
|---------|---------|---------|
| `flutter_riverpod` | State management | `flutter pub add flutter_riverpod` |
| `flutter_tts` | Arabic text-to-speech | `flutter pub add flutter_tts` |
| `audioplayers` | Sound effects | `flutter pub add audioplayers` |
| `shared_preferences` | Local storage | `flutter pub add shared_preferences` |
| `flutter_svg` | SVG icons | `flutter pub add flutter_svg` |
| `confetti` | Celebration effects | `flutter pub add confetti` |
| `shake` | Shake animation | `flutter pub add shake` |
| `google_fonts` | Arabic fonts (Cairo, Tajawal) | `flutter pub add google_fonts` |

---

# 🖼️ IMAGE SEARCH GUIDE

For each exercise image, search:
- **Style**: Cartoon, flat design, child-friendly
- **Background**: Transparent or white
- **Format**: PNG preferred
- **Size**: 512x512 minimum

Search terms (Arabic/English):
- "cartoon penguin transparent png"
- "kids Arabic alphabet game illustration"
- "cute deer cartoon png"
- "school supplies cartoon vector"

Recommended sources: Flaticon, Freepik, PNGTree, or generate with AI tools.

---

Feed this entire prompt to Antigravity in chunks if needed, or ask me to expand any specific section!
```
