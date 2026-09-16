import 'package:flutter/material.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/core/navigation/app_router.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/services/connectivity_service.dart';
import 'package:meshtalk_client/services/encryption_service.dart';
import 'package:meshtalk_client/services/nearby_device_service.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:meshtalk_client/services/sync_service.dart';
import 'package:meshtalk_client/services/transport_manager.dart';
import 'package:meshtalk_client/services/story_server_service.dart';
import 'package:provider/provider.dart';

import 'package:meshtalk_client/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:meshtalk_client/features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Add Firebase initialization here when packages are added
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRepository = FirebaseAuthRepository();
  final authProvider = AuthProvider(authRepository);

  // Initialize Storage Service & Core Preferences
  final storageService = StorageService();
  await storageService.initialize();

  final connectivityService = ConnectivityService();
  final nearbyDeviceService = NearbyDeviceService();
  final encryptionService = EncryptionService();
  final storyServerService = StoryServerService();

  final syncService = SyncService(
    storageService: storageService,
    connectivityService: connectivityService,
  );

  final transportManager = TransportManager(
    connectivityService: connectivityService,
    nearbyDeviceService: nearbyDeviceService,
    encryptionService: encryptionService,
    storageService: storageService,
    syncService: syncService,
  );

  // Start P2P Story Server
  if (storageService.currentUser != null) {
    storyServerService.startServer(storageService.currentUser!.displayName);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<StorageService>.value(value: storageService),
        ChangeNotifierProvider<ConnectivityService>.value(value: connectivityService),
        ChangeNotifierProvider<NearbyDeviceService>.value(value: nearbyDeviceService),
        Provider<EncryptionService>.value(value: encryptionService),
        ChangeNotifierProvider<SyncService>.value(value: syncService),
        ChangeNotifierProvider<TransportManager>.value(value: transportManager),
        ChangeNotifierProvider<StoryServerService>.value(value: storyServerService),
      ],
      child: MeshTalkApp(
        storageService: storageService,
        authProvider: authProvider,
      ),
    ),
  );
}

class MeshTalkApp extends StatefulWidget {
  final StorageService storageService;
  final AuthProvider authProvider;

  const MeshTalkApp({super.key, required this.storageService, required this.authProvider});

  @override
  State<MeshTalkApp> createState() => _MeshTalkAppState();
}

class _MeshTalkAppState extends State<MeshTalkApp> {
  late final _router = createAppRouter(widget.storageService, widget.authProvider);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<StorageService>().isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: _router,
    );
  }
}
