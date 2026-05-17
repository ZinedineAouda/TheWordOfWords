
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/game_hub_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/store_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/win_screen.dart';
import '../screens/game_exercise_screen.dart';
import '../screens/profile_onboarding_screen.dart';
import '../screens/world_map_screen.dart';
import 'package:provider/provider.dart';
import '../core/providers/game_provider.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      if (gameProvider.isFirstTime && state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const ProfileOnboardingScreen(),
      ),
      GoRoute(
        path: '/game-hub',
        builder: (context, state) => const GameHubScreen(),
      ),
      GoRoute(
        path: '/world-map',
        builder: (context, state) => const WorldMapScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => AchievementsScreen(),
      ),
      GoRoute(
        path: '/shop',
        builder: (context, state) => const StoreScreen(),
      ),
      GoRoute(
        path: '/game-play',
        builder: (context, state) => const GameExerciseScreen(),
      ),
      GoRoute(
        path: '/win',
        builder: (context, state) => const WinScreen(),
      ),
    ],
  );
}
