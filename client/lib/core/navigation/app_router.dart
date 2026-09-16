import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:meshtalk_client/features/calls/presentation/screens/call_screen.dart';
import 'package:meshtalk_client/features/chat/presentation/screens/chat_room_screen.dart';
import 'package:meshtalk_client/features/chat/presentation/screens/conversation_list_screen.dart';
import 'package:meshtalk_client/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:meshtalk_client/features/mesh/presentation/screens/mesh_debug_console_screen.dart';
import 'package:meshtalk_client/features/nearby/presentation/screens/nearby_radar_screen.dart';
import 'package:meshtalk_client/features/profile/presentation/screens/profile_screen.dart';
import 'package:meshtalk_client/features/settings/presentation/screens/settings_screen.dart';
import 'package:meshtalk_client/features/shell/presentation/screens/main_shell_screen.dart';
import 'package:meshtalk_client/services/storage_service.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(StorageService storageService) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: storageService.currentUser == null ? '/onboarding' : '/chats',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Shell Route for Main Application Navigation & Top Banner
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/chats',
            builder: (context, state) => const ConversationListScreen(),
          ),
          GoRoute(
            path: '/nearby',
            builder: (context, state) => const NearbyRadarScreen(),
          ),
          GoRoute(
            path: '/contacts',
            builder: (context, state) => const ContactsScreen(),
          ),
          GoRoute(
            path: '/console',
            builder: (context, state) => const MeshDebugConsoleScreen(),
          ),
        ],
      ),

      // Standalone Full-Screen Routes
      GoRoute(
        path: '/chats/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final convId = state.pathParameters['id']!;
          return ChatRoomScreen(conversationId: convId);
        },
      ),
      GoRoute(
        path: '/calls',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final name = state.uri.queryParameters['name'] ?? 'Mesh Contact';
          final type = state.uri.queryParameters['type'] ?? 'audio';
          return CallScreen(peerName: name, callType: type);
        },
      ),
      GoRoute(
        path: '/profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
