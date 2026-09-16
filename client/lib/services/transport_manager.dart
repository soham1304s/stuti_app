import 'package:flutter/foundation.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';
import 'package:meshtalk_client/services/connectivity_service.dart';
import 'package:meshtalk_client/services/encryption_service.dart';
import 'package:meshtalk_client/services/nearby_device_service.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:meshtalk_client/services/sync_service.dart';

class SendResult {
  final bool success;
  final MessageTransport transportUsed;
  final MessageStatus status;
  final Message message;
  final String statusDescription;

  SendResult({
    required this.success,
    required this.transportUsed,
    required this.status,
    required this.message,
    required this.statusDescription,
  });
}

/// Smart Transport Manager implementing README Section 438 & 1732
class TransportManager extends ChangeNotifier {
  final ConnectivityService connectivityService;
  final NearbyDeviceService nearbyDeviceService;
  final EncryptionService encryptionService;
  final StorageService storageService;
  final SyncService syncService;

  TransportManager({
    required this.connectivityService,
    required this.nearbyDeviceService,
    required this.encryptionService,
    required this.storageService,
    required this.syncService,
  });

  /// Predicts which transport will be used if the user sends right now
  MessageTransport predictActiveTransport(String recipientPublicKey) {
    if (connectivityService.isInternetAvailable) {
      return MessageTransport.internet;
    }

    final nearbyPeer = nearbyDeviceService.findDeviceByPublicKey(recipientPublicKey);
    if (connectivityService.isBluetoothAvailable && nearbyPeer != null) {
      return MessageTransport.bluetooth;
    }

    return MessageTransport.meshRelay;
  }

  /// Sends a message using automatic transport selection
  Future<SendResult> sendMessage({
    required String conversationId,
    required String recipientId,
    required String recipientPublicKey,
    required String plaintext,
    MessageMediaType mediaType = MessageMediaType.text,
    String? mediaUrl,
    int? audioDurationSeconds,
  }) async {
    final user = storageService.currentUser;
    if (user == null) {
      throw StateError('User identity must be initialized before sending');
    }

    // 1. Determine best transport
    final transport = predictActiveTransport(recipientPublicKey);

    // 2. Encrypt and pack sealed E2EE envelope
    final sealedMessage = encryptionService.sealMessage(
      conversationId: conversationId,
      senderId: user.id,
      senderName: user.displayName,
      senderPrivateKey: user.privateKey,
      recipientId: recipientId,
      recipientPublicKey: recipientPublicKey,
      plaintext: plaintext,
      transport: transport,
      mediaType: mediaType,
      mediaUrl: mediaUrl,
      audioDurationSeconds: audioDurationSeconds,
    );

    // 3. Dispatch based on transport
    switch (transport) {
      case MessageTransport.internet:
        // Internet Cloud Route
        final sent = sealedMessage.copyWith(status: MessageStatus.sent);
        await storageService.saveMessage(sent);

        // Simulate server roundtrip to delivered
        Future.delayed(const Duration(milliseconds: 600), () {
          storageService.updateMessageStatus(sent.id, MessageStatus.delivered);
        });

        return SendResult(
          success: true,
          transportUsed: MessageTransport.internet,
          status: MessageStatus.sent,
          message: sent,
          statusDescription: '✓ Sent via Internet',
        );

      case MessageTransport.bluetooth:
        // Direct Nearby BLE Route
        final nearbyPeer = nearbyDeviceService.findDeviceByPublicKey(recipientPublicKey);
        final sent = sealedMessage.copyWith(
          status: MessageStatus.delivered,
          hopCount: 0,
        );
        await storageService.saveMessage(sent);

        return SendResult(
          success: true,
          transportUsed: MessageTransport.bluetooth,
          status: MessageStatus.delivered,
          message: sent,
          statusDescription: '✓ Sent via Bluetooth (${nearbyPeer?.approximateDistance ?? "Nearby"})',
        );

      case MessageTransport.meshRelay:
        // No direct route -> Queue for Store-and-Forward Mesh
        await syncService.enqueueOfflineMessage(sealedMessage);

        return SendResult(
          success: true,
          transportUsed: MessageTransport.meshRelay,
          status: MessageStatus.queuedOffline,
          message: sealedMessage,
          statusDescription: '⏱ Queued for Nearby Mesh Relay',
        );
    }
  }
}
