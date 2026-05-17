import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/providers/game_provider.dart';
import '../core/theme/app_colors.dart';
import '../shared/widgets/game_background.dart';
import '../shared/widgets/premium_ui_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        final world = game.currentWorld;
        if (world == null) {
          return _buildErrorState(context);
        }

        return GameBackground(
          backgroundImage: 'assets/images/world_map_bg.png',
          backgroundOpacity: 0.8,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(context, world, game),
                    Expanded(
                      child: _buildMapContent(context, world, game),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'العالم غير موجود',
              style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/game-hub'),
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, dynamic world, GameProvider game) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const PremiumNavButton(),
                    const SizedBox(width: 12),
                    Text(
                      world.title,
                      style: GoogleFonts.cairo(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildCurrencyChip(Icons.stars_rounded, Colors.amber, game.stars.toString()),
                    const SizedBox(width: 8),
                    _buildCurrencyChip(Icons.monetization_on_rounded, Colors.orange, game.coins.toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().slideY(begin: -0.2).fadeIn();
  }

  Widget _buildCurrencyChip(IconData icon, Color color, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.w900, 
              fontSize: 14,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapContent(BuildContext context, dynamic world, GameProvider game) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final int levelCount = world.levels.length;

        // Calculate positions dynamically to fit any number of levels within the screen height
        // We'll use a zig-zag pattern from bottom to top
        final List<Offset> levelCoords = List.generate(levelCount, (index) {
          // Bottom to top: index 0 is at the bottom, index levelCount-1 is at the top
          double yPos = 0.85 - (index * (0.75 / (levelCount > 1 ? levelCount - 1 : 1)));
          double xPos = (index % 2 == 0) ? 0.25 : 0.75;
          return Offset(xPos, yPos);
        });

        return Stack(
          children: [
            CustomPaint(
              size: Size(width, height),
              painter: MapPathPainter(coords: levelCoords),
            ),
            ...List.generate(levelCount, (index) {
              final level = world.levels[index];
              final isLocked = level.isLocked;
              final stars = level.starsEarned;
              final pos = levelCoords[index];
              
              return Positioned(
                left: width * pos.dx - 50,
                top: height * pos.dy - 50,
                child: _buildLevelNode(context, index, level, isLocked, stars, game),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildLevelNode(BuildContext context, int index, dynamic level, bool isLocked, int stars, GameProvider game) {
    String? previewImage;
    if (level.exercises != null && level.exercises.isNotEmpty) {
      for (var ex in level.exercises) {
        if (ex.imageAsset != null && ex.imageAsset.isNotEmpty) {
          previewImage = ex.imageAsset;
          break;
        }
      }
    }

    final double progress = stars / 3.0;

    return Column(
      children: [
        GestureDetector(
          onTap: isLocked ? null : () {
            game.selectLevel(level.id);
            context.push('/game-play');
          },
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (!isLocked)
                SizedBox(
                  width: 96,
                  height: 96,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  ),
                ),
                
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isLocked ? AppColors.outline : AppColors.primary,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: isLocked
                      ? Icon(Icons.lock, color: AppColors.onSurface.withValues(alpha: 0.3), size: 32)
                      : (previewImage != null)
                          ? Image.asset(
                              previewImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildFallbackText(level, index, isLocked),
                            )
                          : _buildFallbackText(level, index, isLocked),
                ),
              ),

              if (!isLocked)
                Positioned(
                  bottom: -12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (sIndex) {
                        return Icon(
                          Icons.star,
                          size: 14,
                          color: sIndex < stars ? Colors.amber : Colors.grey.shade300,
                        ).animate(delay: (sIndex * 100).ms).scale(curve: Curves.easeOutBack);
                      }),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant, width: 1.5),
          ),
          child: Text(
            level.title,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isLocked ? AppColors.onSurface.withValues(alpha: 0.5) : AppColors.onSurface,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.2);
  }

  Widget _buildFallbackText(dynamic level, int index, bool isLocked) {
    return Center(
      child: Text(
        () {
          String title = level.title;
          if (title.startsWith('ال') && title.length > 2) {
            return title[2];
          }
          return title.isNotEmpty ? title[0] : '${index + 1}';
        }(),
        style: GoogleFonts.cairo(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: isLocked ? AppColors.onSurface.withValues(alpha: 0.2) : AppColors.onSurface,
        ),
      ),
    );
  }
}

class MapPathPainter extends CustomPainter {
  final List<Offset> coords;

  MapPathPainter({required this.coords});

  @override
  void paint(Canvas canvas, Size size) {
    if (coords.length < 2) return;
    
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final dashPath = Path();
    for (int i = 0; i < coords.length - 1; i++) {
      final p1 = Offset(size.width * coords[i].dx, size.height * coords[i].dy);
      final p2 = Offset(size.width * coords[i+1].dx, size.height * coords[i+1].dy);
      
      dashPath.moveTo(p1.dx, p1.dy);
      final controlX = (p1.dx + p2.dx) / 2;
      final controlY = (p1.dy + p2.dy) / 2;
      dashPath.quadraticBezierTo(controlX, controlY, p2.dx, p2.dy);
    }
    _drawDashedPath(canvas, dashPath, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 8.0;
    double distance = 0.0;
    for (var measure in path.computeMetrics()) {
      while (distance < measure.length) {
        final length = dashWidth;
        if (distance + length > measure.length) break;
        canvas.drawPath(
          measure.extractPath(distance, distance + length),
          paint,
        );
        distance += length + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
