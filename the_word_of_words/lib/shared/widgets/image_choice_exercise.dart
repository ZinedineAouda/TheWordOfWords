import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/game_models.dart';
import '../../core/services/tts_feedback_service.dart';
import 'premium_ui_widgets.dart';
import '../../core/theme/app_colors.dart';

class ImageChoiceExercise extends StatefulWidget {
  final Exercise exercise;
  final Function(ExerciseResult) onComplete;
  final bool isLast;

  const ImageChoiceExercise({
    super.key,
    required this.exercise,
    required this.onComplete,
    this.isLast = false,
  });

  @override
  State<ImageChoiceExercise> createState() => _ImageChoiceExerciseState();
}

class _ImageChoiceExerciseState extends State<ImageChoiceExercise> {
  String? _selectedOption;
  bool _isAnswered = false;
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
  void didUpdateWidget(ImageChoiceExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _selectedOption = null;
      _isAnswered = false;
      _startTime = DateTime.now();
      _shuffledOptions = List<String>.from(widget.exercise.options)..shuffle();
    }
  }

  void _handleOptionTap(String option) async {
    if (_isAnswered) return;

    final isCorrect = option == widget.exercise.correctAnswer;
    setState(() {
      _selectedOption = option;
      _isAnswered = true;
    });

    if (isCorrect) {
      // Speak the answer first
      await TtsFeedbackService().speak(widget.exercise.correctAnswer);
      
      final phrase = await TtsFeedbackService().onCorrect();
      setState(() {
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
      
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _selectedOption = null;
            _isAnswered = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Flexible(
          flex: 2,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Text(
                  "ماذا ترى في الصورة؟",
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Content Area
        Expanded(
          flex: 8,
          child: Column(
            children: [
              // Image Section
              Expanded(
                flex: 4,
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
                      child: widget.exercise.imageAsset != null
                          ? Image.asset(
                              widget.exercise.imageAsset!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 60,
                                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 60,
                                color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                              ),
                            ),
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                ),
              ),

              // Options Section
              Expanded(
                flex: 6,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_shuffledOptions.length, (index) {
                            final option = _shuffledOptions[index];
                            final isSelected = _selectedOption == option;
                            final isCorrect = _isAnswered && option == widget.exercise.correctAnswer;
                            final isWrong = isSelected && _isAnswered && option != widget.exercise.correctAnswer;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => _handleOptionTap(option),
                                child: AnimatedContainer(
                                  duration: 300.ms,
                                  width: 320,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                                  decoration: BoxDecoration(
                                    color: isCorrect
                                        ? Colors.green.withValues(alpha: 0.1)
                                        : (isWrong ? Colors.red.withValues(alpha: 0.1) : AppColors.surfaceContainerHigh),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isCorrect
                                          ? Colors.green
                                          : (isWrong ? Colors.red : (isSelected ? AppColors.primary : AppColors.outlineVariant)),
                                      width: 2.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: GoogleFonts.cairo(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: isCorrect ? Colors.green : (isWrong ? Colors.red : AppColors.onSurface),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      if (isCorrect) const Icon(Icons.check_circle, color: Colors.green),
                                      if (isWrong) const Icon(Icons.cancel, color: Colors.red),
                                    ],
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.2);
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        if (_isAnswered && _selectedOption == widget.exercise.correctAnswer && !widget.isLast)
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
