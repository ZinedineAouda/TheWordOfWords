import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/providers/game_provider.dart';
import '../core/theme/app_colors.dart';
import '../core/models/game_models.dart';
import '../shared/widgets/game_background.dart';
import '../shared/widgets/premium_ui_widgets.dart';
import '../shared/widgets/image_choice_exercise.dart';
import '../shared/widgets/letter_find_exercise.dart';
import '../shared/widgets/missing_letter_exercise.dart';
import '../shared/widgets/sentence_addition_exercise.dart';
import '../shared/widgets/extra_letter_exercise.dart';
import '../shared/widgets/spelling_exercise.dart';
import '../shared/widgets/list_completion_exercise.dart';
import '../shared/widgets/syllable_cloud_exercise.dart';
import '../shared/widgets/word_assembly_exercise.dart';
import '../shared/widgets/elimination_assembly_exercise.dart';

class GameExerciseScreen extends StatefulWidget {
  const GameExerciseScreen({super.key});

  @override
  State<GameExerciseScreen> createState() => _GameExerciseScreenState();
}

class _GameExerciseScreenState extends State<GameExerciseScreen> {
  int _currentExerciseIndex = 0;
  bool _isCompleting = false;

  void _onExerciseComplete(ExerciseResult result) {
    if (_isCompleting) return;
    
    final game = context.read<GameProvider>();
    final currentLevel = game.currentLevel;
    if (currentLevel == null) return;

    if (result.isCorrect) {
      if (currentLevel.layout == 'list') {
        _isCompleting = true;
        game.completeLevel(currentLevel.id, 3);
        game.addCoins(100);
        context.pushReplacement('/win', extra: {
          'coins': 100,
          'stars': 3,
          'title': result.successPhrase ?? 'أحسنت! أكملت ${currentLevel.title}',
        });
        return;
      }
      game.addCoins(10);
    }

    if (_currentExerciseIndex < currentLevel.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
      });
    } else {
      _isCompleting = true;
      if (result.isCorrect) {
        game.completeLevel(currentLevel.id, 3);
      }
      
      String winTitle = result.successPhrase ?? 'أحسنت! أكملت ${currentLevel.title}';
      if (currentLevel.id == 'world_3_lvl_1') {
        winTitle = 'أنت حقاً مُذهش!';
      } else if (currentLevel.id == 'world_4_lvl_8') {
        winTitle = result.stars >= 2 
          ? 'لقد أتممت عالم الحذف بنجاح! أنت الآن بطل الحروف.' 
          : 'أداء جيد، ولكن يمكنك التحسن. حاول مرة أخرى لتصبح بطلاً!';
      }

      context.pushReplacement('/win', extra: {
        'coins': result.isCorrect ? 100 : 0,
        'stars': result.isCorrect ? 3 : 0,
        'title': winTitle,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        final currentLevel = game.currentLevel;
        if (currentLevel == null) {
          return const Scaffold(body: Center(child: Text('المستوى غير موجود')));
        }

        return GameBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(context, game, currentLevel),
                    if (currentLevel.layout != 'list')
                      _buildProgressBar(currentLevel.exercises.length),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: currentLevel.layout == 'list'
                            ? ListCompletionExercise(
                                level: currentLevel,
                                onComplete: _onExerciseComplete,
                                isLast: true,
                              )
                            : _buildExerciseWidget(
                                currentLevel.exercises[_currentExerciseIndex],
                                _currentExerciseIndex == currentLevel.exercises.length - 1,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExerciseWidget(Exercise exercise, bool isLast) {
    switch (exercise.type) {
      case 'imageChoice':
      case 'firstLetter':
        return ImageChoiceExercise(
          key: ValueKey(exercise.id),
          exercise: exercise,
          onComplete: _onExerciseComplete,
          isLast: isLast,
        );
      case 'sentenceAddition':
        return SentenceAdditionExercise(
          key: ValueKey(exercise.id),
          exercise: exercise,
          onComplete: _onExerciseComplete,
          isLast: isLast,
        );
      case 'extraLetter':
        return ExtraLetterExercise(
          key: ValueKey(exercise.id),
          exercise: exercise,
          onComplete: _onExerciseComplete,
          isLast: isLast,
        );
      case 'letterFind':
      case 'soundDrag':
        return LetterFindExercise(
          key: ValueKey(exercise.id),
          exercise: exercise,
          onComplete: _onExerciseComplete,
          isLast: isLast,
        );
      case 'missingLetter':
        return MissingLetterExercise(
          key: ValueKey(exercise.id),
          exercise: exercise,
          onComplete: _onExerciseComplete,
          isLast: isLast,
        );
      case 'spelling':
        return SpellingExercise(
          key: ValueKey(exercise.id),
          exercise: exercise,
          onComplete: _onExerciseComplete,
          isLast: isLast,
        );
      case 'syllableCloud':
        return SyllableCloudExercise(
          key: ValueKey(exercise.id),
          exercise: exercise,
          onComplete: _onExerciseComplete,
          isLast: isLast,
        );
      case 'wordAssembly':
        return WordAssemblyExercise(
          key: ValueKey(exercise.id),
          exercise: exercise,
          onComplete: _onExerciseComplete,
          isLast: isLast,
        );
      case 'eliminationAssembly':
        return EliminationAssemblyExercise(
          key: ValueKey(exercise.id),
          exercise: exercise,
          onComplete: _onExerciseComplete,
          isLast: isLast,
        );
      default:
        return Center(
          child: Text('نوع التمرين غير معروف: ${exercise.type}', style: GoogleFonts.cairo()),
        );
    }
  }

  Widget _buildHeader(BuildContext context, GameProvider game, Level level) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.outlineVariant, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const PremiumNavButton(icon: Icons.close),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                level.title,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildStatChip(Icons.stars, Colors.amber, game.stars.toString()),
            const SizedBox(width: 8),
            _buildStatChip(Icons.monetization_on, Colors.orange, game.coins.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, Color color, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int total) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: List.generate(total, (index) {
          bool isCompleted = index < _currentExerciseIndex;
          bool isCurrent = index == _currentExerciseIndex;
          
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isCompleted 
                    ? Colors.green 
                    : isCurrent 
                        ? AppColors.primary 
                        : AppColors.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }),
      ),
    );
  }
}
