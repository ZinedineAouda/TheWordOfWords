import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/game_models.dart';
import '../services/tts_feedback_service.dart';

class GameProvider extends ChangeNotifier {
  int _stars = 120; // Default starting value
  int _coins = 500;
  List<World> _worlds = [];
  
  // Store state
  List<String> _unlockedAvatars = ['none'];
  List<String> _unlockedThemes = ['Default Blue'];
  List<String> _unlockedClickEffects = ['default'];
  String _currentAvatar = 'none';
  String _currentTheme = 'Default Blue';
  String _currentClickEffect = 'default';
  List<String> _unlockedAchievements = [];

  World? _currentWorld;
  Level? _currentLevel;
  int _currentExerciseIndex = 0;
  bool _isLoading = true;
  String? _error;
  String? _userName;
  String? _userProfileImagePath;
  bool _isFirstTime = true;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userName => _userName;
  String? get userProfileAvatarId => _userProfileImagePath;
  bool get isFirstTime => _isFirstTime;

  static const Map<String, String> avatarPaths = {
    'hero_explorer': 'assets/images/hero_explorer_boy.png',
    'hero_supergirl': 'assets/images/hero_super_girl.png',
    'hero_knight': 'assets/images/hero_knight.png',
    'hero_doctor': 'assets/images/hero_doctor.png',
    'hero_fireman': 'assets/images/hero_fireman.png',
    'hero_astronaut': 'assets/images/hero_astronaut.png',
  };

  String get userProfileImagePath {
    // If a hero is equipped from the store, use it
    if (_currentAvatar != 'none' && avatarPaths.containsKey(_currentAvatar)) {
      return avatarPaths[_currentAvatar]!;
    }
    // Otherwise use the custom profile image if it exists
    if (_userProfileImagePath != null && _userProfileImagePath!.isNotEmpty) {
      return _userProfileImagePath!;
    }
    // Final fallback
    return 'assets/images/app_logo.jpg';
  }

  bool get hasCustomProfileImage {
    // If a hero is equipped, it's technically an asset
    if (_currentAvatar != 'none' && avatarPaths.containsKey(_currentAvatar)) {
      return false;
    }
    return _userProfileImagePath != null && _userProfileImagePath!.isNotEmpty && !_userProfileImagePath!.startsWith('assets/');
  }


  int get stars => _stars;
  int get coins => _coins;
  List<World> get worlds => _worlds;
  List<String> get unlockedAvatars => _unlockedAvatars;
  List<String> get unlockedThemes => _unlockedThemes;
  List<String> get unlockedClickEffects => _unlockedClickEffects;
  String get currentAvatar => _currentAvatar;
  String get currentTheme => _currentTheme;
  String get currentClickEffect => _currentClickEffect;
  List<String> get unlockedAchievements => _unlockedAchievements;
  
  Exercise? get currentExercise {
    if (_currentWorld == null || _currentLevel == null) return null;
    if (_currentExerciseIndex < _currentLevel!.exercises.length) {
      return _currentLevel!.exercises[_currentExerciseIndex];
    }
    return null;
  }

  Map<String, dynamic> _savedLevelProgress = {};

  GameProvider() {
    init();
  }

  Future<void> init() async {
    if (_isLoading && _worlds.isNotEmpty) return; // Prevent multiple simultaneous inits if already loaded
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    // Safety timer to force stop loading if something hangs indefinitely
    Future.delayed(const Duration(seconds: 15), () {
      if (_isLoading) {
        debugPrint('GameProvider: Safety timer triggered. Forcing isLoading = false');
        _isLoading = false;
        notifyListeners();
      }
    });
    
    try {
      debugPrint('GameProvider: Starting initialization...');
      
      // Load progress with timeout
      await _loadProgress().timeout(
        const Duration(seconds: 5),
        onTimeout: () => debugPrint('GameProvider: Progress loading timed out'),
      );
      debugPrint('GameProvider: Progress loaded.');
      
      // Load game data with timeout
      await _loadGameData().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('فشل تحميل بيانات اللعبة (انتهاء الوقت)');
        },
      );
      // Initialize TTS
      await TtsFeedbackService().init().timeout(
        const Duration(seconds: 5),
        onTimeout: () => debugPrint('GameProvider: TTS initialization timed out'),
      );
      debugPrint('GameProvider: TTS initialized.');
      
      debugPrint('GameProvider: Game data loaded.');
      
      await _checkDailyLogin().timeout(
        const Duration(seconds: 5),
        onTimeout: () => debugPrint('GameProvider: Daily login check timed out'),
      );
      
      debugPrint('GameProvider: Initialization complete.');
    } catch (e, stack) {
      _error = e.toString();
      debugPrint('GameProvider: Initialization failed: $e');
      debugPrint('Stack trace: $stack');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void forceStopLoading() {
    _isLoading = false;
    notifyListeners();
  }


  Future<void> _loadGameData() async {
    try {
      debugPrint('GameProvider: Loading game_data.json...');
      final String response = await rootBundle.loadString('assets/data/game_data.json');
      debugPrint('GameProvider: JSON string loaded (length: ${response.length})');
      final data = await json.decode(response);
      
      final worldsList = data['worlds'] as List;
      List<World> parsedWorlds = [];
      
      for (int i = 0; i < worldsList.length; i++) {
        try {
          parsedWorlds.add(World.fromJson(worldsList[i]));
        } catch (e) {
          debugPrint('GameProvider: Failed to parse world at index $i: $e');
          debugPrint('World data: ${worldsList[i]}');
          rethrow;
        }
      }
      
      _worlds = parsedWorlds;
      debugPrint('GameProvider: Successfully parsed ${_worlds.length} worlds');
      
      // Default initial state: first world and its first level are unlocked
      if (_worlds.isNotEmpty) {
        _worlds[0].isLocked = false;
        if (_worlds[0].levels.isNotEmpty) {
          _worlds[0].levels[0].isLocked = false;
        }
      }

      _applyProgressToWorlds();
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error loading game data: $e');
      debugPrint('Stack trace: $stack');
      _error = "خطأ في تحميل البيانات: $e";
      rethrow;
    }
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _stars = prefs.getInt('stars') ?? 120;
    _coins = prefs.getInt('coins') ?? 500;
    _unlockedAvatars = prefs.getStringList('unlocked_avatars') ?? ['none'];
    _unlockedThemes = prefs.getStringList('unlocked_themes') ?? ['Default Blue'];
    _unlockedClickEffects = prefs.getStringList('unlocked_click_effects') ?? ['default'];
    _currentAvatar = prefs.getString('current_avatar') ?? 'none';
    _currentTheme = prefs.getString('current_theme') ?? 'Default Blue';
    _currentClickEffect = prefs.getString('current_click_effect') ?? 'default';
    _unlockedAchievements = prefs.getStringList('unlocked_achievements') ?? [];
    

    final levelProgressStr = prefs.getString('level_progress');
    if (levelProgressStr != null) {
      _savedLevelProgress = json.decode(levelProgressStr);
    }

    _userName = prefs.getString('user_name');
    if (_userName == null) {
      _userName = 'بطل';
      prefs.setString('user_name', 'بطل');
    }
    
    _userProfileImagePath = prefs.getString('user_profile_image_path');
    if (_userProfileImagePath == null) {
      _userProfileImagePath = 'assets/images/hero_explorer.png';
      prefs.setString('user_profile_image_path', 'assets/images/hero_explorer.png');
    }
    
    _isFirstTime = prefs.getBool('is_first_time') ?? false;
    if (prefs.getBool('is_first_time') == null) {
      prefs.setBool('is_first_time', false);
    }
    
    if (_worlds.isNotEmpty) {
      _applyProgressToWorlds();
    }
    
    notifyListeners();
  }

  void _applyProgressToWorlds() {
    if (_worlds.isEmpty) return;

    for (var world in _worlds) {
      // Restore world locked status from progress or default to false for now
      // (User might want all worlds visible but levels locked)
      world.isLocked = false;
      
      for (int i = 0; i < world.levels.length; i++) {
        var level = world.levels[i];
        
        // Restore stars
        if (_savedLevelProgress.containsKey(level.id)) {
          level.starsEarned = _savedLevelProgress[level.id]['stars'] ?? 0;
          level.isLocked = _savedLevelProgress[level.id]['locked'] ?? (i > 0);
        } else {
          // Default: Only first level is unlocked
          level.isLocked = i > 0;
        }
      }
    }
  }

  Future<void> addStars(int amount) async {
    _stars += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stars', _stars);
    // Note: World unlocking based on stars is removed as requested
    notifyListeners();
  }

  Future<void> addCoins(int amount) async {
    _coins += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', _coins);
    notifyListeners();
  }



  Future<bool> spendCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('coins', _coins);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> unlockAvatar(String avatarId) async {
    if (!_unlockedAvatars.contains(avatarId)) {
      _unlockedAvatars.add(avatarId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('unlocked_avatars', _unlockedAvatars);
      notifyListeners();
    }
  }

  Future<void> setAvatar(String avatarId) async {
    _currentAvatar = avatarId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_avatar', avatarId);
    notifyListeners();
  }

  Future<void> unlockTheme(String themeId) async {
    if (!_unlockedThemes.contains(themeId)) {
      _unlockedThemes.add(themeId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('unlocked_themes', _unlockedThemes);
      notifyListeners();
    }
  }

  Future<void> setTheme(String themeId) async {
    _currentTheme = themeId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_theme', themeId);
    notifyListeners();
  }

  Future<void> unlockClickEffect(String effectId) async {
    if (!_unlockedClickEffects.contains(effectId)) {
      _unlockedClickEffects.add(effectId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('unlocked_click_effects', _unlockedClickEffects);
      notifyListeners();
    }
  }

  Future<void> setClickEffect(String effectId) async {
    _currentClickEffect = effectId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_click_effect', effectId);
    notifyListeners();
  }

  Future<void> updateUserProfile(String name, String? imagePath) async {
    _userName = name;
    _userProfileImagePath = imagePath;
    _isFirstTime = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    if (imagePath != null) {
      await prefs.setString('user_profile_image_path', imagePath);
    }
    await prefs.setBool('is_first_time', false);
    
    notifyListeners();
  }
  World? get currentWorld => _currentWorld;
  Level? get currentLevel => _currentLevel;

  void selectWorld(String worldId) {
    _currentWorld = _worlds.firstWhere((w) => w.id == worldId);
    _currentLevel = _currentWorld!.levels.lastWhere((l) => !l.isLocked, orElse: () => _currentWorld!.levels.first);
    _currentExerciseIndex = 0;
    notifyListeners();
  }

  void selectLevel(String levelId) {
    if (_currentWorld == null) return;
    _currentLevel = _currentWorld!.levels.firstWhere((l) => l.id == levelId);
    _currentExerciseIndex = 0;
    notifyListeners();
  }

  Future<void> unlockAchievement(String achievementId, int reward) async {
    if (!_unlockedAchievements.contains(achievementId)) {
      _unlockedAchievements.add(achievementId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('unlocked_achievements', _unlockedAchievements);
      await addCoins(reward);
      notifyListeners();
    }
  }

  void checkAchievements() {
    if (_worlds.any((w) => w.levels.any((l) => l.starsEarned > 0))) {
      unlockAchievement('first_steps', 25);
    }
    if (_stars >= 10) {
      unlockAchievement('star_collector', 100);
    }
  }

  Future<void> completeLevel(String levelId, int starsEarned) async {
    if (_currentWorld == null) return;
    
    final level = _currentWorld!.levels.firstWhere((l) => l.id == levelId);

    if (starsEarned > level.starsEarned) {
      int starDiff = starsEarned - level.starsEarned;
      level.starsEarned = starsEarned;
      await addStars(starDiff);
    }

    int currentIndex = _currentWorld!.levels.indexOf(level);
    for (var world in _worlds) {
      if (currentIndex + 1 < world.levels.length) {
        world.levels[currentIndex + 1].isLocked = false;
      }
    }

    await _saveProgress();
    checkAchievements();
    notifyListeners();
  }


  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stars', _stars);
    await prefs.setInt('coins', _coins);
    await prefs.setStringList('unlocked_avatars', _unlockedAvatars);
    await prefs.setStringList('unlocked_themes', _unlockedThemes);
    await prefs.setStringList('unlocked_click_effects', _unlockedClickEffects);
    await prefs.setString('current_avatar', _currentAvatar);
    await prefs.setString('current_theme', _currentTheme);
    await prefs.setString('current_click_effect', _currentClickEffect);
    await prefs.setStringList('unlocked_achievements', _unlockedAchievements);
    
    // Save level progress
    Map<String, dynamic> progress = {};
    for (var world in _worlds) {
      for (var level in world.levels) {
        progress[level.id] = {
          'stars': level.starsEarned,
          'locked': level.isLocked,
        };
      }
    }
    await prefs.setString('level_progress', json.encode(progress));
  }

  Future<void> _checkDailyLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoginStr = prefs.getString('last_login');
    final now = DateTime.now();
    final today = "${now.year}-${now.month}-${now.day}";

    if (lastLoginStr != today) {
      await addCoins(50); // Daily reward
      await prefs.setString('last_login', today);
    }
  }
}
