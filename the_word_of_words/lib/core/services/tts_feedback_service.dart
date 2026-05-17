import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

/// Service to handle pedagogical audio feedback using recorded assets.
class TtsFeedbackService {
  static final TtsFeedbackService _instance = TtsFeedbackService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Mapping of UI phrases to asset filenames
  final Map<String, String> _phraseToAsset = {
    'أحسنت': 'audio/احسنت.mp3',
    'أنت حقا ذكي': 'audio/انت حقا ذكي.mp3',
    'أنت رائع': 'audio/انت رائع.mp3',
    'أنت مدهش': 'audio/انت مدهش.mp3',
    'ممتاز': 'audio/ممتاز.mp3',
  };

  factory TtsFeedbackService() {
    return _instance;
  }

  TtsFeedbackService._internal();

  /// Initializes the service
  Future<void> init() async {
    // Initialization logic if needed
  }

  /// Plays the audio corresponding to a random phrase and returns the phrase
  Future<String> onCorrect() async {
    final phrase = getRandomEncouragement();
    await _playPhrase(phrase);
    return phrase;
  }

  /// Returns a random encouragement string
  String getRandomEncouragement() {
    final phrases = _phraseToAsset.keys.toList();
    return phrases[Random().nextInt(phrases.length)];
  }

  /// Plays the failure audio
  Future<void> onWrong() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/حاول مرة اخرى.mp3'));
    } catch (e) {
      print('Error playing wrong sound: $e');
    }
  }

  /// Plays a specific phrase audio
  Future<void> speak(String text) async {
    await _playPhrase(text);
  }

  Future<void> _playPhrase(String phrase) async {
    try {
      final assetPath = _phraseToAsset[phrase];
      if (assetPath != null) {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(assetPath));
      }
    } catch (e) {
      print('Error playing audio for phrase "$phrase": $e');
    }
  }

  /// Plays a simple click sound if needed
  Future<void> playClick() async {
    // Optional: play a click if assets/audio/click.mp3 exists
  }

  /// Legacy method for word TTS (currently disabled as we use pre-recorded phrases)
  Future<void> speakWord(String word) async {
    // Logic for individual word speech can be added here if needed
  }
}
