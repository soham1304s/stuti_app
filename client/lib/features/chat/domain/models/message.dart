import 'package:meshtalk_client/core/constants/app_constants.dart';

enum MessageMediaType {
  text,
  image,
  audio,
  document,
}

/// Message model adhering to the MeshTalk offline envelope specifications
class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String recipientId;
  final String senderName;
  final String content;
  final String? encryptedPayload;
  final String? nonce;
  final String? payloadHash;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int ttl;
  final int hopCount;
  final MessageStatus status;
  final MessageTransport transport;
  final List<String> relayPath;
  final MessageMediaType mediaType;
  final String? mediaUrl;
  final int? audioDurationSeconds;
  final String? replyToMessageId;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.recipientId,
    required this.senderName,
    required this.content,
    this.encryptedPayload,
    this.nonce,
    this.payloadHash,
    required this.createdAt,
    required this.expiresAt,
    this.ttl = AppConstants.defaultTTL,
    this.hopCount = 0,
    required this.status,
    required this.transport,
    this.relayPath = const [],
    this.mediaType = MessageMediaType.text,
    this.mediaUrl,
    this.audioDurationSeconds,
    this.replyToMessageId,
  });

  /// Check if the message has expired based on TTL or timestamp
  bool get isExpired => ttl <= 0 || DateTime.now().isAfter(expiresAt);

  /// Clone with modifications
  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? recipientId,
    String? senderName,
    String? content,
    String? encryptedPayload,
    String? nonce,
    String? payloadHash,
    DateTime? createdAt,
    DateTime? expiresAt,
    int? ttl,
    int? hopCount,
    MessageStatus? status,
    MessageTransport? transport,
    List<String>? relayPath,
    MessageMediaType? mediaType,
    String? mediaUrl,
    int? audioDurationSeconds,
    String? replyToMessageId,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      encryptedPayload: encryptedPayload ?? this.encryptedPayload,
      nonce: nonce ?? this.nonce,
      payloadHash: payloadHash ?? this.payloadHash,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      ttl: ttl ?? this.ttl,
      hopCount: hopCount ?? this.hopCount,
      status: status ?? this.status,
      transport: transport ?? this.transport,
      relayPath: relayPath ?? this.relayPath,
      mediaType: mediaType ?? this.mediaType,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      audioDurationSeconds: audioDurationSeconds ?? this.audioDurationSeconds,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderId': senderId,
        'recipientId': recipientId,
        'senderName': senderName,
        'content': content,
        'encryptedPayload': encryptedPayload,
        'nonce': nonce,
        'payloadHash': payloadHash,
        'createdAt': createdAt.toIso8601String(),
        'expiresAt': expiresAt.toIso8601String(),
        'ttl': ttl,
        'hopCount': hopCount,
        'status': status.name,
        'transport': transport.name,
        'relayPath': relayPath,
        'mediaType': mediaType.name,
        'mediaUrl': mediaUrl,
        'audioDurationSeconds': audioDurationSeconds,
        'replyToMessageId': replyToMessageId,
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      senderName: json['senderName'] as String,
      content: json['content'] as String,
      encryptedPayload: json['encryptedPayload'] as String?,
      nonce: json['nonce'] as String?,
      payloadHash: json['payloadHash'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      ttl: json['ttl'] as int? ?? AppConstants.defaultTTL,
      hopCount: json['hopCount'] as int? ?? 0,
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      transport: MessageTransport.values.firstWhere(
        (e) => e.name == json['transport'],
        orElse: () => MessageTransport.internet,
      ),
      relayPath: List<String>.from(json['relayPath'] ?? []),
      mediaType: MessageMediaType.values.firstWhere(
        (e) => e.name == json['mediaType'],
        orElse: () => MessageMediaType.text,
      ),
      mediaUrl: json['mediaUrl'] as String?,
      audioDurationSeconds: json['audioDurationSeconds'] as int?,
      replyToMessageId: json['replyToMessageId'] as String?,
    );
  }
}
