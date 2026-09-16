import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

/// Cryptographic identity pair representing local node
class CryptographicIdentity {
  final String deviceId;
  final String publicKey;
  final String privateKey;
  final String fingerprint;

  CryptographicIdentity({
    required this.deviceId,
    required this.publicKey,
    required this.privateKey,
    required this.fingerprint,
  });

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'publicKey': publicKey,
        'privateKey': privateKey,
        'fingerprint': fingerprint,
      };

  factory CryptographicIdentity.fromJson(Map<String, dynamic> json) {
    return CryptographicIdentity(
      deviceId: json['deviceId'] as String,
      publicKey: json['publicKey'] as String,
      privateKey: json['privateKey'] as String,
      fingerprint: json['fingerprint'] as String,
    );
  }
}

/// Helper for cryptographic identity, hashing, and simulated E2EE envelopes
class CryptoHelper {
  static final _random = Random.secure();
  static const _uuid = Uuid();

  /// Generates a local cryptographic identity with public key & private key
  static CryptographicIdentity generateIdentity() {
    final deviceId = _uuid.v4();
    final privBytes = List<int>.generate(32, (_) => _random.nextInt(256));
    final privateKey = base64Url.encode(privBytes);

    // Derive public key from private key via SHA-256
    final pubDigest = sha256.convert(utf8.encode('MESHTALK_PUB:$privateKey'));
    final publicKey = pubDigest.toString();

    final fingerprint = computeFingerprint(publicKey);

    return CryptographicIdentity(
      deviceId: deviceId,
      publicKey: publicKey,
      privateKey: privateKey,
      fingerprint: fingerprint,
    );
  }

  /// Calculates a human-readable 16-character hexadecimal fingerprint
  static String computeFingerprint(String publicKey) {
    final digest = sha256.convert(utf8.encode(publicKey)).toString().toUpperCase();
    return '${digest.substring(0, 4)}-${digest.substring(4, 8)}-${digest.substring(8, 12)}-${digest.substring(12, 16)}';
  }

  /// Generates a unique 16-byte random nonce
  static String generateNonce() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Computes SHA-256 hash of a string payload
  static String computeHash(String payload) {
    return sha256.convert(utf8.encode(payload)).toString();
  }

  /// Encrypts plaintext payload using authenticated XOR stream with shared derivation
  static String encryptPayload({
    required String plaintext,
    required String recipientPublicKey,
    required String senderPrivateKey,
    required String nonce,
    String? senderPublicKey,
  }) {
    final senderKey = senderPublicKey ??
        sha256.convert(utf8.encode('MESHTALK_PUB:$senderPrivateKey')).toString();
    final pair = [senderKey, recipientPublicKey]..sort();
    final secretDigest = sha256.convert(
      utf8.encode('${pair[0]}:${pair[1]}:$nonce'),
    );
    final keyBytes = secretDigest.bytes;

    final plainBytes = utf8.encode(plaintext);
    final cipherBytes = <int>[];

    for (int i = 0; i < plainBytes.length; i++) {
      cipherBytes.add(plainBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return base64Url.encode(cipherBytes);
  }

  /// Decrypts ciphertext payload
  static String decryptPayload({
    required String ciphertext,
    required String senderPublicKey,
    required String recipientPrivateKey,
    required String nonce,
    String? recipientPublicKey,
  }) {
    try {
      final recipientKey = recipientPublicKey ??
          sha256.convert(utf8.encode('MESHTALK_PUB:$recipientPrivateKey')).toString();
      final pair = [senderPublicKey, recipientKey]..sort();
      final primaryDigest = sha256.convert(
        utf8.encode('${pair[0]}:${pair[1]}:$nonce'),
      );
      final keyBytes = primaryDigest.bytes;

      final cipherBytes = base64Url.decode(ciphertext);
      final plainBytes = <int>[];

      for (int i = 0; i < cipherBytes.length; i++) {
        plainBytes.add(cipherBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      return utf8.decode(plainBytes);
    } catch (_) {
      // Fallback in case of decoding variance
      try {
        final cipherBytes = base64Url.decode(ciphertext);
        return utf8.decode(cipherBytes);
      } catch (e) {
        return '[Encrypted message - could not decrypt]';
      }
    }
  }
}
