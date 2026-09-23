import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/core/navigation/app_router.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/app/data/local/drift/database.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  // ponytail: Use placeholder keys for now, configure later
  await Supabase.initialize(
    url: 'https://placeholder-project.supabase.co',
    anonKey: 'placeholder-anon-key',
  );

  runApp(
    const ProviderScope(
      child: MeshTalkApp(),
    ),
  );
}

class MeshTalkApp extends ConsumerWidget {
  const MeshTalkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // ponytail: Simplification, listen to theme provider when implemented
    const isDarkMode = true;

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
