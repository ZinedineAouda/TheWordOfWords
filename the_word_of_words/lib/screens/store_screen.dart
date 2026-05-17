import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/providers/game_provider.dart';

import '../shared/widgets/squishy_button.dart';
import '../shared/widgets/premium_ui_widgets.dart';
import '../shared/widgets/game_background.dart';
import '../shared/widgets/coin_particles.dart';
import '../core/models/game_models.dart';

class StoreItem {
  final String id;
  final String name;
  final String imagePath;
  final int price;
  final Color? color;

  StoreItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    this.color,
  });
}

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<StoreItem> avatars = [
    StoreItem(id: 'none', name: 'صورتي الشخصية', imagePath: 'assets/images/app_logo.jpg', price: 0, color: Colors.orange),
    StoreItem(id: 'hero_explorer', name: 'المستكشف البطل', imagePath: 'assets/images/hero_explorer_boy.png', price: 100, color: Colors.blue),
    StoreItem(id: 'hero_supergirl', name: 'البطلة الخارقة', imagePath: 'assets/images/hero_super_girl.png', price: 150, color: Colors.pink),
    StoreItem(id: 'hero_knight', name: 'الفارس الشجاع', imagePath: 'assets/images/hero_knight.png', price: 200, color: Colors.green),
    StoreItem(id: 'hero_doctor', name: 'الطبيب الذكي', imagePath: 'assets/images/hero_doctor.png', price: 250, color: Colors.teal),
    StoreItem(id: 'hero_fireman', name: 'رجل الإطفاء الشجاع', imagePath: 'assets/images/hero_fireman.png', price: 250, color: Colors.red),
    StoreItem(id: 'hero_astronaut', name: 'رائد الفضاء الصغير', imagePath: 'assets/images/hero_astronaut.png', price: 300, color: Colors.deepPurple),
  ];

  final List<StoreItem> themes = [
    StoreItem(id: 'Default Blue', name: 'المحيط الهادئ', imagePath: 'assets/images/world_map_bg.png', price: 0, color: Colors.blue),
    StoreItem(id: 'forest', name: 'الغابة المسحورة', imagePath: 'assets/images/theme_forest_bg.png', price: 150, color: Colors.green),
    StoreItem(id: 'ocean', name: 'أعماق البحار', imagePath: 'assets/images/theme_ocean_bg.png', price: 200, color: Colors.lightBlue),
    StoreItem(id: 'space', name: 'مغامرة الفضاء', imagePath: 'assets/images/theme_space_bg.png', price: 300, color: Colors.deepPurple),
    StoreItem(id: 'candy', name: 'عالم الحلويات', imagePath: 'assets/images/theme_candy_bg.png', price: 350, color: Colors.pinkAccent),
  ];

  final List<StoreItem> clickEffects = [
    StoreItem(id: 'default', name: 'بسيط', imagePath: 'assets/images/effect_ripple.png', price: 0, color: Colors.blue),
    StoreItem(id: 'stars', name: 'نجوم مضيئة', imagePath: 'assets/images/effect_stars_preview.png', price: 50, color: Colors.yellow),
    StoreItem(id: 'bubbles', name: 'فقاعات صابون', imagePath: 'assets/images/effect_bubbles_preview.png', price: 75, color: Colors.cyan),
    StoreItem(id: 'hearts', name: 'قلوب دافئة', imagePath: 'assets/images/effect_hearts.png', price: 100, color: Colors.red),
    StoreItem(id: 'magic', name: 'سحر برّاق', imagePath: 'assets/images/effect_magic_preview.png', price: 150, color: Colors.purple),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  void _handlePurchase(StoreItem item, ItemCategory category) async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    
    if (gameProvider.coins < item.price) {
      _showInsufficientCoinsDialog();
      return;
    }

    final confirm = await _showConfirmPurchaseDialog(item);
    if (confirm == true) {
      final success = await gameProvider.spendCoins(item.price);
      if (success) {
        switch (category) {
          case ItemCategory.avatar:
            gameProvider.unlockAvatar(item.id);
            gameProvider.setAvatar(item.id);
            break;
          case ItemCategory.theme:
            gameProvider.unlockTheme(item.id);
            gameProvider.setTheme(item.id);
            break;
          case ItemCategory.clickEffect:
            gameProvider.unlockClickEffect(item.id);
            gameProvider.setClickEffect(item.id);
            break;
        }
        
        // Trigger coin burst at the coin balance location
        final RenderBox? coinBox = context.findRenderObject() as RenderBox?;
        if (coinBox != null) {
          final position = coinBox.localToGlobal(Offset.zero);
          CoinParticleOverlay.of(context)?.spawnParticles(
            Offset(position.dx + 300, 50), // Approximate position of the coin balance in the app bar
            count: 15,
          );
        }

        _showSuccessSnackBar(item.name);
      }
    }
  }

  Future<bool?> _showConfirmPurchaseDialog(StoreItem item) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        title: Text(
          "تأكيد الشراء",
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: item.color?.withValues(alpha: 0.1) ?? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: item.color ?? Theme.of(context).colorScheme.primary, width: 3),
              ),
              child: ClipOval(
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.palette, size: 50, color: item.color),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "هل تريد شراء ${item.name} مقابل ${item.price} عملة؟",
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("إلغاء", style: TextStyle(color: Colors.grey, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SquishyButton(
                    onPressed: () => Navigator.pop(context, true),
                    color: Colors.orange,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text("شراء", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 16)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showInsufficientCoinsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Text("تحتاج المزيد من العملات!", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.monetization_on, color: Colors.orange, size: 80).animate().shake(),
            const SizedBox(height: 20),
            const Text("العب أكثر لتجمع المزيد من العملات الرائعة!", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Cairo')),
            const SizedBox(height: 30),
            SquishyButton(
              onPressed: () => Navigator.pop(context),
              color: Theme.of(context).colorScheme.primary,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text("حسنًا", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String itemName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تم شراء $itemName بنجاح! مبروك!", textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        return Scaffold(
          body: GameBackground(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(game),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 2),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          ),
                          dividerColor: Colors.transparent,
                          labelColor: Theme.of(context).colorScheme.primary,
                          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                          labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
                          tabs: const [
                            Tab(text: "صور الملف"),
                            Tab(text: "الألوان"),
                            Tab(text: "تأثير اللمس"),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildItemsGrid(avatars, ItemCategory.avatar, game),
                          _buildItemsGrid(themes, ItemCategory.theme, game),
                          _buildItemsGrid(clickEffects, ItemCategory.clickEffect, game),
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

  Widget _buildAppBar(GameProvider game) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const PremiumNavButton(),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 2),
            ),
            child: Text(
              "المتجر",
              style: GoogleFonts.cairo(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
          ),
          const Spacer(),
          PremiumCoinBalance(coins: game.coins),
        ],
      ),
    );
  }

  Widget _buildItemsGrid(List<StoreItem> items, ItemCategory category, GameProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        bool isUnlocked = false;
        bool isEquipped = false;

        switch (category) {
          case ItemCategory.avatar:
            isUnlocked = provider.unlockedAvatars.contains(item.id);
            isEquipped = provider.currentAvatar == item.id;
            break;
          case ItemCategory.theme:
            isUnlocked = provider.unlockedThemes.contains(item.id);
            isEquipped = provider.currentTheme == item.id;
            break;
          case ItemCategory.clickEffect:
            isUnlocked = provider.unlockedClickEffects.contains(item.id);
            isEquipped = provider.currentClickEffect == item.id;
            break;
        }

        return _buildItemCard(item, isUnlocked, isEquipped, category, provider)
            .animate()
            .fadeIn(delay: Duration(milliseconds: 50 * index), duration: 400.ms)
            .scale(begin: const Offset(0.9, 0.9));
      },
    );
  }

  Widget _buildItemCard(StoreItem item, bool isUnlocked, bool isEquipped, ItemCategory category, GameProvider provider) {
    return PremiumClickEffect(
      onTap: isUnlocked && !isEquipped 
          ? () {
              switch (category) {
                case ItemCategory.avatar: provider.setAvatar(item.id); break;
                case ItemCategory.theme: provider.setTheme(item.id); break;
                case ItemCategory.clickEffect: provider.setClickEffect(item.id); break;
              }
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isEquipped ? Colors.green : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (item.color ?? Colors.black).withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (item.color ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.1),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                category == ItemCategory.avatar ? Icons.face : 
                                (category == ItemCategory.theme ? Icons.palette : Icons.touch_app),
                                size: 60,
                                color: item.color ?? Theme.of(context).colorScheme.primary,
                              ),
                            ).animate(target: isUnlocked ? 0 : 1).desaturate(duration: 400.ms),
                          ),
                        ),
                        if (!isUnlocked)
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.lock, color: Colors.white, size: 30),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Text(
                  item.name,
                  style: GoogleFonts.cairo(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                if (isEquipped)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check, color: Colors.green, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "مفعل",
                          style: GoogleFonts.cairo(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                else if (isUnlocked)
                  Text(
                    "اضغط للتفعيل",
                    style: GoogleFonts.cairo(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  SquishyButton(
                    onPressed: () => _handlePurchase(item, category),
                    color: Colors.orange.shade700,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${item.price}",
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.monetization_on, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

