import 'package:flutter_test/flutter_test.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/features/auth/domain/models/user_identity.dart';
import 'package:meshtalk_client/services/connectivity_service.dart';
import 'package:meshtalk_client/services/encryption_service.dart';
import 'package:meshtalk_client/services/nearby_device_service.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:meshtalk_client/services/sync_service.dart';
import 'package:meshtalk_client/services/transport_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storage;
  late ConnectivityService connectivity;
  late NearbyDeviceService nearby;
  late EncryptionService encryption;
  late SyncService syncService;
  late TransportManager transportManager;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = StorageService();
    await storage.initialize();

    // Set test user
    await storage.saveUserIdentity(
      UserIdentity(
        id: 'user-me-test',
        displayName: 'Test User',
        phone: '+91 99999 88888',
        publicKey: 'PUBKEY_ME_TEST',
        privateKey: 'PRIVKEY_ME_TEST',
        fingerprint: '1111-2222-3333-4444',
        createdAt: DateTime.now(),
      ),
    );

    connectivity = ConnectivityService();
    nearby = NearbyDeviceService();
    encryption = EncryptionService();
    syncService = SyncService(
      storageService: storage,
      connectivityService: connectivity,
    );
    transportManager = TransportManager(
      connectivityService: connectivity,
      nearbyDeviceService: nearby,
      encryptionService: encryption,
      storageService: storage,
      syncService: syncService,
    );
  });

  group('TransportManager Automatic Selection Tests', () {
    test('Selects Internet when internet is available', () {
      connectivity.toggleInternet(true);
      final transport = transportManager.predictActiveTransport('PUBKEY_RAHUL_44919028');
      expect(transport, equals(MessageTransport.internet));
    });

    test('Selects Bluetooth when internet is cut and peer is nearby', () {
      connectivity.toggleInternet(false);
      connectivity.toggleBluetooth(true);

      // Rahul is seeded in nearby device service
      final transport = transportManager.predictActiveTransport('PUBKEY_RAHUL_44919028');
      expect(transport, equals(MessageTransport.bluetooth));
    });

    test('Selects MeshRelay when internet is cut and peer is NOT nearby', () {
      connectivity.toggleInternet(false);
      connectivity.toggleBluetooth(true);

      // Charlie is not in nearby devices list
      final transport = transportManager.predictActiveTransport('PUBKEY_NON_EXISTENT');
      expect(transport, equals(MessageTransport.meshRelay));
    });

    test('Sends and persists message with correct status', () async {
      connectivity.toggleInternet(false);
      connectivity.toggleBluetooth(true);

      final result = await transportManager.sendMessage(
        conversationId: 'conv-rahul',
        recipientId: 'contact-rahul',
        recipientPublicKey: 'PUBKEY_RAHUL_44919028',
        plaintext: 'Hello over BLE test',
      );

      expect(result.success, isTrue);
      expect(result.transportUsed, equals(MessageTransport.bluetooth));
      expect(result.status, equals(MessageStatus.delivered));

      final saved = storage.getMessagesForConversation('conv-rahul');
      expect(saved.any((m) => m.content == 'Hello over BLE test'), isTrue);
    });
  });
}
