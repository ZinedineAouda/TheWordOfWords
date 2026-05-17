import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/providers/game_provider.dart';
import '../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/widgets/squishy_button.dart';
import '../shared/widgets/game_background.dart';
import '../shared/widgets/premium_ui_widgets.dart';
import '../core/services/tts_feedback_service.dart';
import '../shared/widgets/profile_avatar.dart';

class WinScreen extends StatefulWidget {
  const WinScreen({super.key});

  @override
  State<WinScreen> createState() => _WinScreenState();
}

class _WinScreenState extends State<WinScreen> {
  late String _randomPhrase;

  @override
  void initState() {
    super.initState();
    _randomPhrase = TtsFeedbackService().getRandomEncouragement();
    _playWinSound();
  }

  Future<void> _playWinSound() async {
    // Audio is handled by the navigation extra or the exercise complete logic
    // But if we want a dedicated win sound/phrase here, we can keep it.
    // To avoid double speaking, we check if title is already spoken.
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final int starsEarned = extra?['stars'] ?? 0;
    final int coinsEarned = extra?['coins'] ?? 0;
    
    final String passedTitle = extra?['title'] ?? '';
    
    // Use the passed title if available, otherwise fallback to the random phrase
    final String title = passedTitle.isNotEmpty ? passedTitle : _randomPhrase;

    return Consumer<GameProvider>(
      builder: (context, game, child) {
        return Scaffold(
          body: GameBackground(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(context, game),
                    Expanded(
                      child: Stack(
                        children: [
                          // Confetti Background
                          ..._buildConfetti(),
                          // Main Content
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildCelebrationCard(context, starsEarned, coinsEarned, title),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildAppBar(BuildContext context, GameProvider game) {
    return Padding(
      padding: const EdgeInsets.all(20),
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
                PremiumNavButton(
                  onTap: () => context.go('/game-hub'),
                  icon: Icons.close,
                ),
                Text(
                  'النتائج',
                  style: GoogleFonts.cairo(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                Row(
                  children: [
                    _buildCurrencyChip(context, Icons.stars, Colors.amber, game.stars.toString()),
                    const SizedBox(width: 8),
                    _buildCurrencyChip(context, Icons.monetization_on, Colors.orange, game.coins.toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyChip(BuildContext context, IconData icon, Color color, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.cairo(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildConfetti() {
    final colors = [
      AppColors.secondaryContainer,
      AppColors.tertiaryContainer,
      AppColors.primaryContainer,
      AppColors.errorContainer,
      AppColors.secondaryFixed,
    ];
    
    return List.generate(15, (index) {
      final size = 10.0 + (index % 3) * 5.0;
      final top = (index * 60.0) % 600.0;
      final left = (index * 80.0) % 400.0;
      final color = colors[index % colors.length];
      
      return Positioned(
        top: top,
        left: left,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.6),
            shape: index % 2 == 0 ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: index % 2 != 0 ? BorderRadius.circular(4) : null,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
          .moveY(begin: 0, end: 100, duration: (2 + (index % 3)).seconds, curve: Curves.easeInOut)
          .rotate(begin: 0, end: 1, duration: 3.seconds)
          .fadeOut(delay: 1.seconds),
      );
    });
  }

  Widget _buildCelebrationCard(BuildContext context, int stars, int coins, String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(48),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(48),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Current Hero / Profile Pic
          ProfileAvatar(size: 120),
          const SizedBox(height: 24),
          // Stars display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final active = index < stars;
              return Icon(
                active ? Icons.star : Icons.star_border,
                color: active ? Colors.amber : AppColors.onSurfaceVariant.withValues(alpha: 0.1),
                size: index == 1 ? 80 : 60,
              ).animate().scale(delay: (index * 200).ms, curve: Curves.easeOutBack);
            }),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.cairo(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Reward pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.outlineVariant, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on, color: Colors.orange, size: 28),
                const SizedBox(width: 12),
                Text(
                  '+$coins عملات',
                  style: GoogleFonts.cairo(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          // Actions
          SquishyButton(
            onPressed: () => context.go('/world-map'),
            color: Colors.orange,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_forward, color: Colors.white),
                    const SizedBox(width: 12),
                    Text('العودة للخريطة', style: GoogleFonts.cairo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SquishyButton(
            onPressed: () => context.go('/'),
            color: AppColors.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, color: AppColors.onSurface),
                    const SizedBox(width: 12),
                    Text('الرئيسية', style: GoogleFonts.cairo(color: AppColors.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
).animate().scale(curve: Curves.easeOutBack, duration: 600.ms);
}
}

