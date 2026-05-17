import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/game_provider.dart';
import '../../core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  final bool showBorder;
  final String? imagePath; // Optional override

  const ProfileAvatar({
    super.key,
    this.size = 80,
    this.showBorder = true,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        final path = imagePath ?? game.userProfileImagePath;
        final hasCustom = imagePath != null 
            ? (!imagePath!.startsWith('assets/')) 
            : game.hasCustomProfileImage;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceVariant,
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade300,
                Colors.orange.shade600,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: showBorder 
                ? Border.all(color: Colors.white, width: 3) 
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(showBorder ? 2 : 0),
            child: ClipOval(
              child: _buildImage(path, hasCustom),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(String path, bool hasCustom) {
    if (!hasCustom) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    if (kIsWeb) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }
  }

  Widget _buildFallback() {
    return const Icon(Icons.person, color: Colors.grey, size: 40);
  }
}
