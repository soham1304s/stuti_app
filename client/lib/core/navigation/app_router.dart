import 'package:flutter/material.dart';
import 'package:meshtalk_client/features/auth/presentation/providers/auth_provider.dart';
import 'package:meshtalk_client/features/auth/presentation/screens/login_screen.dart';
import 'package:meshtalk_client/features/calls/presentation/screens/calls_list_screen.dart';
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

GoRouter createAppRouter(StorageService storageService, AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login', // Will be immediately redirected if authenticated
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isFirebaseAuthed = authProvider.isAuthenticated;
      final hasLocalIdentity = storageService.currentUser != null;

      final isLoggingIn = state.uri.path == '/login';
      final isOnboarding = state.uri.path == '/onboarding';

      if (!isFirebaseAuthed) {
        return isLoggingIn ? null : '/login';
      }

      if (isFirebaseAuthed && !hasLocalIdentity) {
        return isOnboarding ? null : '/onboarding';
      }

      if (isFirebaseAuthed && hasLocalIdentity && (isLoggingIn || isOnboarding)) {
        return '/chats';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
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
            path: '/contacts',
            builder: (context, state) => const ContactsScreen(),
          ),
          GoRoute(
            path: '/calls',
            builder: (context, state) => const CallsListScreen(),
          ),
          GoRoute(
            path: '/chats',
            builder: (context, state) => const ConversationListScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
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
        path: '/nearby',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NearbyRadarScreen(),
      ),
      GoRoute(
        path: '/console',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MeshDebugConsoleScreen(),
      ),
      GoRoute(
        path: '/profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
