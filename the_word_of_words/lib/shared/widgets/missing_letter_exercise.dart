import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/models/game_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/tts_feedback_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'premium_ui_widgets.dart';

class MissingLetterExercise extends StatefulWidget {
  final Exercise exercise;
  final Function(ExerciseResult) onComplete;
  final bool isLast;

  const MissingLetterExercise({
    super.key,
    required this.exercise,
    required this.onComplete,
    this.isLast = false,
  });

  @override
  State<MissingLetterExercise> createState() => _MissingLetterExerciseState();
}

class _MissingLetterExerciseState extends State<MissingLetterExercise> {
  String? _droppedLetter;
  bool _isWrong = false;
  bool _isCorrect = false;
  String _successPhrase = '';
  late DateTime _startTime;
  late List<String> _shuffledOptions;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _shuffledOptions = List<String>.from(widget.exercise.options)..shuffle();
  }

  @override
  void didUpdateWidget(MissingLetterExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _droppedLetter = null;
      _isWrong = false;
      _isCorrect = false;
      _startTime = DateTime.now();
      _shuffledOptions = List<String>.from(widget.exercise.options)..shuffle();
    }
  }

  void _handleSelection(String letter) async {
    if (_isCorrect) return;

    if (letter == widget.exercise.correctAnswer) {
      final phrase = await TtsFeedbackService().onCorrect();
      setState(() {
        _droppedLetter = letter;
        _isCorrect = true;
        _isWrong = false;
        _successPhrase = phrase;
      });
      
      final duration = DateTime.now().difference(_startTime).inSeconds;
      Future.delayed(Duration(milliseconds: widget.isLast ? 600 : 1500), () {
        if (mounted) {
          widget.onComplete(ExerciseResult(
            isCorrect: true,
            timeTaken: duration,
            stars: 3,
            successPhrase: phrase,
          ));
        }
      });
    } else {
      TtsFeedbackService().onWrong();
      setState(() => _isWrong = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _isWrong = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String wordWithPlaceholder = widget.exercise.question;
    if (_droppedLetter != null) {
      const placeholders = ['.....', '....', '...', '?', '؟'];
      for (var p in placeholders) {
        if (wordWithPlaceholder.contains(p)) {
          wordWithPlaceholder = wordWithPlaceholder.replaceFirst(p, _droppedLetter!);
          break;
        }
      }
    }

    return Column(
      children: [
        // Header
        Flexible(
          flex: 2,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "اختر الحرف الناقص",
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
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
              // Image container
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

              // Question text
              Flexible(
                flex: 3,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2.5),
                        ),
                        child: Text(
                          wordWithPlaceholder,
                          style: GoogleFonts.cairo(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: AppColors.onSurface,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn().slideY(begin: 0.1),
              ),

              // Options
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Container(
                      width: 320,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _shuffledOptions.length > 4 ? 4 : _shuffledOptions.length,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: _shuffledOptions.length,
                        itemBuilder: (context, index) {
                          final option = _shuffledOptions[index];
                          return GestureDetector(
                            onTap: () => _handleSelection(option),
                            child: PremiumTactileBubble(
                              text: option,
                              size: 70,
                              isSelected: _droppedLetter == option,
                              isCorrect: _isCorrect && option == widget.exercise.correctAnswer,
                              isWrong: _isWrong && option != widget.exercise.correctAnswer,
                            ),
                          ).animate().scale(delay: (index * 50).ms, curve: Curves.easeOutBack);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        if (_isCorrect && !widget.isLast)
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
