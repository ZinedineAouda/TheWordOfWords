import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/providers/game_provider.dart';
import '../core/theme/app_colors.dart';
import '../shared/widgets/premium_ui_widgets.dart';
import '../shared/widgets/game_background.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int reward;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.reward,
  });
}

class AchievementsScreen extends StatelessWidget {
  AchievementsScreen({super.key});

  final List<Achievement> achievements = [
    Achievement(
      id: 'first_steps',
      title: 'الخطوات الأولى',
      description: 'أكمل مستواك الأول في أي عالم',
      icon: Icons.directions_walk,
      reward: 25,
    ),
    Achievement(
      id: 'star_collector',
      title: 'جامع النجوم',
      description: 'اجمع 10 نجوم ذهبية',
      icon: Icons.star,
      reward: 100,
    ),
    Achievement(
      id: 'store_visitor',
      title: 'زائر المتجر',
      description: 'اشترِ أول غرض لك من المتجر',
      icon: Icons.shopping_bag,
      reward: 50,
    ),
    Achievement(
      id: 'world_traveler',
      title: 'مسافر العوالم',
      description: 'افتح جميع العوالم الخمسة',
      icon: Icons.public,
      reward: 200,
    ),
    Achievement(
      id: 'perfect_score',
      title: 'العلامة الكاملة',
      description: 'احصل على 3 نجوم في 5 مستويات',
      icon: Icons.verified,
      reward: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        // Ensure achievements are checked
        game.checkAchievements();

        return GameBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(context, game),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 12,
                            childAspectRatio: 3.5,
                          ),
                          itemCount: achievements.length,
                          itemBuilder: (context, index) {
                            final achievement = achievements[index];
                            final isUnlocked = game.unlockedAchievements.contains(achievement.id);

                            return _buildAchievementCard(achievement, isUnlocked)
                                .animate()
                                .fadeIn(delay: Duration(milliseconds: 100 * index), duration: 400.ms)
                                .slideX(begin: 0.1);
                          },
                        ),
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
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.outlineVariant, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PremiumNavButton(onTap: () => context.pop()),
            Text(
              "إنجازاتي",
              style: GoogleFonts.cairo(
                color: AppColors.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildCurrencyChip(Icons.monetization_on, Colors.orange, game.coins.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyChip(IconData icon, Color color, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Text(
            value,
            style: GoogleFonts.cairo(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.surfaceContainer : AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isUnlocked ? AppColors.primary.withValues(alpha: 0.3) : AppColors.outlineVariant,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isUnlocked ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.icon,
              size: 32,
              color: isUnlocked ? AppColors.primary : AppColors.onSurfaceVariant.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? AppColors.onSurface : AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  achievement.description,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: isUnlocked ? AppColors.onSurfaceVariant : AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isUnlocked)
            Column(
              children: [
                const Icon(Icons.emoji_events, color: Colors.orange, size: 30),
                Text(
                  "مكتمل",
                  style: GoogleFonts.cairo(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Row(
                children: [
                  Text(
                    "+${achievement.reward}",
                    style: GoogleFonts.cairo(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.monetization_on, color: Colors.orange, size: 14),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

