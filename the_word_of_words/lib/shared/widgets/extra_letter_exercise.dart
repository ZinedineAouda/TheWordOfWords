import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/game_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/tts_feedback_service.dart';
import 'premium_ui_widgets.dart';

class ExtraLetterExercise extends StatefulWidget {
  final Exercise exercise;
  final Function(ExerciseResult) onComplete;
  final bool isLast;

  const ExtraLetterExercise({
    super.key,
    required this.exercise,
    required this.onComplete,
    this.isLast = false,
  });

  @override
  State<ExtraLetterExercise> createState() => _ExtraLetterExerciseState();
}

class _ExtraLetterExerciseState extends State<ExtraLetterExercise> {
  final Set<int> _deletedIndices = {};
  late List<String> _letters;
  late DateTime _startTime;
  bool _isAnswered = false;
  String _successPhrase = '';

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    // In extraLetter, the question is usually the word with the extra letter
    _letters = widget.exercise.question.split('');
  }

  @override
  void didUpdateWidget(ExtraLetterExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _deletedIndices.clear();
      _isAnswered = false;
      _startTime = DateTime.now();
      _letters = widget.exercise.question.split('');
    }
  }

  void _handleLetterTap(int index, String letter) async {
    if (_isAnswered || _deletedIndices.contains(index)) return;

    // Read the letter name aloud on every tap

    // In this mode, we allow removing any character that is part of the "correctAnswer" (the extra letters)
    // and we check if the remaining string matches the target (exercise.hint)
    
    if (widget.exercise.correctAnswer.contains(letter)) {
      setState(() {
        _deletedIndices.add(index);
      }); // Subtle feedback for removal

      // Check if the current word matches the hint (original word)
      String currentWord = "";
      for (int i = 0; i < _letters.length; i++) {
        if (!_deletedIndices.contains(i)) {
          currentWord += _letters[i];
        }
      }

      if (currentWord == widget.exercise.hint) {
        final phrase = await TtsFeedbackService().onCorrect();
        setState(() {
          _isAnswered = true;
          _successPhrase = phrase;
        });
        
        final duration = DateTime.now().difference(_startTime).inSeconds;
        Future.delayed(Duration(milliseconds: widget.isLast ? 600 : 2000), () {
          if (mounted) {
            widget.onComplete(ExerciseResult(
              isCorrect: true,
              timeTaken: duration,
              stars: 3,
              successPhrase: phrase,
            ));
          }
        });
      }
    } else {
      TtsFeedbackService().onWrong();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Flexible(
          flex: 2,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Text(
                    "احذف الحرف الزائد",
                    style: GoogleFonts.cairo(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    "هناك حرف لا ينتمي لهذه الكلمة",
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: AppColors.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Content Area
        Expanded(
          flex: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.exercise.imageAsset != null)
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.outlineVariant, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(widget.exercise.imageAsset!, fit: BoxFit.contain),
                      ),
                    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  ),
                ),
              
              const SizedBox(height: 16),
              
              Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_letters.length, (index) {
                        final letter = _letters[index];
                        final isDeleted = _deletedIndices.contains(index);
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () => _handleLetterTap(index, letter),
                            child: AnimatedContainer(
                              duration: 400.ms,
                              width: 65,
                              height: 75,
                              decoration: BoxDecoration(
                                color: isDeleted 
                                    ? Colors.red.withValues(alpha: 0.1) 
                                    : AppColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDeleted ? Colors.red : AppColors.outlineVariant,
                                  width: 2,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    letter,
                                    style: GoogleFonts.cairo(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                      color: isDeleted 
                                          ? AppColors.onSurface.withValues(alpha: 0.2) 
                                          : AppColors.onSurface,
                                    ),
                                  ),
                                  if (isDeleted)
                                    const Icon(Icons.close, color: Colors.red, size: 40)
                                        .animate().scale(curve: Curves.elasticOut),
                                ],
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1);
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        if (_isAnswered && !widget.isLast)
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumSuccessBadge(message: _successPhrase),
            ),
          ),
      ],
    );
  }

}
