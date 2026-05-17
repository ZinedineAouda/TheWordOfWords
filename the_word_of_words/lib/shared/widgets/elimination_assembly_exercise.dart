import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/models/game_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/tts_feedback_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'premium_ui_widgets.dart';



class EliminationAssemblyExercise extends StatefulWidget {
  final Exercise exercise;
  final Function(ExerciseResult) onComplete;
  final bool isLast;

  const EliminationAssemblyExercise({
    super.key,
    required this.exercise,
    required this.onComplete,
    this.isLast = false,
  });

  @override
  State<EliminationAssemblyExercise> createState() => _EliminationAssemblyExerciseState();
}

class _EliminationAssemblyExerciseState extends State<EliminationAssemblyExercise> {
  late List<_LetterItem> _items;
  bool _isEliminationDone = false;
  List<String> _assembledLetters = [];
  late String _targetWord;
  late DateTime _startTime;
  int _attempts = 0;
  final int _maxAttempts = 10;
  bool _isFinished = false;
  String _successPhrase = '';

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _targetWord = widget.exercise.correctAnswer;
    _initializeExercise();
  }

  String _normalize(String char) {
    String normalized = char.replaceAll('\u0640', '');
    normalized = normalized.replaceAll(RegExp(r'[\u064B-\u065F]'), '');
    return normalized;
  }

  void _initializeExercise() {
    Map<String, int> counts = {};
    for (var opt in widget.exercise.options) {
      String norm = _normalize(opt);
      counts[norm] = (counts[norm] ?? 0) + 1;
    }

    _items = widget.exercise.options.map((letter) {
      String norm = _normalize(letter);
      bool isDuplicate = counts[norm]! > 1;
      return _LetterItem(
        letter: letter,
        isDistractor: isDuplicate,
        isEliminated: false,
      );
    }).toList();

    _isEliminationDone = false;
    _assembledLetters = [];
    _attempts = 0;
    _isFinished = false;
  }

  void _onLetterClick(_LetterItem item) {
    if (_isFinished) return;
    if (_isEliminationDone) {
      _onAssemblyClick(item);
      return;
    }

    if (item.isDistractor) {
      if (item.isEliminated) return;
      
      setState(() {
        item.isEliminated = true;
      });
      
      if (_items.where((i) => i.isDistractor && !i.isEliminated).isEmpty) {
        setState(() {
          _isEliminationDone = true;
        });
      }
    } else {
      _handleFailure();
    }
  }

  void _onAssemblyClick(_LetterItem item) {
    if (item.isSelectedInAssembly) return;
    _placeLetterInSlot(item, _assembledLetters.length);
  }

  void _placeLetterInSlot(_LetterItem item, int slotIndex) {
    if (item.isEliminated || item.isSelectedInAssembly || _isFinished) return;
    
    if (slotIndex != _assembledLetters.length) {
      return;
    }

    int nextIndex = _assembledLetters.length;
    if (nextIndex < _targetWord.length) {
      String targetChar = _targetWord[nextIndex];
      if (_normalize(item.letter) == _normalize(targetChar)) {
        setState(() {
          _assembledLetters.add(item.letter);
          item.isSelectedInAssembly = true;
        });

        if (_assembledLetters.length == _targetWord.length) {
          _handleSuccess();
        }
      } else {
        _handleFailure();
      }
    }
  }

  void _handleSuccess() async {
    // 1. Speak the target word first for pedagogical reinforcement
    await TtsFeedbackService().speak(_targetWord);
    
    // 2. Then speak the success phrase
    final phrase = await TtsFeedbackService().onCorrect();
    setState(() {
      _isFinished = true;
      _successPhrase = phrase;
    });
    
    final duration = DateTime.now().difference(_startTime).inSeconds;
    
    Future.delayed(Duration(milliseconds: widget.isLast ? 800 : 2000), () {
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

  void _handleFailure() {
    _attempts++;
    TtsFeedbackService().onWrong();
    
    if (_attempts >= _maxAttempts) {
      widget.onComplete(ExerciseResult(
        isCorrect: false,
        timeTaken: DateTime.now().difference(_startTime).inSeconds,
        stars: 0,
      ));
    }
  }

  @override
  void didUpdateWidget(EliminationAssemblyExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _startTime = DateTime.now();
      _targetWord = widget.exercise.correctAnswer;
      _initializeExercise();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          
          // Header Instruction
          Flexible(
            flex: 2,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isEliminationDone ? Icons.auto_awesome : Icons.search, 
                        color: AppColors.primary, 
                        size: 24
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _isEliminationDone ? "رتب الحروف" : "ابحث عن الكلمة",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().slideY(begin: -0.2).fadeIn(),

          const SizedBox(height: 12),
          
          // Assembly preview area
          Flexible(
            flex: 3,
            child: Center(child: _buildAssemblyPreview()),
          ),
          
          const SizedBox(height: 12),
          
          // Letter area - Main Interaction
          Expanded(
            flex: 8,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: _isEliminationDone 
                      ? _buildAssemblyPhaseLetters() 
                      : _buildEliminationPhaseGrid(),
                  ),
                ),
              ),
            ),
          ),
          
          if (_isFinished && !widget.isLast)
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: PremiumSuccessBadge(message: _successPhrase),
              ),
            ),
          
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildEliminationPhaseGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.0,
          ),
          itemCount: _items.length,
          itemBuilder: (context, index) => _buildLetterBubble(_items[index], index),
        );
      }
    );
  }

  Widget _buildAssemblyPhaseLetters() {
    final remainingItems = _items.where((i) => !i.isDistractor).toList();
    
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: List.generate(remainingItems.length, (index) {
        return _buildLetterBubble(remainingItems[index], index);
      }),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
  }


  Widget _buildAssemblyPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant, width: 2),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(_targetWord.length, (index) {
            bool hasLetter = index < _assembledLetters.length;
            return DragTarget<_LetterItem>(
              onWillAcceptWithDetails: (details) => !hasLetter && !details.data.isEliminated && !_isFinished,
              onAcceptWithDetails: (details) => _placeLetterInSlot(details.data, index),
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;
                return AnimatedContainer(
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: hasLetter 
                        ? AppColors.surfaceVariant 
                        : (isHovering ? AppColors.surfaceVariant.withValues(alpha: 0.8) : AppColors.surfaceVariant.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasLetter 
                          ? Colors.white 
                          : (isHovering ? Colors.white : AppColors.outlineVariant),
                      width: isHovering || hasLetter ? 3 : 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      hasLetter ? _assembledLetters[index] : "",
                      style: GoogleFonts.cairo(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ).animate(target: hasLetter ? 1 : 0)
             .scale(curve: Curves.easeOutBack, duration: 500.ms);
          }),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildLetterBubble(_LetterItem item, int index) {
    bool isInactive = item.isSelectedInAssembly;
    bool isEliminated = item.isEliminated;
    
    Widget bubble = PremiumTactileBubble(
      text: item.letter,
      isSelected: isInactive,
      isWrong: isEliminated && !_isEliminationDone,
      isCorrect: isEliminated && _isEliminationDone,
      size: 70,
      onTap: () => _onLetterClick(item),
    );

    if (isEliminated) {
      bubble = Stack(
        alignment: Alignment.center,
        children: [
          bubble,
          Icon(Icons.close, color: Colors.white.withValues(alpha: 0.5), size: 40)
            .animate().scale(curve: Curves.elasticOut, duration: 600.ms),
        ],
      );
    }

    return Draggable<_LetterItem>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.9,
          child: Transform.scale(scale: 1.1, child: bubble),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: bubble),
      maxSimultaneousDrags: (_isEliminationDone && !item.isSelectedInAssembly && !item.isEliminated && !_isFinished) ? 1 : 0,
      child: bubble,
    ).animate()
     .scale(begin: Offset.zero, end: const Offset(1, 1), curve: Curves.easeOutBack, duration: 600.ms + (index * 60).ms);
  }

}

class _LetterItem {
  final String letter;
  final bool isDistractor;
  bool isEliminated;
  bool isSelectedInAssembly;

  _LetterItem({
    required this.letter,
    required this.isDistractor,
    this.isEliminated = false,
    this.isSelectedInAssembly = false,
  });
}


