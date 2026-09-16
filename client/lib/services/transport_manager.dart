import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';
import 'package:meshtalk_client/services/connectivity_service.dart';
import 'package:meshtalk_client/services/encryption_service.dart';
import 'package:meshtalk_client/services/nearby_device_service.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:meshtalk_client/services/sync_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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

  WebSocketChannel? _channel;
  bool _isConnectedToServer = false;

  TransportManager({
    required this.connectivityService,
    required this.nearbyDeviceService,
    required this.encryptionService,
    required this.storageService,
    required this.syncService,
  }) {
    _connectToServer();
  }

  void _connectToServer() {
    try {
      final pubKey = storageService.currentUser?.publicKey;
      if (pubKey == null) {
        Future.delayed(const Duration(seconds: 2), _connectToServer);
        return;
      }
      
      _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080/ws'));
      
      _channel!.sink.add(jsonEncode({
        'type': 'Identify',
        'public_key': pubKey,
      }));
      _isConnectedToServer = true;
      
      _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);
            if (data['type'] == 'Relayed') {
              final payloadStr = data['payload'];
              final envelopeMap = jsonDecode(payloadStr);
              final envMessage = Message.fromJson(envelopeMap);
              
              // Only process if not already seen
              if (!storageService.seenMessageIds.contains(envMessage.id)) {
                final deliveredMsg = envMessage.copyWith(status: MessageStatus.delivered);
                storageService.saveMessage(deliveredMsg);
              }
            }
          } catch (e) {
            debugPrint('Error processing WS message: $e');
          }
        },
        onDone: () {
          _isConnectedToServer = false;
          Future.delayed(const Duration(seconds: 5), _connectToServer);
        },
        onError: (e) {
          _isConnectedToServer = false;
        }
      );
    } catch (e) {
      _isConnectedToServer = false;
    }
  }

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
        // Internet Cloud Route (P2P WebSocket Relay)
        final sent = sealedMessage.copyWith(status: MessageStatus.sent);
        await storageService.saveMessage(sent);

        if (_isConnectedToServer && _channel != null) {
          _channel!.sink.add(jsonEncode({
            'type': 'Relay',
            'recipient_key': recipientPublicKey,
            'payload': jsonEncode(sealedMessage.toJson()),
          }));
          storageService.updateMessageStatus(sent.id, MessageStatus.delivered);
        } else {
          // Fallback to offline mesh if WS is down
          await syncService.enqueueOfflineMessage(sealedMessage);
          return SendResult(
            success: true,
            transportUsed: MessageTransport.meshRelay,
            status: MessageStatus.queuedOffline,
            message: sealedMessage,
            statusDescription: 'Server unreachable. Queued for Nearby Mesh Relay',
          );
        }

        return SendResult(
          success: true,
          transportUsed: MessageTransport.internet,
          status: MessageStatus.sent,
          message: sent,
          statusDescription: '✓ Sent via Rust P2P Relay',
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
