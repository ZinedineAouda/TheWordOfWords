import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';
import '../core/providers/game_provider.dart';

import '../shared/widgets/premium_ui_widgets.dart';
import '../shared/widgets/game_background.dart';
import '../shared/widgets/squishy_button.dart';
import '../shared/widgets/profile_avatar.dart';
import '../core/services/tts_feedback_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
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
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(context),
                            const SizedBox(height: 24),

                            _buildSettingsSection(context, game),
                            const SizedBox(height: 24),
                            _buildSupportSection(context),
                            const SizedBox(height: 100), // Space for bottom nav
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: _buildBottomNavBar(context),
            extendBody: true,
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
            const ProfileAvatar(size: 48, showBorder: false),
            Text(
              'كلماتي الصحيحة',
              style: GoogleFonts.cairo(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                _buildCurrencyChip(Icons.stars, Colors.amber, game.stars.toString()),
                const SizedBox(width: 8),
                _buildCurrencyChip(Icons.monetization_on, Colors.orange, game.coins.toString()),
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
        border: Border.all(color: AppColors.outlineVariant, width: 1.5),
      ),
      child: Row(
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const PremiumNavButton(),
        const SizedBox(width: 20),
        Text(
          'الإعدادات',
          style: GoogleFonts.cairo(
            color: AppColors.onSurface,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }



  Widget _buildSettingsSection(BuildContext context, GameProvider game) {
    return Column(
      children: [
        _buildSettingCard(
          context,
          'الإشعارات',
          Icons.notifications,
          Colors.blue,
          Switch(
            value: true,
            onChanged: (val) {},
            activeColor: Colors.blue,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildSettingCard(BuildContext context, String title, IconData icon, Color iconColor, Widget trailing) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.cairo(
                color: AppColors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.outlineVariant, width: 2),
            ),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(32),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const Icon(Icons.support_agent, size: 40, color: AppColors.onSurface),
                    const SizedBox(height: 8),
                    Text(
                      'تواصل معنا',
                      style: GoogleFonts.cairo(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.outlineVariant, width: 2),
            ),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(32),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const Icon(Icons.help_outline, size: 40, color: AppColors.onSurface),
                    const SizedBox(height: 8),
                    Text(
                      'الأسئلة الشائعة',
                      style: GoogleFonts.cairo(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.outlineVariant, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, 'الرئيسية', Icons.home, false, () => context.go('/')),
            _buildNavItem(context, 'الألعاب', Icons.sports_esports, false, () => context.push('/game-hub')),
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
            Icon(icon, color: active ? Colors.orange : AppColors.onSurface.withValues(alpha: 0.6), size: 26),
            Text(
              label,
              style: GoogleFonts.cairo(
                color: active ? Colors.orange : AppColors.onSurface.withValues(alpha: 0.6),
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
