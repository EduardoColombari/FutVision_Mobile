import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'services/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/standings_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/players_screen.dart';
import 'screens/compare_screen.dart';
import 'screens/about_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/login_screen.dart';
import 'screens/team_details_screen.dart';
import 'screens/player_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FutVisionApp());
}

final _router = GoRouter(
  redirect: (context, state) {
    final loggedIn = currentUser != null;
    final onLogin = state.matchedLocation == '/login';
    if (!loggedIn && !onLogin) return '/login';
    if (loggedIn && onLogin) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    ShellRoute(
      builder: (context, state, child) => _Shell(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/standings', builder: (_, __) => const StandingsScreen()),
        GoRoute(path: '/matches', builder: (_, __) => const MatchesScreen()),
        GoRoute(path: '/players', builder: (_, __) => const PlayersScreen()),
        GoRoute(path: '/compare', builder: (_, __) => const CompareScreen()),
        GoRoute(path: '/favorites', builder: (_, __) => const FavoritesScreen()),
        GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
      ],
    ),
    GoRoute(
      path: '/team/:id',
      builder: (_, state) => TeamDetailsScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/player/:id',
      builder: (_, state) => PlayerDetailsScreen(id: state.pathParameters['id']!),
    ),
  ],
);

class FutVisionApp extends StatelessWidget {
  const FutVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FutVision',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          surface: Color(0xFF1A1A2E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D0D1A),
          elevation: 0,
        ),
      ),
    );
  }
}

const _navItems = [
  {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Início', 'route': '/'},
  {'icon': Icons.leaderboard_outlined, 'activeIcon': Icons.leaderboard, 'label': 'Classificação', 'route': '/standings'},
  {'icon': Icons.sports_soccer_outlined, 'activeIcon': Icons.sports_soccer, 'label': 'Jogos', 'route': '/matches'},
  {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Jogadores', 'route': '/players'},
  {'icon': Icons.compare_arrows_outlined, 'activeIcon': Icons.compare_arrows, 'label': 'Comparar', 'route': '/compare'},
  {'icon': Icons.star_border, 'activeIcon': Icons.star, 'label': 'Favoritos', 'route': '/favorites'},
  {'icon': Icons.info_outline, 'activeIcon': Icons.info, 'label': 'Sobre', 'route': '/about'},
];

class _Shell extends StatelessWidget {
  final Widget child;
  const _Shell({required this.child});

  int _selectedIndex(String location) {
    for (int i = _navItems.length - 1; i >= 0; i--) {
      if (location.startsWith(_navItems[i]['route'] as String)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final idx = _selectedIndex(location);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1A),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 28),
            const SizedBox(width: 8),
            const Text.rich(
              TextSpan(children: [
                TextSpan(text: 'Fut', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                TextSpan(text: 'Vision', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 18)),
              ]),
            ),
          ],
        ),
      ),
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF12121F),
          border: Border(top: BorderSide(color: Color(0xFF2A2A3E))),
        ),
        child: BottomNavigationBar(
          currentIndex: idx,
          onTap: (i) => context.go(_navItems[i]['route'] as String),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF00E5FF),
          unselectedItemColor: Colors.white38,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: _navItems.map((item) => BottomNavigationBarItem(
            icon: Icon(item['icon'] as IconData, size: 22),
            activeIcon: Icon(item['activeIcon'] as IconData, size: 22),
            label: item['label'] as String,
          )).toList(),
        ),
      ),
    );
  }
}
