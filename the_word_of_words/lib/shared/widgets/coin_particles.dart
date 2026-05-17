import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

class CoinParticleOverlay extends StatefulWidget {
  final Widget child;
  const CoinParticleOverlay({super.key, required this.child});

  static _CoinParticleOverlayState? of(BuildContext context) {
    return context.findAncestorStateOfType<_CoinParticleOverlayState>();
  }

  @override
  State<CoinParticleOverlay> createState() => _CoinParticleOverlayState();
}

class _CoinParticleOverlayState extends State<CoinParticleOverlay> {
  final List<Widget> _particles = [];

  void spawnParticles(Offset startPosition, {int count = 10, IconData icon = Icons.monetization_on, Color color = Colors.amber}) {
    setState(() {
      for (int i = 0; i < count; i++) {
        _particles.add(
          _CoinParticle(
            key: UniqueKey(),
            startPosition: startPosition,
            icon: icon,
            color: color,
            onComplete: (particle) {
              setState(() {
                _particles.remove(particle);
              });
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ..._particles,
      ],
    );
  }
}

class _CoinParticle extends StatelessWidget {
  final Offset startPosition;
  final IconData icon;
  final Color color;
  final Function(Widget) onComplete;

  const _CoinParticle({
    super.key,
    required this.startPosition,
    required this.icon,
    required this.color,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final random = math.Random();
    final angle = random.nextDouble() * 2 * math.pi;
    final distance = 50 + random.nextDouble() * 100;
    final endPosition = Offset(
      startPosition.dx + math.cos(angle) * distance,
      startPosition.dy + math.sin(angle) * distance,
    );

    return Positioned(
      left: startPosition.dx,
      top: startPosition.dy,
      child: Icon(icon, color: color, size: 24)
          .animate(onComplete: (_) => onComplete(this))
          .move(
            begin: Offset.zero,
            end: endPosition - startPosition,
            duration: 600.ms,
            curve: Curves.easeOutCubic,
          )
          .fadeOut(delay: 400.ms, duration: 200.ms)
          .scale(begin: const Offset(0.2, 0.2), end: const Offset(1, 1), duration: 200.ms),
    );
  }
}
