import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';

class MainShellScreen extends ConsumerWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/contacts')) return 0; // People
    if (location.startsWith('/calls')) return 1;    // Calls
    if (location.startsWith('/chats')) return 2;    // Chats
    if (location.startsWith('/settings')) return 3; // Settings
    return 2; // Default to Chats
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/contacts');
        break;
      case 1:
        context.go('/calls');
        break;
      case 2:
        context.go('/chats');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: child),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (idx) => _onItemTapped(idx, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt, color: AppTheme.primaryEmerald),
            label: 'People',
          ),
          NavigationDestination(
            icon: Icon(Icons.phone_outlined),
            selectedIcon: Icon(Icons.phone, color: AppTheme.primaryEmerald),
            label: 'Calls',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble, color: AppTheme.primaryEmerald),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppTheme.primaryEmerald),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

