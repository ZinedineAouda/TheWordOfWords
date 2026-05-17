import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/game_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/tts_feedback_service.dart';
import 'premium_ui_widgets.dart';

class SpellingExercise extends StatefulWidget {
  final Exercise exercise;
  final Function(ExerciseResult) onComplete;
  final bool isLast;

  const SpellingExercise({
    super.key,
    required this.exercise,
    required this.onComplete,
    this.isLast = false,
  });

  @override
  State<SpellingExercise> createState() => _SpellingExerciseState();
}

class _SpellingExerciseState extends State<SpellingExercise> {
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
  void didUpdateWidget(SpellingExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _droppedLetter = null;
      _isWrong = false;
      _isCorrect = false;
      _startTime = DateTime.now();
      _shuffledOptions = List<String>.from(widget.exercise.options)..shuffle();
    }
  }

  void _handleDrop(String letter) async {
    if (_isCorrect) return;

    // Read the letter name aloud on every drop

    if (letter == widget.exercise.correctAnswer) {
      // 1. Speak the full word (the question text might have '?' which we replace)
      final fullWord = widget.exercise.question.replaceAll('?', letter);
      await TtsFeedbackService().speak(fullWord);
      
      // 2. Speak the success phrase
      final phrase = await TtsFeedbackService().onCorrect();
      setState(() {
        _droppedLetter = letter;
        _isCorrect = true;
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "أكمل الكلمة بسحب الحرف المناسب",
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.exercise.imageAsset != null)
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: AppColors.outlineVariant, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(widget.exercise.imageAsset!, fit: BoxFit.contain),
                      ),
                    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  ),
                ),

              const SizedBox(height: 20),

              // Drop Target Word
              Flexible(
                flex: 2,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.outlineVariant, width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.exercise.question.replaceAll('?', ''),
                            style: GoogleFonts.cairo(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(width: 12),
                          DragTarget<String>(
                            onAcceptWithDetails: (details) => _handleDrop(details.data),
                            builder: (context, candidateData, rejectedData) {
                              final isHovering = candidateData.isNotEmpty;
                              return AnimatedContainer(
                                duration: 300.ms,
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: _isCorrect
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : (isHovering ? AppColors.surfaceVariant : AppColors.surfaceContainer),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _isCorrect
                                        ? Colors.green
                                        : (isHovering ? AppColors.primary : AppColors.outlineVariant),
                                    width: isHovering || _isCorrect ? 4 : 2,
                                  ),
                                ),
                                child: Center(
                                  child: _isCorrect
                                      ? Text(
                                          _droppedLetter!,
                                          style: GoogleFonts.cairo(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.green,
                                          ),
                                        ).animate().scale(curve: Curves.elasticOut)
                                      : Icon(
                                          Icons.add,
                                          color: isHovering ? AppColors.primary : AppColors.onSurface.withValues(alpha: 0.2),
                                          size: 32,
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Letter Options
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: _shuffledOptions.asMap().entries.map((entry) {
                        final letter = entry.value;
                        final isUsed = _isCorrect && letter == _droppedLetter;
                        
                        return Draggable<String>(
                          data: letter,
                          feedback: Material(
                            color: Colors.transparent,
                            child: PremiumTactileBubble(text: letter, size: 70, isDragging: true),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.1,
                            child: PremiumTactileBubble(text: letter, size: 70),
                          ),
                          child: Opacity(
                            opacity: isUsed ? 0.0 : 1.0,
                            child: PremiumTactileBubble(text: letter, size: 70),
                          ),
                        ).animate().scale(delay: (entry.key * 100).ms, curve: Curves.easeOutBack);
                      }).toList(),
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
