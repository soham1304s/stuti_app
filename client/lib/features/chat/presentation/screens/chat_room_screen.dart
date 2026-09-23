import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/core/utils/date_formatter.dart';
import 'package:meshtalk_client/features/chat/domain/models/conversation.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';
import 'package:meshtalk_client/services/connectivity_service.dart';
import 'package:meshtalk_client/services/nearby_device_service.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:meshtalk_client/services/transport_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meshtalk_client/app/providers.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatRoomScreen({super.key, required this.conversationId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isComposing = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleSend(Conversation conversation) async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    setState(() => _isComposing = false);

    final transportManager = ref.read(transportManagerProvider);
    final result = await transportManager.sendMessage(
      conversationId: conversation.id,
      recipientId: conversation.peerId,
      recipientPublicKey: conversation.peerPublicKey,
      plaintext: text,
    );

    if (mounted) {
      _scrollToBottom();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.statusDescription),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _sendSimulatedMedia(Conversation conversation, MessageMediaType type) async {
    final transportManager = ref.read(transportManagerProvider);
    await transportManager.sendMessage(
      conversationId: conversation.id,
      recipientId: conversation.peerId,
      recipientPublicKey: conversation.peerPublicKey,
      plaintext: type == MessageMediaType.image
          ? '🖼️ Emergency Area Map coordinate packet'
          : '🎙️ Voice note (12s compressed)',
      mediaType: type,
      audioDurationSeconds: type == MessageMediaType.audio ? 12 : null,
    );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(storageServiceProvider);
    final connectivity = ref.watch(connectivityServiceProvider);
    final nearby = ref.watch(nearbyDeviceServiceProvider);
    final transportManager = ref.read(transportManagerProvider);

    final conversation = storage.getConversationById(widget.conversationId);
    if (conversation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: const Center(child: Text('Conversation not found')),
      );
    }

    final messages = storage.getMessagesForConversation(conversation.id);
    final myId = storage.currentUser?.id ?? '';

    // Determine predicted active transport
    final activeTransport = transportManager.predictActiveTransport(
      conversation.peerPublicKey,
    );

    final nearbyPeer = nearby.findDeviceByPublicKey(conversation.peerPublicKey);
    final isPeerNearby = nearbyPeer != null;

    String peerStatusSubtitle;
    Color peerStatusColor;
    if (connectivity.isInternetAvailable) {
      peerStatusSubtitle = '🟢 Online via Cloud';
      peerStatusColor = AppTheme.onlineColor;
    } else if (isPeerNearby) {
      peerStatusSubtitle = '🔵 Direct BLE (${nearbyPeer.approximateDistance})';
      peerStatusColor = AppTheme.nearbyMeshColor;
    } else {
      peerStatusSubtitle = '⚫ Offline • Store & Forward Mesh';
      peerStatusColor = AppTheme.offlineColor;
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.darkCard,
              child: Text(
                conversation.avatarInitials ?? conversation.title[0],
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    peerStatusSubtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: peerStatusColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            tooltip: 'Audio Call',
            onPressed: () => context.push('/calls?name=${conversation.title}&type=audio'),
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            tooltip: 'Video Call',
            onPressed: () => context.push('/calls?name=${conversation.title}&type=video'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Key Fingerprint',
            onPressed: () => _showFingerprintModal(context, conversation),
          ),
        ],
      ),
      body: Column(
        children: [
          // Dynamic Active Transport Indicator Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: activeTransport == MessageTransport.internet
                ? AppTheme.onlineColor.withValues(alpha: 0.1)
                : activeTransport == MessageTransport.bluetooth
                    ? AppTheme.nearbyMeshColor.withValues(alpha: 0.12)
                    : AppTheme.meshCyan.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(
                  activeTransport == MessageTransport.internet
                      ? Icons.cloud_outlined
                      : activeTransport == MessageTransport.bluetooth
                          ? Icons.bluetooth_connected
                          : Icons.alt_route,
                  size: 14,
                  color: activeTransport == MessageTransport.internet
                      ? AppTheme.onlineColor
                      : activeTransport == MessageTransport.bluetooth
                          ? AppTheme.nearbyMeshColor
                          : AppTheme.meshCyan,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    activeTransport == MessageTransport.internet
                        ? 'Transport: Internet Cloud'
                        : activeTransport == MessageTransport.bluetooth
                            ? 'Transport: Nearby Bluetooth Low Energy (Direct)'
                            : 'Transport: Multi-Hop Store & Forward Mesh Relay',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Message Stream
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_clock,
                          size: 36,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'End-to-End Encrypted Session',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Messages switch automatically between Cloud & BLE.',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderId == myId;
                      return _MessageBubble(message: message, isMe: isMe);
                    },
                  ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? AppTheme.darkSurface : Colors.grey.shade100,
              border: Border(
                top: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF334155) : Colors.grey.shade300, width: 0.5),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Color(0xFF94A3B8)),
                    tooltip: 'Send Media',
                    onPressed: () => _showAttachmentSheet(context, conversation),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 4,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: 'Type an encrypted message...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onChanged: (val) {
                        setState(() => _isComposing = val.trim().isNotEmpty);
                      },
                      onSubmitted: (_) => _handleSend(conversation),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_isComposing)
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.primaryEmerald,
                        foregroundColor: Colors.black,
                      ),
                      icon: const Icon(Icons.send_rounded, size: 20),
                      onPressed: () => _handleSend(conversation),
                    )
                  else
                    IconButton.filledTonal(
                      icon: const Icon(Icons.mic, size: 20),
                      tooltip: 'Record Voice Note',
                      onPressed: () => _sendSimulatedMedia(conversation, MessageMediaType.audio),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentSheet(BuildContext context, Conversation conversation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image, color: AppTheme.meshCyan),
                title: const Text('Send Image (Chunked Transfer)'),
                subtitle: const Text('Splits into chunks for reliable offline mesh transfer'),
                onTap: () {
                  Navigator.pop(ctx);
                  _sendSimulatedMedia(conversation, MessageMediaType.image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.mic, color: AppTheme.primaryEmerald),
                title: const Text('Voice Note'),
                subtitle: const Text('Compressed audio packet'),
                onTap: () {
                  Navigator.pop(ctx);
                  _sendSimulatedMedia(conversation, MessageMediaType.audio);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFingerprintModal(BuildContext context, Conversation conversation) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Row(
          children: [
            const Icon(Icons.verified_user, color: AppTheme.primaryEmerald),
            const SizedBox(width: 8),
            Text(conversation.title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Public Identity Fingerprint:',
              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                conversation.peerFingerprint,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 1.2,
                  color: AppTheme.meshCyan,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Compare this fingerprint in person to verify this peer and eliminate man-in-the-middle attacks.',
              style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  final Message message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  Widget _buildStatusIndicator() {
    if (!isMe) return const SizedBox.shrink();

    IconData icon;
    Color color;
    String tooltip;

    switch (message.status) {
      case MessageStatus.pending:
      case MessageStatus.sending:
        icon = Icons.access_time;
        color = const Color(0xFF94A3B8);
        tooltip = 'Sending...';
        break;
      case MessageStatus.queuedOffline:
        icon = Icons.hourglass_top_rounded;
        color = AppTheme.connectingColor;
        tooltip = 'Queued offline';
        break;
      case MessageStatus.sent:
        icon = Icons.check;
        color = const Color(0xFF94A3B8);
        tooltip = 'Sent to relay';
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = message.transport == MessageTransport.bluetooth
            ? AppTheme.nearbyMeshColor
            : AppTheme.onlineColor;
        tooltip = 'Delivered';
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = AppTheme.meshCyan;
        tooltip = 'Read';
        break;
      case MessageStatus.forwarded:
        icon = Icons.alt_route;
        color = AppTheme.meshCyan;
        tooltip = 'Forwarded via ${message.hopCount} hops';
        break;
      case MessageStatus.failed:
        icon = Icons.error_outline;
        color = Colors.redAccent;
        tooltip = 'Failed';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Tooltip(
        message: tooltip,
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }

  Widget _buildTransportLabel() {
    String label;
    IconData icon;
    Color color;

    switch (message.transport) {
      case MessageTransport.internet:
        label = '✓ Sent via Internet';
        icon = Icons.cloud_done_outlined;
        color = AppTheme.onlineColor;
        break;
      case MessageTransport.bluetooth:
        label = '✓ Sent via Bluetooth';
        icon = Icons.bluetooth;
        color = AppTheme.nearbyMeshColor;
        break;
      case MessageTransport.meshRelay:
        label = message.hopCount > 0
            ? '↗ Forwarded through ${message.hopCount} devices'
            : '⏱ Queued for Mesh';
        icon = Icons.alt_route;
        color = AppTheme.meshCyan;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? (isDark ? const Color(0xFF5A2500) : Colors.orange.shade100) // Dark Orange Container or light orange
              : (isDark ? AppTheme.darkCard : Colors.grey.shade200),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: Border.all(
            color: isMe
                ? AppTheme.primaryEmerald.withValues(alpha: 0.3)
                : (isDark ? const Color(0xFF475569) : Colors.grey.shade300),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Media Preview if Image
            if (message.mediaType == MessageMediaType.image) ...[
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map_outlined, size: 40, color: AppTheme.meshCyan),
                      SizedBox(height: 6),
                      Text(
                        'Offline Map Chunk (Verified)',
                        style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],

            // Voice Note Waveform Preview if Audio
            if (message.mediaType == MessageMediaType.audio) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.play_circle_fill, size: 28, color: AppTheme.primaryEmerald),
                  const SizedBox(width: 8),
                  Container(
                    height: 18,
                    width: 120,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        16,
                        (i) => Container(
                          width: 2,
                          height: (i % 4 + 1) * 3.5,
                          color: AppTheme.primaryEmerald,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${message.audioDurationSeconds ?? 12}s',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],

            // Content Text
            Text(
              message.content,
              style: TextStyle(
                fontSize: 15,
                color: textColor,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),

            // Time, Status, and Transport Tag
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTransportLabel(),
                const SizedBox(width: 8),
                Text(
                  DateFormatter.formatMessageTime(message.createdAt),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                _buildStatusIndicator(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
