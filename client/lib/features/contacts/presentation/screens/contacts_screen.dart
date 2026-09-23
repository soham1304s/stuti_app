import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/features/contacts/domain/models/contact.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meshtalk_client/app/providers.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  String _query = '';

  void _showFingerprintVerification(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Row(
          children: [
            const Icon(Icons.shield_outlined, color: AppTheme.primaryEmerald),
            const SizedBox(width: 8),
            Text(contact.name),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verified Public Fingerprint:',
              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Center(
                child: Text(
                  contact.fingerprint,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    fontSize: 14,
                    color: AppTheme.meshCyan,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: AppTheme.onlineColor),
                SizedBox(width: 6),
                Text(
                  'End-to-End Encryption Verified',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  void _openChatWithContact(Contact contact) {
    final storage = ref.read(storageServiceProvider);
    final conversation = storage.getOrCreateConversationForPeer(
      peerId: contact.id,
      peerName: contact.name,
      peerPublicKey: contact.publicKey,
      peerFingerprint: contact.fingerprint,
      isNearby: contact.isNearby,
      approximateDistance: contact.approximateDistance,
    );
    context.push('/chats/${conversation.id}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final searchBgColor = isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade300;
    
    final storage = ref.watch(storageServiceProvider);
    final contacts = storage.contacts.where((c) {
      if (_query.isEmpty) return true;
      return c.name.toLowerCase().contains(_query.toLowerCase()) ||
          c.phone.contains(_query);
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'People',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primaryEmerald),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.person_add,
                      color: AppTheme.primaryEmerald,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search people...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: searchBgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: textColor),
                onChanged: (val) => setState(() => _query = val),
              ),
            ),
          Expanded(
            child: ListView.separated(
              itemCount: contacts.length,
              separatorBuilder: (c, i) => const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.darkCard,
                    child: Text(
                      contact.name[0],
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        contact.name,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      const SizedBox(width: 8),
                      if (contact.isNearby)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.nearbyMeshColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'BLE ${contact.approximateDistance ?? "Nearby"}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.nearbyMeshColor,
                            ),
                          ),
                        )
                      else if (contact.isOnline)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.onlineColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onlineColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Text(
                    'Key: ${contact.fingerprint.substring(0, 9)}...',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.qr_code, size: 20),
                        tooltip: 'View Fingerprint',
                        onPressed: () => _showFingerprintVerification(context, contact),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline, size: 20),
                        tooltip: 'Start Chat',
                        onPressed: () => _openChatWithContact(contact),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}
