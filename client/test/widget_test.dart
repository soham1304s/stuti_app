import 'package:flutter_test/flutter_test.dart';
import 'package:meshtalk_client/main.dart';
import 'package:meshtalk_client/services/connectivity_service.dart';
import 'package:meshtalk_client/services/encryption_service.dart';
import 'package:meshtalk_client/services/nearby_device_service.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:meshtalk_client/services/sync_service.dart';
import 'package:meshtalk_client/services/transport_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('MeshTalk App launches and displays core shell navigation', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
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

    await tester.pumpWidget(
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

    await tester.pumpAndSettle();

    // Verify top status banner text exists
    expect(find.textContaining('Online • Mesh Cloud Connected'), findsOneWidget);

    // Verify bottom navigation destinations
    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Nearby'), findsOneWidget);
    expect(find.text('Contacts'), findsOneWidget);
    expect(find.text('Console'), findsOneWidget);

    // Verify seeded conversation Rahul is visible
    expect(find.text('Rahul'), findsOneWidget);
  });
}
