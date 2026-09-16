import 'package:flutter_test/flutter_test.dart';
import 'package:meshtalk_client/core/crypto/crypto_helper.dart';

void main() {
  group('CryptoHelper & E2EE Envelope Tests', () {
    test('generateIdentity creates valid keypair and formatted fingerprint', () {
      final identity = CryptoHelper.generateIdentity();

      expect(identity.deviceId.isNotEmpty, isTrue);
      expect(identity.publicKey.isNotEmpty, isTrue);
      expect(identity.privateKey.isNotEmpty, isTrue);
      expect(identity.fingerprint.contains('-'), isTrue);
      expect(identity.fingerprint.split('-').length, equals(4));
    });

    test('encryptPayload and decryptPayload round-trip successfully', () {
      final alice = CryptoHelper.generateIdentity();
      final bob = CryptoHelper.generateIdentity();
      final nonce = CryptoHelper.generateNonce();
      const plaintext = 'Secret offline mesh packet #42';

      final ciphertext = CryptoHelper.encryptPayload(
        plaintext: plaintext,
        recipientPublicKey: bob.publicKey,
        senderPrivateKey: alice.privateKey,
        nonce: nonce,
      );

      expect(ciphertext != plaintext, isTrue);

      final decrypted = CryptoHelper.decryptPayload(
        ciphertext: ciphertext,
        senderPublicKey: alice.publicKey,
        recipientPrivateKey: bob.privateKey,
        nonce: nonce,
      );

      expect(decrypted, equals(plaintext));
    });

    test('computeHash produces deterministic SHA-256 string', () {
      const payload = 'MeshTalk Protocol v1 Packet';
      final hash1 = CryptoHelper.computeHash(payload);
      final hash2 = CryptoHelper.computeHash(payload);

      expect(hash1, equals(hash2));
      expect(hash1.length, equals(64)); // 32 bytes hex
    });
  });
}
