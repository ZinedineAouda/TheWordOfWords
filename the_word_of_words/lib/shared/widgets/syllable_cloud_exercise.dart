import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/game_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/tts_feedback_service.dart';
import 'premium_ui_widgets.dart';

class SyllableCloudExercise extends StatefulWidget {
  final Exercise exercise;
  final Function(ExerciseResult) onComplete;
  final bool isLast;

  const SyllableCloudExercise({
    super.key,
    required this.exercise,
    required this.onComplete,
    this.isLast = false,
  });

  @override
  State<SyllableCloudExercise> createState() => _SyllableCloudExerciseState();
}

class _SyllableCloudExerciseState extends State<SyllableCloudExercise> {
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
  void didUpdateWidget(SyllableCloudExercise oldWidget) {
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

    // Speak the tapped syllable immediately
    await TtsFeedbackService().speak(option);

    final isCorrect = option == widget.exercise.correctAnswer;
    setState(() {
      _selectedOption = option;
      _isAnswered = true;
    });

    if (isCorrect) {
      // If correct, wait a moment then speak the full completed word
      final completedWord = widget.exercise.question.replaceAll(RegExp(r'\.+'), option);
      await Future.delayed(const Duration(milliseconds: 500));
      await TtsFeedbackService().speak(completedWord);

      final phrase = await TtsFeedbackService().onCorrect();
      setState(() => _successPhrase = phrase);
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
    final bool isCorrect = _isAnswered && _selectedOption == widget.exercise.correctAnswer;
    final String displayText = isCorrect
        ? widget.exercise.question.replaceAll(RegExp(r'\.+'), _selectedOption!)
        : widget.exercise.question;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "اختر السحابة الصحيحة",
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
              // Question Board
              Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: AppColors.outlineVariant, width: 2),
                      ),
                      child: Text(
                        displayText,
                        style: GoogleFonts.cairo(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppColors.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn().scale(curve: Curves.easeOutBack),
              
              const SizedBox(height: 20),
              
              // Clouds Area
              Flexible(
                flex: 5,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        runSpacing: 20,
                        children: _shuffledOptions.asMap().entries.map((entry) {
                          return _buildCloudOption(entry.value, entry.key)
                              .animate()
                              .fadeIn(delay: (entry.key * 100).ms)
                              .scale(curve: Curves.easeOutBack);
                        }).toList(),
                      ),
                    ),
                  ),
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
          ),
        ),
      ],
    );
  }

  Widget _buildCloudOption(String option, int index) {
    final isSelected = _selectedOption == option;
    final isCorrect = option == widget.exercise.correctAnswer;
    
    return GestureDetector(
      onTap: () => _handleOptionTap(option),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 1500 + (index * 200)),
        curve: Curves.easeInOutSine,
        builder: (context, value, child) {
          final offset = Offset(0, 10 * math.sin(value * 2 * math.pi));
          return Transform.translate(
            offset: offset,
            child: child,
          );
        },
        child: SizedBox(
          width: 150,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(150, 100),
                painter: PremiumCloudPainter(
                  color: isSelected 
                      ? (isCorrect ? Colors.green.withValues(alpha: 0.9) : Colors.red.withValues(alpha: 0.9))
                      : AppColors.surfaceContainerHigh,
                  borderColor: isSelected
                      ? (isCorrect ? Colors.green : Colors.red)
                      : AppColors.outlineVariant,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  option,
                  style: GoogleFonts.cairo(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? Colors.white : AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(target: isSelected && !isCorrect ? 1 : 0).shake(hz: 8, offset: const Offset(6, 0));
  }
}

class PremiumCloudPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  PremiumCloudPainter({
    required this.color, 
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    double w = size.width;
    double h = size.height;

    path.moveTo(w * 0.3, h * 0.85);
    path.arcToPoint(Offset(w * 0.1, h * 0.65), radius: Radius.circular(w * 0.2), clockwise: true);
    path.arcToPoint(Offset(w * 0.15, h * 0.35), radius: Radius.circular(w * 0.2), clockwise: true);
    path.arcToPoint(Offset(w * 0.5, h * 0.2), radius: Radius.circular(w * 0.25), clockwise: true);
    path.arcToPoint(Offset(w * 0.85, h * 0.35), radius: Radius.circular(w * 0.2), clockwise: true);
    path.arcToPoint(Offset(w * 0.9, h * 0.65), radius: Radius.circular(w * 0.2), clockwise: true);
    path.arcToPoint(Offset(w * 0.7, h * 0.85), radius: Radius.circular(w * 0.2), clockwise: true);
    path.lineTo(w * 0.3, h * 0.85);
    path.close();

    final paint = Paint()..color = color..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    final borderPaint = Paint()..color = borderColor..style = PaintingStyle.stroke..strokeWidth = 2;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
