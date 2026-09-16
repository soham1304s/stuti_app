import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/core/crypto/crypto_helper.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';
import 'package:uuid/uuid.dart';

class EncryptionService {
  static const _uuid = Uuid();

  /// Packs a plaintext message into a sealed E2EE envelope
  Message sealMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String senderPrivateKey,
    required String recipientId,
    required String recipientPublicKey,
    required String plaintext,
    required MessageTransport transport,
    MessageMediaType mediaType = MessageMediaType.text,
    String? mediaUrl,
    int? audioDurationSeconds,
  }) {
    final messageId = _uuid.v4();
    final nonce = CryptoHelper.generateNonce();
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(hours: AppConstants.messageExpiryHours));

    final encryptedPayload = CryptoHelper.encryptPayload(
      plaintext: plaintext,
      recipientPublicKey: recipientPublicKey,
      senderPrivateKey: senderPrivateKey,
      nonce: nonce,
    );

    final payloadHash = CryptoHelper.computeHash(encryptedPayload);

    return Message(
      id: messageId,
      conversationId: conversationId,
      senderId: senderId,
      recipientId: recipientId,
      senderName: senderName,
      content: plaintext,
      encryptedPayload: encryptedPayload,
      nonce: nonce,
      payloadHash: payloadHash,
      createdAt: now,
      expiresAt: expiresAt,
      ttl: AppConstants.defaultTTL,
      hopCount: 0,
      status: MessageStatus.sending,
      transport: transport,
      mediaType: mediaType,
      mediaUrl: mediaUrl,
      audioDurationSeconds: audioDurationSeconds,
    );
  }

  /// Verifies payload integrity and unseals an incoming message envelope
  String unsealMessage({
    required Message message,
    required String recipientPrivateKey,
    required String senderPublicKey,
  }) {
    if (message.encryptedPayload == null || message.nonce == null) {
      return message.content;
    }

    // Verify hash integrity
    if (message.payloadHash != null) {
      final computedHash = CryptoHelper.computeHash(message.encryptedPayload!);
      if (computedHash != message.payloadHash) {
        return '[Integrity Failure: Message payload was tampered with in transit]';
      }
    }

    return CryptoHelper.decryptPayload(
      ciphertext: message.encryptedPayload!,
      senderPublicKey: senderPublicKey,
      recipientPrivateKey: recipientPrivateKey,
      nonce: message.nonce!,
    );
  }
}
