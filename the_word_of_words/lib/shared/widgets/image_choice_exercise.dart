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
  Set<String> _selectedOptions = {};
  String? _wrongOption;
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
      _selectedOptions.clear();
      _wrongOption = null;
      _isAnswered = false;
      _startTime = DateTime.now();
      _shuffledOptions = List<String>.from(widget.exercise.options)..shuffle();
    }
  }

  void _handleOptionTap(String option) async {
    if (_isAnswered || _selectedOptions.contains(option)) return;

    final isCorrect = widget.exercise.correctAnswers.contains(option);

    setState(() {
      if (isCorrect) {
        _selectedOptions.add(option);
        _wrongOption = null;
      } else {
        _wrongOption = option;
      }
    });

    if (isCorrect) {
      // Speak the answer asynchronously so the UI remains highly responsive
      TtsFeedbackService().speak(option);
      
      // Check if all correct answers have been found
      if (_selectedOptions.length == widget.exercise.correctAnswers.length) {
        setState(() {
          _isAnswered = true;
        });
        
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
      }
    } else {
      TtsFeedbackService().onWrong();
      
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _wrongOption = null;
          });
        }
      });
    }
  }

  bool get _hasImage => widget.exercise.imageAsset != null;

  Widget _buildOptionsSection() {
    final useWrap = !_hasImage || _shuffledOptions.length > 4;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: useWrap
                ? Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: List.generate(_shuffledOptions.length, (index) {
                      final option = _shuffledOptions[index];
                      final isSelected = _selectedOptions.contains(option);
                      final isCorrect = isSelected && widget.exercise.correctAnswers.contains(option);
                      final isWrong = _wrongOption == option;

                      return GestureDetector(
                        onTap: () => _handleOptionTap(option),
                        child: AnimatedContainer(
                          duration: 300.ms,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? Colors.green.withValues(alpha: 0.1)
                                : (isWrong ? Colors.red.withValues(alpha: 0.1) : AppColors.surfaceContainerHigh),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isCorrect
                                  ? Colors.green
                                  : (isWrong ? Colors.red : AppColors.outlineVariant),
                              width: 2.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                option,
                                style: GoogleFonts.cairo(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isCorrect ? Colors.green : (isWrong ? Colors.red : AppColors.onSurface),
                                ),
                              ),
                              if (isCorrect) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                              ],
                              if (isWrong) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.cancel, color: Colors.red, size: 20),
                              ],
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: (index * 80).ms).scale(begin: const Offset(0.9, 0.9));
                    }),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_shuffledOptions.length, (index) {
                      final option = _shuffledOptions[index];
                      final isSelected = _selectedOptions.contains(option);
                      final isCorrect = isSelected && widget.exercise.correctAnswers.contains(option);
                      final isWrong = _wrongOption == option;

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
                                    : (isWrong ? Colors.red : AppColors.outlineVariant),
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
    );
  }
  Widget build(BuildContext context) {
    // Extract the sentence hint from the question if it contains a sentence context
    // Format: "instruction\nsentence" — e.g. "اختر الكلمة...\nذَهَبْتُ إِلَى مَكَانٍ جَمِيلٍ"
    final parts = widget.exercise.question.split('\n');
    final instruction = parts.first;
    final sentenceHint = parts.length > 1 ? parts.sublist(1).join('\n') : null;

    return Column(
      children: [
        // Header / Instruction
        Flexible(
          flex: 2,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Text(
                  instruction.isNotEmpty ? instruction : "ماذا ترى في الصورة؟",
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
          child: _hasImage
              ? _buildWithImage()
              : _buildTextOnly(sentenceHint),
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

  /// Layout with image (original behavior)
  Widget _buildWithImage() {
    return Column(
      children: [
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
                child: Image.asset(
                  widget.exercise.imageAsset!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 60,
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          ),
        ),
        Expanded(
          flex: 6,
          child: _buildOptionsSection(),
        ),
      ],
    );
  }

  /// Layout for text-only exercises (sentence extraction, word selection, etc.)
  Widget _buildTextOnly(String? sentenceHint) {
    return Column(
      children: [
        // Sentence display card (when there's a sentence context)
        if (sentenceHint != null)
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6A11CB).withValues(alpha: 0.08),
                      const Color(0xFF2575FC).withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF6A11CB).withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      sentenceHint,
                      style: GoogleFonts.cairo(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms).scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),
            ),
          ),

        // Options
        Expanded(
          flex: sentenceHint != null ? 7 : 10,
          child: _buildOptionsSection(),
        ),
      ],
    );
  }

}
