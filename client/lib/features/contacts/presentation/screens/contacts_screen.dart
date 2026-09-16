import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/features/contacts/domain/models/contact.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
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
    final storage = context.read<StorageService>();
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
    final storage = context.watch<StorageService>();
    final contacts = storage.contacts.where((c) {
      if (_query.isEmpty) return true;
      return c.name.toLowerCase().contains(_query.toLowerCase()) ||
          c.phone.contains(_query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesh Contacts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search verified nodes by name or phone...',
                prefixIcon: Icon(Icons.search, size: 20),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
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
    );
  }
}
