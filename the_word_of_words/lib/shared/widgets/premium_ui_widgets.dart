import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/game_provider.dart';

import 'package:go_router/go_router.dart';
import 'coin_particles.dart';


class PremiumTactileBubble extends StatelessWidget {
  final String text;
  final bool isCorrect;
  final bool isWrong;
  final bool isDragging;
  final bool isSelected;
  final VoidCallback? onTap;
  final double size;
  final double fontSize;
  final Color? baseColor;
  final Color? textColor;

  const PremiumTactileBubble({
    super.key,
    required this.text,
    this.isCorrect = false,
    this.isWrong = false,
    this.isDragging = false,
    this.isSelected = false,
    this.onTap,
    this.size = 90,
    this.fontSize = 40,
    this.baseColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = baseColor ?? AppColors.surfaceContainer;
    Color borderCol = AppColors.outlineVariant;
    Color textCol = textColor ?? AppColors.onSurface;

    if (isCorrect) {
      bg = Colors.green.shade100;
      borderCol = Colors.green.shade400;
      textCol = Colors.green.shade900;
    } else if (isWrong) {
      bg = Colors.red.shade100;
      borderCol = Colors.red.shade400;
      textCol = Colors.red.shade900;
    } else if (isSelected) {
      bg = AppColors.primaryContainer.withValues(alpha: 0.3);
      borderCol = AppColors.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(size * 0.25),
          border: Border.all(
            color: borderCol,
            width: 3.0,
          ),
          boxShadow: [
            if (!isDragging && !isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 4),
                blurRadius: 4,
              ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: textCol,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    ).animate(target: isWrong ? 1 : 0).shake(hz: 10, offset: const Offset(6, 0), duration: 400.ms)
     .animate(target: isCorrect ? 1 : 0).scale(end: const Offset(1.1, 1.1), curve: Curves.elasticOut, duration: 600.ms);
  }
}


class PremiumNavButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color? color;
  final double size;

  const PremiumNavButton({
    super.key,
    this.onTap,
    this.icon = Icons.arrow_back_ios_new_rounded,
    this.color,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumClickEffect(
      onTap: onTap ?? () {
        if (context.canPop()) {
          context.pop();
        }
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? AppColors.surfaceVariant,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: AppColors.onSurface,
            size: size * 0.45,
          ),
        ),
      ),
    );
  }
}

class PremiumSuccessBadge extends StatelessWidget {
  final String message;

  const PremiumSuccessBadge({
    super.key,
    this.message = '',
  });

  @override
  Widget build(BuildContext context) {
    // Fall back to default if empty string passed before TTS resolves
    final displayText = message.isEmpty ? 'أحسنت!' : message;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.stars, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                displayText,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(curve: Curves.elasticOut, duration: 800.ms);
  }
}

class PremiumTactileButton extends StatelessWidget {
  final String text;
  final bool isCorrect;
  final bool isWrong;
  final bool isSelected;
  final VoidCallback? onTap;
  final double height;
  final double? width;
  final double fontSize;
  final Color? baseColor;
  final Color? textColor;

  const PremiumTactileButton({
    super.key,
    required this.text,
    this.isCorrect = false,
    this.isWrong = false,
    this.isSelected = false,
    this.onTap,
    this.height = 64,
    this.width,
    this.fontSize = 20,
    this.baseColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = baseColor ?? AppColors.surfaceContainer;
    Color borderCol = AppColors.outlineVariant;
    Color textCol = textColor ?? AppColors.onSurface;

    if (isCorrect) {
      bg = Colors.green.shade100;
      borderCol = Colors.green;
    } else if (isWrong) {
      bg = Colors.red.shade100;
      borderCol = Colors.red;
    } else if (isSelected) {
      bg = AppColors.primaryContainer.withValues(alpha: 0.2);
      borderCol = AppColors.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderCol,
            width: 2.0,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 4),
                blurRadius: 4,
              ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: textCol,
            ),
          ),
        ),
      ),
    ).animate(target: isWrong ? 1 : 0).shake(hz: 10, offset: const Offset(6, 0), duration: 400.ms)
     .animate(target: isCorrect ? 1 : 0).scale(end: const Offset(1.05, 1.05), curve: Curves.elasticOut, duration: 600.ms);
  }
}

class PremiumCoinBalance extends StatefulWidget {
  final int coins;
  const PremiumCoinBalance({super.key, required this.coins});

  @override
  State<PremiumCoinBalance> createState() => _PremiumCoinBalanceState();
}

class _PremiumCoinBalanceState extends State<PremiumCoinBalance> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _displayCoins;

  @override
  void initState() {
    super.initState();
    _displayCoins = widget.coins;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void didUpdateWidget(PremiumCoinBalance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.coins != oldWidget.coins) {
      _controller.forward(from: 0);
      setState(() {
        _displayCoins = widget.coins;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;
        final center = Offset(position.dx + size.width / 2, position.dy + size.height / 2);
        
        CoinParticleOverlay.of(context)?.spawnParticles(center, count: 5);
        _controller.forward(from: 0);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade400,
              Colors.orange.shade700,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.monetization_on, color: Colors.white, size: 24)
                .animate(controller: _controller, autoPlay: false)
                .scale(
                  begin: const Offset(1.0, 1.0), 
                  end: const Offset(1.4, 1.4), 
                  duration: 300.ms, 
                  curve: Curves.easeOutBack
                )
                .then(delay: 100.ms)
                .scale(
                  begin: const Offset(1.4, 1.4), 
                  end: const Offset(1.0, 1.0), 
                  duration: 300.ms
                ),
            const SizedBox(width: 8),
            Text(
              "$_displayCoins",
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2000.ms, color: Colors.white.withValues(alpha: 0.4)),
    );
  }
}

class PremiumClickEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const PremiumClickEffect({super.key, required this.child, this.onTap});

  @override
  State<PremiumClickEffect> createState() => _PremiumClickEffectState();
}

class _PremiumClickEffectState extends State<PremiumClickEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerEffect(Offset globalPosition) {
    final game = Provider.of<GameProvider>(context, listen: false);
    final effect = game.currentClickEffect;
    
    if (effect == 'default') return;

    IconData icon = Icons.star;
    Color color = Colors.yellow;

    switch (effect) {
      case 'stars':
        icon = Icons.star;
        color = Colors.yellow;
        break;
      case 'bubbles':
        icon = Icons.blur_on;
        color = Colors.cyan.withValues(alpha: 0.6);
        break;
      case 'hearts':
        icon = Icons.favorite;
        color = Colors.red;
        break;
      case 'magic':
        icon = Icons.auto_fix_high;
        color = Colors.purpleAccent;
        break;
    }

    CoinParticleOverlay.of(context)?.spawnParticles(
      globalPosition,
      count: 6,
      icon: icon,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _controller.forward();
        _triggerEffect(details.globalPosition);
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
