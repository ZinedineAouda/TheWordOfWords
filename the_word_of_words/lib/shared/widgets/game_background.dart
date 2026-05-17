import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/game_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GameBackground extends StatelessWidget {
  final Widget child;
  final bool showParticles;
  final String? backgroundImage;
  final double backgroundOpacity;

  const GameBackground({
    super.key,
    required this.child,
    this.showParticles = true,
    this.backgroundImage,
    this.backgroundOpacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final currentTheme = game.currentTheme;
    final worldColor = game.currentWorld?.themeColor;
    
    String? resolvedBg;
    if (backgroundImage != null) {
      resolvedBg = backgroundImage;
    } else if (currentTheme == 'forest') {
      resolvedBg = 'assets/images/theme_forest_bg.png';
    } else if (currentTheme == 'ocean') {
      resolvedBg = 'assets/images/theme_ocean_bg.png';
    } else if (currentTheme == 'space') {
      resolvedBg = 'assets/images/theme_space_bg.png';
    } else if (currentTheme == 'candy') {
      resolvedBg = 'assets/images/theme_candy_bg.png';
    }
    
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          _buildGradient(currentTheme, worldColor),
          if (resolvedBg != null)
            Opacity(
              opacity: backgroundOpacity,
              child: Image.asset(
                resolvedBg,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          if (showParticles) ..._buildDecorativeElements(currentTheme),
          child,
        ],
      ),
    );
  }

  Widget _buildGradient(String themeId, Color? worldColor) {
    List<Color> colors;

    switch (themeId) {
      case 'forest':
        colors = [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9), const Color(0xFFA5D6A7)];
        break;
      case 'ocean':
        colors = [const Color(0xFFE1F5FE), const Color(0xFFB3E5FC), const Color(0xFF81D4FA)];
        break;
      case 'sunset':
        colors = [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2), const Color(0xFFFFCC80)];
        break;
      case 'starry':
        colors = [const Color(0xFF1A237E), const Color(0xFF0D47A1), const Color(0xFF01579B)];
        break;
      case 'candy':
        colors = [const Color(0xFFFCE4EC), const Color(0xFFF8BBD0), const Color(0xFFF48FB1)];
        break;
      case 'space':
        colors = [const Color(0xFF311B92), const Color(0xFF1A237E), const Color(0xFF0D47A1)];
        break;
      case 'lava':
        colors = [const Color(0xFF3E2723), const Color(0xFFBF360C), const Color(0xFFE64A19)];
        break;
      case 'jungle':
        colors = [const Color(0xFF1B5E20), const Color(0xFF2E7D32), const Color(0xFF388E3C)];
        break;
      case 'neon':
        colors = [const Color(0xFF121212), const Color(0xFF1B5E20), const Color(0xFF00C853)];
        break;
      case 'pastel':
        colors = [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7), const Color(0xFFCE93D8)];
        break;
      case 'midnight':
        colors = [const Color(0xFF263238), const Color(0xFF212121), const Color(0xFF121212)];
        break;
      default:
        if (worldColor != null) {
          colors = [
            worldColor.withValues(alpha: 0.2),
            worldColor.withValues(alpha: 0.1),
            worldColor.withValues(alpha: 0.05),
          ];
        } else {
          colors = [const Color(0xFFF0F9FF), const Color(0xFFE0F2FE), const Color(0xFFBAE6FD)];
        }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
    );
  }

  List<Widget> _buildDecorativeElements(String themeId) {
    Color bubbleColor = Colors.white.withValues(alpha: 0.2);
    
    switch (themeId) {
      case 'starry':
      case 'space':
      case 'midnight':
        bubbleColor = Colors.white.withValues(alpha: 0.08);
        break;
      case 'lava':
        bubbleColor = Colors.orange.withValues(alpha: 0.15);
        break;
      case 'neon':
        bubbleColor = Colors.lime.withValues(alpha: 0.1);
        break;
      case 'candy':
        bubbleColor = Colors.pink.withValues(alpha: 0.15);
        break;
      case 'forest':
      case 'jungle':
        bubbleColor = Colors.green.withValues(alpha: 0.1);
        break;
    }

    return [
      _PositionedBubble(top: -50, left: -50, size: 200, color: bubbleColor),
      _PositionedBubble(bottom: 100, right: -30, size: 150, color: bubbleColor),
      _PositionedBubble(top: 200, left: 150, size: 80, color: bubbleColor),
      _PositionedBubble(bottom: -20, left: 20, size: 120, color: bubbleColor),
    ];
  }
}

class _PositionedBubble extends StatelessWidget {
  final double? top, bottom, left, right;
  final double size;
  final Color color;

  const _PositionedBubble({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      )
      .animate(onPlay: (controller) => controller.repeat(reverse: true))
      .moveY(begin: -20, end: 20, duration: 3.seconds + (size.toInt() * 10).ms, curve: Curves.easeInOutSine)
      .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 4.seconds),
    );
  }
}
