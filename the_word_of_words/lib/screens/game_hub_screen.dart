import '../core/providers/game_provider.dart';

import '../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/premium_ui_widgets.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/widgets/game_background.dart';

class GameHubScreen extends StatefulWidget {
  const GameHubScreen({super.key});

  @override
  State<GameHubScreen> createState() => _GameHubScreenState();
}

class _GameHubScreenState extends State<GameHubScreen> {
  bool _showForceStart = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showForceStart = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/world_map_bg.png',
      backgroundOpacity: 0.4,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Column(
              children: [
                Consumer<GameProvider>(
                  builder: (context, game, child) => _buildAppBar(context, game),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: Column(
                    children: [
                      Text(
                        'خريطة العوالم',
                        style: GoogleFonts.cairo(
                          fontSize: 32,
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w900,
                        ),
                      ).animate().fadeIn().slideY(begin: -0.2),
                      Text(
                        'اختر العالم الذي تريد استكشافه',
                        style: GoogleFonts.cairo(
                          fontSize: 16, 
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildWorldsMap(context),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(context),
        extendBody: true,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, GameProvider game) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const PremiumNavButton(),
                const SizedBox(width: 12),
                Text(
                  'عالم الاكتشاف',
                  style: GoogleFonts.cairo(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
    );
  }

  Widget _buildCurrencyChip(IconData icon, Color color, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 1),
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

  Widget _buildWorldsMap(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        if (game.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 16),
                Text('جاري تحميل العوالم...', style: GoogleFonts.cairo(color: Colors.white)),
                if (_showForceStart) ...[
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => game.forceStopLoading(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('دخول سريع', style: GoogleFonts.cairo()),
                  ),
                ],
              ],
            ),
          );
        }

        if (game.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'حدث خطأ في تحميل البيانات',
                      style: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      game.error!,
                      style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => game.init(),
                      child: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
                    ),
                  ],
                ),
              );
            }

            if (game.worlds.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد عوالم متاحة حالياً',
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;

                final List<Offset> worldCoords = [
                  const Offset(0.25, 0.85),
                  const Offset(0.75, 0.70),
                  const Offset(0.25, 0.55),
                  const Offset(0.75, 0.40),
                  const Offset(0.25, 0.25),
                ];

            return Stack(
              children: [
                CustomPaint(
                  size: Size(width, height),
                  painter: WorldPathPainter(
                    coords: worldCoords,
                    unlockedCount: game.worlds.where((w) => !w.isLocked).length,
                  ),
                ),

                ...game.worlds.asMap().entries.map((entry) {
                  int index = entry.key;
                  final worldObj = entry.value;
                  if (index >= worldCoords.length) return const SizedBox.shrink();
                  final pos = worldCoords[index];
                  
                  int totalLevels = worldObj.levels.length;
                  int completedLevels = worldObj.levels.where((l) => l.starsEarned > 0).length;
                  double progress = totalLevels > 0 ? completedLevels / totalLevels : 0;

                  return Positioned(
                    left: width * pos.dx - 60,
                    top: height * pos.dy - 60,
                    child: _WorldNode(
                      world: worldObj,
                      progress: progress,
                      onTap: () {
                        game.selectWorld(worldObj.id);
                        context.push('/world-map');
                      },
                    ).animate().scale(
                      delay: (index * 150).ms,
                      curve: Curves.easeOutBack,
                      duration: 600.ms,
                    ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, 'الرئيسية', Icons.home, false, () => context.go('/')),
            _buildNavItem(context, 'الألعاب', Icons.sports_esports, true, () {}),
            _buildNavItem(context, 'المتجر', Icons.shopping_bag, false, () => context.push('/shop')),
            _buildNavItem(context, 'إنجازاتي', Icons.emoji_events, false, () => context.push('/achievements')),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, IconData icon, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? AppColors.primary : AppColors.onSurfaceVariant, size: 26),
            Text(
              label,
              style: GoogleFonts.cairo(
                color: active ? AppColors.primary : AppColors.onSurfaceVariant,
                fontSize: 10,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorldNode extends StatelessWidget {
  final dynamic world;
  final double progress;
  final VoidCallback onTap;

  const _WorldNode({
    required this.world,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLocked = world.isLocked;
    final Color color = world.themeColor;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (!isLocked)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ).animate(onPlay: (c) => c.repeat()).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 2.seconds,
                  curve: Curves.easeInOut,
                ),
              
              Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLocked ? AppColors.surfaceContainer.withValues(alpha: 0.8) : AppColors.surfaceContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isLocked ? AppColors.outlineVariant.withValues(alpha: 0.3) : color.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    if (!isLocked)
                      BoxShadow(
                        color: color.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                child: Image.asset(
                  world.iconAsset,
                  color: isLocked ? Colors.white24 : null,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.public,
                    size: 40,
                    color: isLocked ? Colors.white24 : color,
                  ),
                ),
              ),

              if (isLocked)
                const Icon(Icons.lock, color: Colors.white54, size: 32),

              if (!isLocked)
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: GoogleFonts.cairo(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 1),
            ),
            child: Text(
              world.title,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isLocked ? AppColors.onSurfaceVariant.withValues(alpha: 0.5) : AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class WorldPathPainter extends CustomPainter {
  final List<Offset> coords;
  final int unlockedCount;

  WorldPathPainter({required this.coords, required this.unlockedCount});

  @override
  void paint(Canvas canvas, Size size) {
    if (coords.length < 2) return;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < coords.length - 1; i++) {
      final p1 = Offset(size.width * coords[i].dx, size.height * coords[i].dy);
      final p2 = Offset(size.width * coords[i+1].dx, size.height * coords[i+1].dy);
      final isPathUnlocked = i < unlockedCount - 1;
      paint.color = isPathUnlocked ? Colors.white38 : Colors.white10;
      _drawDashedLine(canvas, p1, p2, paint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 8.0;
    double totalDistance = (p2 - p1).distance;
    Offset direction = (p2 - p1) / totalDistance;
    double currentDistance = 0;
    while (currentDistance < totalDistance) {
      canvas.drawLine(
        p1 + direction * currentDistance,
        p1 + direction * (currentDistance + dashWidth > totalDistance ? totalDistance : currentDistance + dashWidth),
        paint,
      );
      currentDistance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
