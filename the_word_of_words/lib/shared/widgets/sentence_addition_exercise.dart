import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/game_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/tts_feedback_service.dart';
import 'premium_ui_widgets.dart';

class SentenceAdditionExercise extends StatefulWidget {
  final Exercise exercise;
  final Function(ExerciseResult) onComplete;
  final bool isLast;

  const SentenceAdditionExercise({
    super.key,
    required this.exercise,
    required this.onComplete,
    this.isLast = false,
  });

  @override
  State<SentenceAdditionExercise> createState() => _SentenceAdditionExerciseState();
}

enum AdditionPhase { showingOriginal, hidden, showingChallenge }

class _SentenceAdditionExerciseState extends State<SentenceAdditionExercise> {
  String? _droppedWord;
  String? _errorWord;
  late DateTime _startTime;
  bool _isCompleted = false;
  String _successPhrase = '';

  AdditionPhase _phase = AdditionPhase.showingOriginal;

  @override
  void initState() {
    super.initState();
    _startExercise();
  }

  void _startExercise() {
    _startTime = DateTime.now();


    _errorWord = null;
    _isCompleted = false;
    _phase = AdditionPhase.showingOriginal;

    // Phase 1: Show original sentence for 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() => _phase = AdditionPhase.hidden);
        
        // Phase 2: Short pause then show challenge
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() => _phase = AdditionPhase.showingChallenge);
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(SentenceAdditionExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _startExercise();
    }
  }

  void _handleWordClick(String word) async {
    if (_isCompleted) return;

    // Read the tapped word aloud before checking correct/wrong

    if (word.trim() == widget.exercise.correctAnswer.trim()) {
      setState(() {
        _droppedWord = word; // Used to highlight the correct word
        _isCompleted = true;
        _errorWord = null;
      });
      
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
      setState(() {
        _errorWord = word;
      });
      
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _errorWord = null;
          });
        }
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
            _phase == AdditionPhase.showingOriginal 
                ? "اقرأ وتذكر الجملة" 
                : "ما هي الكلمة التي أضيفت؟",
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
              const SizedBox(height: 16),
              
              // Target Sentence Area
              Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _buildSentenceDisplay(),
                  ),
                ).animate(target: _errorWord != null ? 1 : 0).shake(hz: 6, offset: const Offset(6, 0)),
              ),
              
              const SizedBox(height: 20),
              
              // Status/Success Area
              if (_isCompleted)
                PremiumSuccessBadge(message: _successPhrase).animate().scale(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSentenceDisplay() {
    if (_phase == AdditionPhase.showingOriginal) {
      return Container(
        key: const ValueKey('original'),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 2),
        ),
        child: Text(
          widget.exercise.question, // Show the SHORT sentence first
          style: GoogleFonts.cairo(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else if (_phase == AdditionPhase.showingChallenge) {
      // Split the hint into tokens to find the correct answer
      String hint = widget.exercise.hint;
      String target = widget.exercise.correctAnswer;
      
      int targetIndex = hint.indexOf(target);
      if (targetIndex == -1) {
        // Fallback if target not found in hint (shouldn't happen with good data)
        return Text(hint, style: GoogleFonts.cairo(fontSize: 28));
      }

      String prefix = hint.substring(0, targetIndex);
      String suffix = hint.substring(targetIndex + target.length);

      List<String> prefixWords = prefix.trim().isEmpty ? [] : prefix.trim().split(RegExp(r'\s+'));
      List<String> suffixWords = suffix.trim().isEmpty ? [] : suffix.trim().split(RegExp(r'\s+'));

      return Container(
        key: const ValueKey('challenge'),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.outlineVariant, width: 2),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            ...prefixWords.map((w) => _buildWordButton(w, false)),
            _buildWordButton(target, true),
            ...suffixWords.map((w) => _buildWordButton(w, false)),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink(key: ValueKey('empty'));
    }
  }

  Widget _buildWordButton(String word, bool isCorrect) {
    bool isBeingClicked = _errorWord == word;
    bool isSolved = _isCompleted && isCorrect;

    return GestureDetector(
      onTap: () => _handleWordClick(word),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSolved 
              ? Colors.green.withValues(alpha: 0.2) 
              : (isBeingClicked ? Colors.red.withValues(alpha: 0.2) : Colors.transparent),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSolved 
                ? Colors.green 
                : (isBeingClicked ? Colors.red : AppColors.outlineVariant.withValues(alpha: 0.3)),
            width: 2,
          ),
        ),
        child: Text(
          word,
          style: GoogleFonts.cairo(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: isSolved 
                ? Colors.green[700] 
                : (isBeingClicked ? Colors.red[700] : AppColors.onSurface),
          ),
        ),
      ),
    );
  }
}
