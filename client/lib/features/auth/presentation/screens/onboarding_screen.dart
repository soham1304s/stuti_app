import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/core/crypto/crypto_helper.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/features/auth/domain/models/user_identity.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meshtalk_client/app/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _nameController = TextEditingController(text: 'Soham Mondal');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  late CryptographicIdentity _identity;
  bool _isGeneratingKeys = true;

  @override
  void initState() {
    super.initState();
    _generateKeys();
  }

  Future<void> _generateKeys() async {
    setState(() => _isGeneratingKeys = true);
    await Future.delayed(const Duration(milliseconds: 600));
    _identity = CryptoHelper.generateIdentity();
    if (mounted) {
      setState(() => _isGeneratingKeys = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final storage = ref.read(storageServiceProvider);
    final user = UserIdentity(
      id: _identity.deviceId,
      displayName: _nameController.text.trim().isEmpty
          ? 'Mesh Node'
          : _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      publicKey: _identity.publicKey,
      privateKey: _identity.privateKey,
      fingerprint: _identity.fingerprint,
      createdAt: DateTime.now(),
    );

    await storage.saveUserIdentity(user);
    if (mounted) {
      context.go('/chats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Logo / Icon
                  Center(
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryEmerald, AppTheme.meshCyan],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryEmerald.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.hub_rounded,
                        size: 46,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'MeshTalk',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Resilient, offline-first messaging that switches automatically between Internet and Bluetooth Low Energy mesh.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94A3B8),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Cryptographic Identity Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.shield_outlined,
                                color: AppTheme.primaryEmerald,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Cryptographic Identity',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                              if (_isGeneratingKeys)
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              else
                                IconButton(
                                  icon: const Icon(Icons.refresh, size: 18),
                                  tooltip: 'Regenerate Keys',
                                  onPressed: _generateKeys,
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Your private key is stored exclusively on this device. Off-grid communication uses your public key fingerprint for authentication.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                          ),
                          const SizedBox(height: 12),
                          if (!_isGeneratingKeys) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.fingerprint,
                                    size: 16,
                                    color: AppTheme.meshCyan,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _identity.fingerprint,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.2,
                                        color: AppTheme.meshCyan,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Form Fields
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (Optional for Cloud Sync)',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _isGeneratingKeys ? null : _completeOnboarding,
                    child: const Text('Initialize Node & Enter Mesh'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
