import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';

class Conversation {
  final String id;
  final String title;
  final String peerId;
  final String peerPublicKey;
  final String peerFingerprint;
  final Message? lastMessage;
  final int unreadCount;
  final bool isGroup;
  final bool isNearby;
  final String? approximateDistance;
  final MessageTransport activeTransport;
  final String? avatarInitials;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.title,
    required this.peerId,
    required this.peerPublicKey,
    required this.peerFingerprint,
    this.lastMessage,
    this.unreadCount = 0,
    this.isGroup = false,
    this.isNearby = false,
    this.approximateDistance,
    this.activeTransport = MessageTransport.internet,
    this.avatarInitials,
    required this.updatedAt,
  });

  Conversation copyWith({
    String? id,
    String? title,
    String? peerId,
    String? peerPublicKey,
    String? peerFingerprint,
    Message? lastMessage,
    int? unreadCount,
    bool? isGroup,
    bool? isNearby,
    String? approximateDistance,
    MessageTransport? activeTransport,
    String? avatarInitials,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      peerId: peerId ?? this.peerId,
      peerPublicKey: peerPublicKey ?? this.peerPublicKey,
      peerFingerprint: peerFingerprint ?? this.peerFingerprint,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      isGroup: isGroup ?? this.isGroup,
      isNearby: isNearby ?? this.isNearby,
      approximateDistance: approximateDistance ?? this.approximateDistance,
      activeTransport: activeTransport ?? this.activeTransport,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'peerId': peerId,
        'peerPublicKey': peerPublicKey,
        'peerFingerprint': peerFingerprint,
        'lastMessage': lastMessage?.toJson(),
        'unreadCount': unreadCount,
        'isGroup': isGroup,
        'isNearby': isNearby,
        'approximateDistance': approximateDistance,
        'activeTransport': activeTransport.name,
        'avatarInitials': avatarInitials,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      title: json['title'] as String,
      peerId: json['peerId'] as String,
      peerPublicKey: json['peerPublicKey'] as String,
      peerFingerprint: json['peerFingerprint'] as String,
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isGroup: json['isGroup'] as bool? ?? false,
      isNearby: json['isNearby'] as bool? ?? false,
      approximateDistance: json['approximateDistance'] as String?,
      activeTransport: MessageTransport.values.firstWhere(
        (e) => e.name == json['activeTransport'],
        orElse: () => MessageTransport.internet,
      ),
      avatarInitials: json['avatarInitials'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
