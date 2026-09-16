import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/core/utils/date_formatter.dart';
import 'package:meshtalk_client/features/chat/domain/models/conversation.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:provider/provider.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final conversations = storage.conversations.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (c.lastMessage?.content.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryEmerald.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.hub_rounded, color: AppTheme.primaryEmerald, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('MeshTalk'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'My Node Identity',
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search conversations or messages...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // Conversation List
          Expanded(
            child: conversations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No conversations found',
                          style: TextStyle(fontSize: 16, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: conversations.length,
                    separatorBuilder: (ctx, i) => const Divider(height: 1, indent: 72),
                    itemBuilder: (context, index) {
                      final conv = conversations[index];
                      return _ConversationTile(conversation: conv);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryEmerald,
        foregroundColor: Colors.black,
        onPressed: () => context.push('/contacts'),
        tooltip: 'Start Conversation',
        child: const Icon(Icons.edit_note_rounded),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;

  const _ConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final lastMsg = conversation.lastMessage;

    Widget buildTransportBadge() {
      switch (conversation.activeTransport) {
        case MessageTransport.internet:
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.onlineColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_outlined, size: 11, color: AppTheme.onlineColor),
                SizedBox(width: 3),
                Text(
                  'Cloud',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onlineColor,
                  ),
                ),
              ],
            ),
          );
        case MessageTransport.bluetooth:
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.nearbyMeshColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bluetooth, size: 11, color: AppTheme.nearbyMeshColor),
                const SizedBox(width: 3),
                Text(
                  conversation.approximateDistance != null
                      ? 'BLE (${conversation.approximateDistance})'
                      : 'BLE',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.nearbyMeshColor,
                  ),
                ),
              ],
            ),
          );
        case MessageTransport.meshRelay:
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.meshCyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.alt_route, size: 11, color: AppTheme.meshCyan),
                SizedBox(width: 3),
                Text(
                  'Mesh Relay',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.meshCyan,
                  ),
                ),
              ],
            ),
          );
      }
    }

    return ListTile(
      onTap: () => context.push('/chats/${conversation.id}'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppTheme.darkCard,
            child: Text(
              conversation.avatarInitials ?? conversation.title[0],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          if (conversation.isNearby)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppTheme.nearbyMeshColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.darkBg, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversation.title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (lastMsg != null)
            Text(
              DateFormatter.formatConversationTime(lastMsg.createdAt),
              style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (lastMsg?.mediaType == MessageMediaType.image)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(Icons.image, size: 14, color: Color(0xFF94A3B8)),
                  ),
                Expanded(
                  child: Text(
                    lastMsg?.content ?? 'No messages yet',
                    style: TextStyle(
                      fontSize: 13,
                      color: conversation.unreadCount > 0
                          ? Colors.white
                          : const Color(0xFF94A3B8),
                      fontWeight: conversation.unreadCount > 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          buildTransportBadge(),
        ],
      ),
    );
  }
}
