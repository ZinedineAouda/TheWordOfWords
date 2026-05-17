import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/game_models.dart';
import '../../core/services/tts_feedback_service.dart';
import 'premium_ui_widgets.dart';
import '../../core/theme/app_colors.dart';

class ListCompletionExercise extends StatefulWidget {
  final Level level;
  final Function(ExerciseResult) onComplete;
  final bool isLast;

  const ListCompletionExercise({
    super.key,
    required this.level,
    required this.onComplete,
    this.isLast = false,
  });

  @override
  State<ListCompletionExercise> createState() => _ListCompletionExerciseState();
}

class _ListCompletionExerciseState extends State<ListCompletionExercise> {
  final Map<String, String?> _answers = {};
  late List<String> _shuffledLetters;
  final Map<int, bool> _shuffledLetterUsed = {};
  late DateTime _startTime;
  String _successPhrase = '';

  @override
  void initState() {
    super.initState();
    _initExercise();
  }

  @override
  void didUpdateWidget(ListCompletionExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level.id != widget.level.id) {
      _initExercise();
    }
  }

  void _initExercise() {
    _startTime = DateTime.now();
    _answers.clear();
    _shuffledLetterUsed.clear();
    
    // Get all correct answers and shuffle them
    final letters = widget.level.exercises.map((e) => e.correctAnswer).toList();
    _shuffledLetters = List<String>.from(letters)..shuffle();
  }

  void _onLetterDropped(Exercise exercise, String letter, int sourceIndex) async {
    if (letter == exercise.correctAnswer) {
      setState(() {
        _answers[exercise.id] = letter;
        _shuffledLetterUsed[sourceIndex] = true;
      });
      
      // Pedagogical feedback: Read the letter name, then the full word
      await Future.delayed(const Duration(milliseconds: 500));
      

      if (_answers.length == widget.level.exercises.length) {
        final phrase = await TtsFeedbackService().onCorrect();
        if (mounted) {
          setState(() {
            _successPhrase = phrase;
          });
        }
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
      // Pedagogical feedback for errors: Read the letter name, then the resulting (wrong) combination
      await Future.delayed(const Duration(milliseconds: 500));

    }
  }

  @override
  Widget build(BuildContext context) {
    bool isAllCorrect = _answers.length == widget.level.exercises.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "اسحب الحرف المناسب لتكمل الكلمة",
            style: GoogleFonts.cairo(
              fontSize: 18,
              color: AppColors.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              // 1. Word List
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.level.exercises.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: _buildExerciseRow(index)
                              .animate()
                              .fadeIn(delay: (index * 100).ms)
                              .slideX(begin: -0.1, end: 0),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              
              // 2. Letter Pool
              Container(
                width: 90,
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColors.outlineVariant, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_shuffledLetters.length, (index) {
                    final String poolLetter = _shuffledLetters[index];
                    final bool isLetterUsed = _shuffledLetterUsed[index] ?? false;
                    
                    return Expanded(
                      child: Center(
                        child: (!isLetterUsed)
                            ? Draggable<Map<String, dynamic>>(
                                data: {'letter': poolLetter, 'index': index},
                                onDragStarted: () {},
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        )
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      poolLetter,
                                      style: GoogleFonts.cairo(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.3,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      poolLetter,
                                      style: GoogleFonts.cairo(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.outlineVariant, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      poolLetter,
                                      style: GoogleFonts.cairo(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3), width: 2),
                                ),
                              ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        if (isAllCorrect && !widget.isLast)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumSuccessBadge(message: _successPhrase),
          ),
      ],
    );
  }

  Widget _buildExerciseRow(int index) {
    final exercise = widget.level.exercises[index];
    final bool isCorrect = _answers.containsKey(exercise.id);
    
    // Determine the layout based on the correctAnswer position in the question
    // If the question contains a placeholder like '?' or '_', use that.
    // Otherwise, check if it starts or ends with the correctAnswer.
    
    String displayQuestion = exercise.question;
    bool isStart = true;
    
    if (displayQuestion.contains('?')) {
      isStart = displayQuestion.startsWith('?');
    } else if (displayQuestion.contains('_')) {
      isStart = displayQuestion.startsWith('_');
    } else {
      // Fallback: check if the fragment starts or ends the word
      isStart = exercise.question.startsWith(exercise.correctAnswer);
    }
    
    final String fragment = exercise.hint;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant, width: 2),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: exercise.imageAsset != null 
                ? Image.asset(exercise.imageAsset!, fit: BoxFit.contain)
                : const Icon(Icons.image_not_supported),
          ),
          const SizedBox(width: 12),
          
          // Word Area
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: isStart 
                  ? [
                      _buildDropSlot(exercise, isCorrect),
                      const SizedBox(width: 8),
                      Text(
                        fragment,
                        style: GoogleFonts.cairo(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ]
                  : [
                      Text(
                        fragment,
                        style: GoogleFonts.cairo(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildDropSlot(exercise, isCorrect),
                    ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropSlot(Exercise exercise, bool isCorrect) {
    return DragTarget<Map<String, dynamic>>(
      onWillAcceptWithDetails: (details) => !isCorrect,
      onAcceptWithDetails: (details) => _onLetterDropped(exercise, details.data['letter'] as String, details.data['index'] as int),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: 300.ms,
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: isCorrect 
                ? Colors.green.withValues(alpha: 0.1) 
                : (isHovering ? AppColors.surfaceVariant : AppColors.surfaceContainerHigh),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCorrect 
                  ? Colors.green 
                  : (isHovering ? AppColors.primary : AppColors.outlineVariant),
              width: isCorrect || isHovering ? 4 : 2,
            ),
          ),
          alignment: Alignment.center,
          child: isCorrect 
            ? Text(
                _answers[exercise.id] ?? '',
                style: GoogleFonts.cairo(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.green,
                ),
              ).animate().scale(curve: Curves.elasticOut)
            : Icon(
                Icons.add,
                color: isHovering ? AppColors.primary : AppColors.onSurface.withValues(alpha: 0.1),
                size: 24,
              ),
        );
      },
    );
  }
}
