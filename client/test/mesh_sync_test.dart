import 'package:flutter_test/flutter_test.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/features/auth/domain/models/user_identity.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';
import 'package:meshtalk_client/services/connectivity_service.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:meshtalk_client/services/sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storage;
  late ConnectivityService connectivity;
  late SyncService syncService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = StorageService();
    await storage.initialize();

    await storage.saveUserIdentity(
      UserIdentity(
        id: 'node-alice',
        displayName: 'Alice',
        phone: '+91 91111 22222',
        publicKey: 'PUBKEY_ALICE',
        privateKey: 'PRIVKEY_ALICE',
        fingerprint: 'AAAA-BBBB-CCCC-DDDD',
        createdAt: DateTime.now(),
      ),
    );

    connectivity = ConnectivityService();
    syncService = SyncService(
      storageService: storage,
      connectivityService: connectivity,
    );
  });

  group('Mesh Routing & Sync Service Tests', () {
    test('Rejects duplicate packet ID to prevent network flooding', () async {
      final msg = Message(
        id: 'packet-unique-101',
        conversationId: 'conv-test',
        senderId: 'node-charlie',
        recipientId: 'node-alice',
        senderName: 'Charlie',
        content: 'Mesh transmission',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
        status: MessageStatus.sent,
        transport: MessageTransport.bluetooth,
      );

      final initialDrops = syncService.duplicateDropsCount;
      final firstAccept = await syncService.processIncomingMeshPacket(msg, 'node-bob');
      expect(firstAccept, isTrue);

      // Second attempt with same message ID
      final secondAccept = await syncService.processIncomingMeshPacket(msg, 'node-bob');
      expect(secondAccept, isFalse);
      expect(syncService.duplicateDropsCount, equals(initialDrops + 1));
    });

    test('Rejects expired message when TTL is zero or negative', () async {
      final initialFailed = syncService.failedTransfers;
      final expiredMsg = Message(
        id: 'packet-expired-202',
        conversationId: 'conv-test',
        senderId: 'node-charlie',
        recipientId: 'node-david',
        senderName: 'Charlie',
        content: 'Old packet',
        createdAt: DateTime.now().subtract(const Duration(hours: 30)),
        expiresAt: DateTime.now().subtract(const Duration(hours: 6)),
        ttl: 0,
        status: MessageStatus.sent,
        transport: MessageTransport.meshRelay,
      );

      final accepted = await syncService.processIncomingMeshPacket(expiredMsg, 'node-bob');
      expect(accepted, isFalse);
      expect(syncService.failedTransfers, equals(initialFailed + 1));
    });

    test('Increments hop count and decrements TTL when relaying intermediate message', () async {
      final relayMsg = Message(
        id: 'packet-relay-303',
        conversationId: 'conv-test',
        senderId: 'node-charlie',
        recipientId: 'node-david', // Not for Alice
        senderName: 'Charlie',
        content: 'Forward me to David',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
        ttl: 8,
        hopCount: 1,
        status: MessageStatus.sent,
        transport: MessageTransport.meshRelay,
        relayPath: ['node-charlie'],
      );

      final accepted = await syncService.processIncomingMeshPacket(relayMsg, 'node-bob');
      expect(accepted, isTrue);
      expect(syncService.forwardedCount, equals(8)); // Initial was 7, now 8
      expect(syncService.offlineQueue.last.ttl, equals(7)); // 8 - 1 = 7
      expect(syncService.offlineQueue.last.hopCount, equals(2)); // 1 + 1 = 2
      expect(syncService.offlineQueue.last.relayPath.contains('node-bob'), isTrue);
    });
  });
}
