import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import '../core/providers/game_provider.dart';
import '../shared/widgets/game_background.dart';
import '../shared/widgets/squishy_button.dart';
import '../shared/widgets/profile_avatar.dart';
import '../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../core/services/tts_feedback_service.dart';

class ProfileOnboardingScreen extends StatefulWidget {
  const ProfileOnboardingScreen({super.key});

  @override
  State<ProfileOnboardingScreen> createState() => _ProfileOnboardingScreenState();
}

class _ProfileOnboardingScreenState extends State<ProfileOnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل اختيار الصورة')),
        );
      }
    }
  }

  void _handleSave() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'من فضلك أدخل اسمك يا بطل!',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
      return;
    }

    if (_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'من فضلك اختر صورتك المفضلة!',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
      return;
    }

    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.updateUserProfile(name, _imagePath);
    
    // Vocal welcome
    TtsFeedbackService().speak('مرحباً بك يا $name في كلماتي الصحيحة. هيا بنا نلعب!');
    
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameBackground(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildNameInput(),
                  const SizedBox(height: 30),
                  _buildImageSelection(),
                  const SizedBox(height: 40),
                  _buildStartButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/app_logo.jpg',
            width: 80,
            height: 80,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.star, size: 60, color: Colors.orange),
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 16),
        Text(
          'مرحباً بك في كلماتي الصحيحة!',
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: [
              const Shadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
      ],
    );
  }

  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12, bottom: 12),
          child: Text(
            'ما هو اسمك؟',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: TextField(
            controller: _nameController,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
            decoration: InputDecoration(
              hintText: 'اكتب اسمك هنا...',
              hintStyle: GoogleFonts.cairo(
                color: Colors.grey.shade400,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1);
  }

  Widget _buildImageSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12, bottom: 12),
          child: Text(
            'اختر صورتك المفضلة:',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
          ),
          child: Column(
            children: [
              Center(
                child: ProfileAvatar(
                  size: 150,
                  imagePath: _imagePath,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildPickerButton(
                      'الكاميرا',
                      Icons.camera_alt_rounded,
                      Colors.blue,
                      () => _pickImage(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPickerButton(
                      'المعرض',
                      Icons.photo_library_rounded,
                      Colors.green,
                      () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1);
  }

  Widget _buildPickerButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return SquishyButton(
      onPressed: onTap,
      color: color,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return SquishyButton(
      onPressed: _handleSave,
      color: Colors.orange,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'هيا بنا نلعب!',
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.play_circle_fill, color: Colors.white, size: 32),
            ],
          ),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.05, 1.05), duration: 1000.ms, curve: Curves.easeInOut);
  }
}
