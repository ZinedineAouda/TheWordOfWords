import 'package:flutter/material.dart';

enum ItemCategory { avatar, theme, clickEffect }

class ExerciseResult {
  final bool isCorrect;
  final int timeTaken; // in seconds
  final int stars;
  final String? successPhrase;

  ExerciseResult({
    required this.isCorrect,
    required this.timeTaken,
    required this.stars,
    this.successPhrase,
  });
}

class Exercise {
  final String id;
  final String type;
  final String question;
  final String? imageAsset;
  final List<String> options;
  final String correctAnswer;
  final List<String> correctAnswers;
  final String hint;
  final int coinsReward;
  final String? interactionType; // 'click' or 'drag'

  Exercise({
    required this.id,
    required this.type,
    required this.question,
    this.imageAsset,
    required this.options,
    required this.correctAnswer,
    this.correctAnswers = const [],
    this.hint = '',
    this.coinsReward = 10,
    this.interactionType,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      type: json['type'],
      question: json['question'],
      imageAsset: json['imageAsset'],
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
      correctAnswers: json['correctAnswers'] != null 
          ? List<String>.from(json['correctAnswers']) 
          : (json['correctAnswer'] != null ? [json['correctAnswer']] : []),
      hint: json['hint'] ?? '',
      coinsReward: json['coinsReward'] ?? 10,
      interactionType: json['interactionType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'question': question,
      'imageAsset': imageAsset,
      'options': options,
      'correctAnswer': correctAnswer,
      if (correctAnswers.isNotEmpty) 'correctAnswers': correctAnswers,
      'hint': hint,
      'coinsReward': coinsReward,
      'interactionType': interactionType,
    };
  }
}

class Level {
  final String id;
  final String title;
  final List<Exercise> exercises;
  bool isLocked;
  int starsEarned;

  final String? layout;

  Level({
    required this.id,
    required this.title,
    required this.exercises,
    this.isLocked = true,
    this.starsEarned = 0,
    this.layout,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      exercises: (json['exercises'] as List?)
              ?.map((e) => Exercise.fromJson(e))
              .toList() ??
          [],
      isLocked: json['isLocked'] ?? true,
      starsEarned: json['starsEarned'] ?? 0,
      layout: json['layout'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'isLocked': isLocked,
      'starsEarned': starsEarned,
      'layout': layout,
    };
  }
}

class World {
  final String id;
  final String title;
  final List<Level> levels;
  final Color themeColor;
  final String iconAsset;
  bool isLocked;

  World({
    required this.id,
    required this.title,
    required this.levels,
    required this.themeColor,
    required this.iconAsset,
    this.isLocked = true,
  });

  factory World.fromJson(Map<String, dynamic> json) {
    return World(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      levels: (json['levels'] as List?)
              ?.map((l) => Level.fromJson(l))
              .toList() ??
          [],
      themeColor: _parseColor(json['themeColor']),
      iconAsset: json['iconAsset'] ?? '',
      isLocked: json['isLocked'] ?? true,
    );
  }

  static Color _parseColor(dynamic colorStr) {
    if (colorStr == null) return const Color(0xFF2196F3);
    String hex = colorStr.toString().replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return const Color(0xFF2196F3);
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'levels': levels.map((l) => l.toJson()).toList(),
      'themeColor': '#${themeColor.value.toRadixString(16).substring(2)}',
      'iconAsset': iconAsset,
      'isLocked': isLocked,
    };
  }
}
