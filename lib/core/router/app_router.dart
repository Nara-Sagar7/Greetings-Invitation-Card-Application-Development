import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/gallery/gallery_screen.dart';
import '../../features/editor/editor_screen.dart';
import '../../features/preview/preview_screen.dart';
import '../../features/guest_list/guest_list_screen.dart';
import '../../features/send/send_screen.dart';
import '../../features/rsvp/rsvp_dashboard_screen.dart';
import '../../features/my_cards/my_cards_screen.dart';
import '../../features/account/account_screen.dart';
import 'go_router_refresh.dart';

/// 9-Screen IA - PRD Section 07 (Page 7)
/// Max 3 taps Home -> Preview. Occasion-first.
/// Guard: If a screen doesn't serve §6, it doesn't exist.
class AppRouter {
  static Stream<dynamic> _authStream() {
    try {
      return FirebaseAuth.instance.authStateChanges();
    } catch (_) {
      return const Stream.empty();
    }
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(_authStream()),
    redirect: (context, state) {
      bool isLoggedIn = false;
      try {
        isLoggedIn = FirebaseAuth.instance.currentUser != null;
      } catch (_) {
        isLoggedIn = false;
      }
      final loc = state.matchedLocation;
      final protected = loc.startsWith('/send') || loc.startsWith('/rsvp');
      if (!isLoggedIn && protected) {
        return '/account';
      }
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/', builder: (c, s) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/gallery',
                builder: (c, s) {
                  final occasionId = s.uri.queryParameters['occasion'];
                  return GalleryScreen(occasionId: occasionId);
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my-cards',
                builder: (c, s) => const MyCardsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (c, s) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),
      // Full-screen flows (outside bottom nav)
      GoRoute(
        path: '/editor/:templateId',
        builder: (c, s) {
          final templateId = s.pathParameters['templateId']!;
          final draftId = s.uri.queryParameters['draftId'];
          return EditorScreen(templateId: templateId, draftId: draftId);
        },
      ),
      GoRoute(
        path: '/preview',
        builder: (c, s) =>
            PreviewScreen(templateId: s.uri.queryParameters['templateId']),
      ),
      GoRoute(path: '/guest-list', builder: (c, s) => const GuestListScreen()),
      GoRoute(path: '/send', builder: (c, s) => const SendScreen()),
      GoRoute(
        path: '/rsvp/:eventId',
        builder: (c, s) {
          final eventId = s.pathParameters['eventId']!;
          return RsvpDashboardScreen(eventId: eventId);
        },
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard_outlined),
            selectedIcon: Icon(Icons.card_giftcard),
            label: 'My Cards',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
