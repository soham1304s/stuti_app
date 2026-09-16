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
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Storage Service & Core Preferences
  final storageService = StorageService();
  await storageService.initialize();

  final connectivityService = ConnectivityService();
  final nearbyDeviceService = NearbyDeviceService();
  final encryptionService = EncryptionService();

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<StorageService>.value(value: storageService),
        ChangeNotifierProvider<ConnectivityService>.value(value: connectivityService),
        ChangeNotifierProvider<NearbyDeviceService>.value(value: nearbyDeviceService),
        Provider<EncryptionService>.value(value: encryptionService),
        ChangeNotifierProvider<SyncService>.value(value: syncService),
        ChangeNotifierProvider<TransportManager>.value(value: transportManager),
      ],
      child: MeshTalkApp(storageService: storageService),
    ),
  );
}

class MeshTalkApp extends StatefulWidget {
  final StorageService storageService;

  const MeshTalkApp({super.key, required this.storageService});

  @override
  State<MeshTalkApp> createState() => _MeshTalkAppState();
}

class _MeshTalkAppState extends State<MeshTalkApp> {
  late final _router = createAppRouter(widget.storageService);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to sleek off-grid dark theme
      routerConfig: _router,
    );
  }
}
