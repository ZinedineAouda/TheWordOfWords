import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';
import '../shared/widgets/squishy_button.dart';
import '../shared/widgets/profile_avatar.dart';
import 'package:provider/provider.dart';
import '../core/providers/game_provider.dart';

import 'package:google_fonts/google_fonts.dart';

import '../shared/widgets/game_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameBackground(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Consumer<GameProvider>(
              builder: (context, game, child) {
                if (game.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }
                
                if (game.error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'عذراً، حدث خطأ أثناء تحميل البيانات',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          SquishyButton(
                            color: Colors.orange,
                            onPressed: () => game.init(),
                            child: const Text('إعادة المحاولة', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildAppBar(context, game),
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildHeroSection(context),
                          const SizedBox(height: 24),
                          _buildBentoGrid(context, game),
                          const SizedBox(height: 32),
                          _buildSectionHeader(context, 'استكشف المزيد', Icons.explore),
                          const SizedBox(height: 16),
                          _buildSecondaryActivities(context),
                          const SizedBox(height: 100), // Bottom nav spacer
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildAppBar(BuildContext context, GameProvider game) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 100,
      centerTitle: false,
      title: ClipRRect(
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
              children: [
                const ProfileAvatar(size: 48, showBorder: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'أهلاً بك،',
                        style: GoogleFonts.cairo(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        game.userName ?? 'يا بطل!',
                        style: GoogleFonts.cairo(
                          color: AppColors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
          child: Row(
            children: [
              _buildCurrencyChip(context, Icons.stars, Colors.amber, game.stars.toString()),
              const SizedBox(width: 8),
              _buildCurrencyChip(context, Icons.monetization_on, Colors.orange, game.coins.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyChip(BuildContext context, IconData icon, Color color, String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Text(
                value,
                style: GoogleFonts.cairo(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مرحباً بك في عالم الكلمات!',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'استكشف عوالم جديدة، العب وتعلم، واجمع النجوم في طريقك.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/images/app_logo.jpg',
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.star, size: 80, color: Colors.orange),
                  ).animate().scale(delay: 200.ms, duration: 500.ms, curve: Curves.elasticOut),
                ],
              ),
              const SizedBox(height: 24),
              SquishyButton(
                color: Colors.orange,
                onPressed: () => context.push('/game-hub'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.rocket_launch, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      'ابدأ المغامرة',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBentoGrid(BuildContext context, GameProvider game) {
    return Column(
      children: [
        // Game of the Day
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.05,
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuB2iGncNKtYYDKPQILBg60OwwcvduqheQ8yJY-l6cld-OdX-xFarmJc-uxJEmhnywDMJzcU1kF2VHjVAH6mVxxUyFYliIQLcH9Dri17pvjGJi3vY_1R8KjSAXGCLBFGG5-D-vuOkNhijyGBpYPL5EZ1LTviHO3xHkZnHzyIvfR0CugD5xtCqdrdYbIynSycWf59FpQvrCvx_IGNnwrhDQiDu7EvZtodXgrgEvW_xPbYLSBZ8flVNHpYOFDudnl8m4rODJ9UmEKwrh0',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'لعبة اليوم',
                            style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.outlineVariant, width: 2),
                                image: const DecorationImage(
                                  image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDBoay8Dv7SkjtCcJbBXdGdaOoiGbqlQkAzA7ipc0x_q4z9nEpjWUkpGzUP0SDwxdCEcs1l2lZH8JavC3e10lGrChGRX9VkJquL7xPi8yclFDbmExMocTua2vvCXwxNI6FZr5gsIjQK21ngtzyygWWRnhNvUdejB0ibyxFeeajttZWZqP6-n3ce1t2Hm00Ht836uvj_WEMhZCrUPyUZlBWxGQHoqt21Tlzcs7l0m4iR6ZFqiicUY55OSZDXuSyfqvWZicSXP4nfKE8'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'لغز الكلمات المفقودة',
                                    style: GoogleFonts.cairo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  Text(
                                    'ساعد القرد الفضولي في العثور على الكلمات الضائعة.',
                                    style: GoogleFonts.cairo(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SquishyButton(
                              depth: 4,
                              color: Colors.purple,
                              onPressed: () => context.push('/game-hub'),
                              child: const Icon(Icons.play_arrow, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Stats Card
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'رصيد النجوم',
                    style: GoogleFonts.cairo(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    game.stars.toString(),
                    style: GoogleFonts.cairo(fontSize: 40, fontWeight: FontWeight.w900, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (game.stars % 10) / 10,
                      minHeight: 12,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'بقي ${10 - (game.stars % 10)} للنجمة التالية!',
                    style: GoogleFonts.cairo(fontSize: 12, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryActivities(BuildContext context) {
    final activities = [
      {'title': 'مرسم الألوان', 'icon': Icons.palette, 'color': AppColors.tertiaryFixed, 'iconColor': Colors.amberAccent},
      {'title': 'عالم الأصوات', 'icon': Icons.library_music, 'color': AppColors.primaryFixed, 'iconColor': Colors.blueAccent},
      {'title': 'قصص الخيال', 'icon': Icons.menu_book, 'color': AppColors.errorContainer, 'iconColor': Colors.pinkAccent},
      {'title': 'تحدي التركيب', 'icon': Icons.extension, 'color': AppColors.surfaceContainer, 'iconColor': Colors.purpleAccent},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final act = activities[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.outlineVariant, width: 2),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Icon(act['icon'] as IconData, color: act['iconColor'] as Color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                act['title'] as String,
                style: GoogleFonts.cairo(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ).animate().scale(delay: (index * 100).ms);
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -10)),
            ],
          ),
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 'الرئيسية', Icons.home, true, () {}),
          _buildNavItem(context, 'الألعاب', Icons.sports_esports, false, () => context.push('/game-hub')),
          _buildNavItem(context, 'المتجر', Icons.shopping_bag, false, () => context.push('/shop')),
          _buildNavItem(context, 'الإعدادات', Icons.settings, false, () => context.push('/settings')),
        ],
      ),
    ),
  ),
);
}

  Widget _buildNavItem(BuildContext context, String label, IconData icon, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: active ? BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant),
        ) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? Colors.orange : AppColors.onSurfaceVariant, size: 28),
            Text(
              label,
              style: GoogleFonts.cairo(
                color: active ? Colors.orange : AppColors.onSurfaceVariant,
                fontSize: 12,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
