import os, re
path = 'lib/services/storage_service.dart'
with open(path, 'r') as f:
    content = f.read()

# I will replace the getOrCreateConversationForPeer function entirely to ensure correctness
content = re.sub(
    r'Conversation getOrCreateConversationForPeer.*?return newConv;\n  }',
    '''Conversation getOrCreateConversationForPeer({
    required String peerId,
    required String peerName,
    required String peerPublicKey,
    required String peerFingerprint,
    bool isNearby = false,
    String? approximateDistance,
  }) {
    final existing = _conversations.where((c) => c.peerId == peerId).firstOrNull;
    if (existing != null) return existing;

    final newConv = Conversation(
      id: 'conv-$peerId',
      title: peerName,
      peerId: peerId,
      peerPublicKey: peerPublicKey,
      peerFingerprint: peerFingerprint,
      isNearby: isNearby,
      approximateDistance: approximateDistance,
      avatarInitials: peerName.isNotEmpty ? peerName[0].toUpperCase() : '?',
      updatedAt: DateTime.now(),
    );

    dao.insertOrUpdateConversation(AppConversation(
      id: newConv.id,
      title: newConv.title,
      peerId: newConv.peerId,
      peerPublicKey: newConv.peerPublicKey,
      peerFingerprint: newConv.peerFingerprint,
      isGroup: newConv.isGroup,
      isNearby: newConv.isNearby,
      approximateDistance: newConv.approximateDistance,
      activeTransport: newConv.activeTransport.name,
      avatarInitials: newConv.avatarInitials,
      updatedAt: newConv.updatedAt,
      unreadCount: 0,
    ));

    return newConv;
  }''',
    content, flags=re.DOTALL
)

with open(path, 'w') as f:
    f.write(content)
