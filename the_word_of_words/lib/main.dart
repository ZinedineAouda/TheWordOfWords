import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/widgets/coin_particles.dart';
import 'core/services/tts_feedback_service.dart';

import 'package:provider/provider.dart';
import 'core/providers/game_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize TTS but don't let it block the entire app if it fails
    await TtsFeedbackService().init().timeout(const Duration(seconds: 3));
  } catch (e) {
    debugPrint('TTS Initialization failed: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: const CorrectWordsApp(),
    ),
  );
}

class CorrectWordsApp extends StatelessWidget {
  const CorrectWordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        return MaterialApp.router(
          title: 'كلماتي الصحيحة',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: AppTheme.getTheme(game.currentTheme),
          locale: const Locale('ar', ''),
          supportedLocales: const [Locale('ar', '')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return CoinParticleOverlay(child: child!);
          },
        );
      },
    );
  }
}

