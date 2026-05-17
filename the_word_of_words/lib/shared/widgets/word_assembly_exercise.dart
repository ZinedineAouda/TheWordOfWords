import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/game_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/tts_feedback_service.dart';
import 'premium_ui_widgets.dart';
import 'dart:math' as math;

class WordAssemblyExercise extends StatefulWidget {
  final Exercise exercise;
  final Function(ExerciseResult) onComplete;
  final bool isLast;

  const WordAssemblyExercise({
    super.key,
    required this.exercise,
    required this.onComplete,
    this.isLast = false,
  });

  @override
  State<WordAssemblyExercise> createState() => _WordAssemblyExerciseState();
}

class _WordAssemblyExerciseState extends State<WordAssemblyExercise> with SingleTickerProviderStateMixin {
  int _currentLetterIndex = 0;
  final List<String> _assembledLetters = [];
  bool _isFinished = false;
  bool _isSplitting = true;
  String _successPhrase = '';
  late DateTime _startTime;
  
  late String _fullWord;
  late List<String> _letters;
  late List<String> _shuffledOptions;
  
  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _fullWord = widget.exercise.correctAnswer;
    _letters = _fullWord.split('');
    _initializeOptions();
    
    // Start splitting animation after a short delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        // Speak the word at the start for memory reinforcement
        TtsFeedbackService().speak(_fullWord);
        
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _isSplitting = false;
            });
          }
        });
      }
    });
  }

  void _initializeOptions() {
    // Generate options once to avoid shuffling on every rebuild
    List<String> pool = List<String>.from(widget.exercise.options);
    if (pool.length < 4) {
      pool.addAll(["ل", "د", "أ", "م", "ن", "س"]);
    }
    
    Set<String> optionsSet = { ..._letters };
    final random = math.Random();
    while (optionsSet.length < math.max(6, _letters.length + 2)) {
      optionsSet.add(pool[random.nextInt(pool.length)]);
    }
    
    _shuffledOptions = optionsSet.toList();
    _shuffledOptions.shuffle();
  }

  @override
  void didUpdateWidget(WordAssemblyExercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _resetExercise();
    }
  }

  void _resetExercise() {
    _currentLetterIndex = 0;
    _assembledLetters.clear();
    _isFinished = false;
    _isSplitting = true;
    _startTime = DateTime.now();
    _fullWord = widget.exercise.correctAnswer;
    _letters = _fullWord.split('');
    _initializeOptions();
    
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _isSplitting = false;
        });
      }
    });
  }

  void _handleLetterSelect(String selectedLetter) async {
    if (_isFinished || _isSplitting) return;

    final targetLetter = _letters[_currentLetterIndex];

    if (selectedLetter == targetLetter) {
      // Speak the letter name correctly
      TtsFeedbackService().speak(selectedLetter);

      setState(() {
        _assembledLetters.add(selectedLetter);
        if (_currentLetterIndex < _letters.length - 1) {
          _currentLetterIndex++;
        } else {
          _isFinished = true;
          _handleCompletion();
        }
      });
    } else {
      // Wrong letter
      TtsFeedbackService().onWrong();
    }
  }

  void _handleCompletion() async {
    // 1. Speak the full word again
    await TtsFeedbackService().speak(_fullWord);
    
    // 2. Speak the success phrase
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image Hint - Made Flexible to adapt to screen size
        if (widget.exercise.imageAsset != null)
          Flexible(
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
                  child: Image.asset(widget.exercise.imageAsset!, fit: BoxFit.contain),
                ),
              ),
            ),
          ).animate().fadeIn().scale(curve: Curves.easeOutBack, duration: 600.ms),

        // Main interaction board
        Expanded(
          flex: 4,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: _isSplitting 
                ? _buildSplittingView() 
                : _isFinished 
                ? _buildMergingView() 
                : _buildPlayView(),
            ),
          ),
        ),
        
        // Options Area
        if (!_isSplitting && !_isFinished)
          Flexible(
            flex: 3,
            child: _buildOptionsArea()
            .animate()
            .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic, duration: 600.ms)
            .fadeIn(),
          ),
          
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSplittingView() {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          key: const ValueKey('splitting'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.outlineVariant, width: 2),
              ),
              child: Text(
                "تذكر هذه الكلمة",
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
              ),
            ).animate().fadeIn().slideY(begin: -0.2),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.outlineVariant, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _letters.map((l) {
                  return Text(
                    l,
                    style: GoogleFonts.cairo(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                    ),
                  ).animate()
                   .fadeOut(delay: 1.5.seconds, duration: 400.ms)
                   .slideY(begin: 0, end: 1.5, delay: 1.5.seconds, duration: 400.ms)
                   .scale(begin: const Offset(1, 1), end: const Offset(0.5, 0.5), delay: 1.5.seconds);
                }).toList(),
              ),
            ).animate().scale(curve: Curves.easeOutBack),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayView() {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          key: const ValueKey('play'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "رتب الحروف بالترتيب الصحيح",
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.onSurface,
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_letters.length, (index) {
                bool isFilled = index < _assembledLetters.length;
                bool isCurrent = index == _currentLetterIndex;
                String letter = isFilled ? _assembledLetters[index] : "";
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildTargetSlot(letter, isFilled, isCurrent),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetSlot(String letter, bool isFilled, bool isCurrent) {
    return Container(
      width: 70,
      height: 90,
      decoration: BoxDecoration(
        color: isFilled ? Colors.green.withValues(alpha: 0.1) : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrent 
            ? AppColors.primary 
            : (isFilled ? Colors.green : AppColors.outlineVariant),
          width: 3,
        ),
      ),
      child: Center(
        child: Text(
          letter,
          style: GoogleFonts.cairo(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            color: isFilled ? Colors.green : AppColors.onSurface,
          ),
        ),
      ),
    ).animate(target: isFilled ? 1 : 0)
     .scale(duration: 400.ms, curve: Curves.elasticOut);
  }

  Widget _buildMergingView() {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          key: const ValueKey('merging'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: AppColors.outlineVariant, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _letters.map((l) {
                  return Text(
                    l,
                    style: GoogleFonts.cairo(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                    ),
                  ).animate()
                   .fadeIn(duration: 400.ms)
                   .scale(begin: const Offset(0, 0), end: const Offset(1, 1), curve: Curves.easeOutBack);
                }).toList(),
              ),
            ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
            
            const SizedBox(height: 40),
            
            PremiumSuccessBadge(message: _successPhrase),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsArea() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FittedBox(
          fit: BoxFit.contain,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: _shuffledOptions.asMap().entries.map((entry) {
                final letter = entry.value;
                final index = entry.key;
                
                return PremiumTactileBubble(
                  text: letter,
                  onTap: () => _handleLetterSelect(letter),
                  size: 75,
                ).animate()
                 .fadeIn(delay: (index * 50).ms)
                 .scale(delay: (index * 50).ms, curve: Curves.easeOutBack);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

}

