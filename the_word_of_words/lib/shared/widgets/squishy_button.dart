import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SquishyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? color;
  final Color? depthColor;
  final double borderRadius;
  final double depth;

  const SquishyButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color,
    this.depthColor,
    this.borderRadius = 9999,
    this.depth = 4.0,
  });

  @override
  State<SquishyButton> createState() => _SquishyButtonState();
}

class _SquishyButtonState extends State<SquishyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    final depthColor = widget.depthColor ?? 
        (widget.color == AppColors.primary ? AppColors.primaryDepth :
         widget.color == AppColors.secondary ? AppColors.secondaryDepth :
         widget.color == AppColors.tertiary ? AppColors.tertiaryDepth :
         color.withValues(alpha: 0.8));

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final topPadding = _controller.value * widget.depth;
          
          return Stack(
            children: [
              // The Depth Layer
              Container(
                height: 56 + widget.depth,
                decoration: BoxDecoration(
                  color: depthColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
              ),
              // The Main Layer
              Transform.translate(
                offset: Offset(0, topPadding),
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color.withValues(alpha: 0.9),
                        color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 0,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Subtle Gloss
                      Positioned(
                        top: 2,
                        left: 10,
                        right: 10,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.3),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                          ),
                        ),
                      ),
                      Center(
                        child: DefaultTextStyle(
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: widget.child,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
