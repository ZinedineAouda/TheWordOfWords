import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/game_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/tts_feedback_service.dart';
import 'premium_ui_widgets.dart';

class LetterFindExercise extends StatefulWidget {
  final Exercise exercise;
  final Function(ExerciseResult) onComplete;
  final bool isLast;

  const LetterFindExercise({
    super.key,
    required this.exercise,
    required this.onComplete,
    this.isLast = false,
  });

  @override
  State<LetterFindExercise> createState() => _LetterFindExerciseState();
}

class _LetterFindExerciseState extends State<LetterFindExercise> {
  final Set<int> _foundIndices = {};
  late List<String> _grid;
  late DateTime _startTime;
  bool _isCorrect = false;
  String _successPhrase = '';

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _initializeGrid();
  }

  @override
  void didUpdateWidget(LetterFindExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _foundIndices.clear();
      _isCorrect = false;
      _startTime = DateTime.now();
      _initializeGrid();
    }
  }

  void _initializeGrid() {
    _grid = List<String>.from(widget.exercise.options);
    if (_grid.length < 9) {
      while (_grid.length < 9) {
        _grid.add("");
      }
    } else if (_grid.length > 9) {
      _grid = _grid.sublist(0, 9);
    }
  }

  void _handleTap(int index, String letter) async {
    if (_foundIndices.contains(index)) return;

    // Read the letter name aloud on every tap

    if (letter == widget.exercise.correctAnswer) {
      setState(() {
        _foundIndices.add(index);
      });
      
      final totalCorrect = _grid.where((l) => l == widget.exercise.correctAnswer).length;
      
      if (_foundIndices.length == totalCorrect) {
        setState(() => _isCorrect = true);
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
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      "أين حرف \"${widget.exercise.correctAnswer}\"؟",
                      style: GoogleFonts.cairo(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      "ابحث عن الحرف في الجدول",
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
        ),

        // Grid Area
        Expanded(
          flex: 8,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  width: 320,
                  height: 320,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.outlineVariant, width: 2),
                  ),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final letter = _grid[index];
                      final isFound = _foundIndices.contains(index);
                      
                      return GestureDetector(
                        onTap: () => _handleTap(index, letter),
                        child: PremiumTactileBubble(
                          text: letter,
                          size: 80,
                          isCorrect: isFound,
                          isSelected: isFound,
                        ),
                      ).animate().scale(delay: (index * 50).ms, curve: Curves.easeOutBack);
                    },
                  ),
                ),
              ),
            ),
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
