// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AppMessagesTable extends AppMessages
    with TableInfo<$AppMessagesTable, AppMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipientIdMeta = const VerificationMeta(
    'recipientId',
  );
  @override
  late final GeneratedColumn<String> recipientId = GeneratedColumn<String>(
    'recipient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderNameMeta = const VerificationMeta(
    'senderName',
  );
  @override
  late final GeneratedColumn<String> senderName = GeneratedColumn<String>(
    'sender_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encryptedPayloadMeta = const VerificationMeta(
    'encryptedPayload',
  );
  @override
  late final GeneratedColumn<String> encryptedPayload = GeneratedColumn<String>(
    'encrypted_payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedColumn<String> nonce = GeneratedColumn<String>(
    'nonce',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadHashMeta = const VerificationMeta(
    'payloadHash',
  );
  @override
  late final GeneratedColumn<String> payloadHash = GeneratedColumn<String>(
    'payload_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ttlMeta = const VerificationMeta('ttl');
  @override
  late final GeneratedColumn<int> ttl = GeneratedColumn<int>(
    'ttl',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _hopCountMeta = const VerificationMeta(
    'hopCount',
  );
  @override
  late final GeneratedColumn<int> hopCount = GeneratedColumn<int>(
    'hop_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transportMeta = const VerificationMeta(
    'transport',
  );
  @override
  late final GeneratedColumn<String> transport = GeneratedColumn<String>(
    'transport',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> relayPath =
      GeneratedColumn<String>(
        'relay_path',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($AppMessagesTable.$converterrelayPath);
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('text'),
  );
  static const VerificationMeta _mediaUrlMeta = const VerificationMeta(
    'mediaUrl',
  );
  @override
  late final GeneratedColumn<String> mediaUrl = GeneratedColumn<String>(
    'media_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioDurationSecondsMeta =
      const VerificationMeta('audioDurationSeconds');
  @override
  late final GeneratedColumn<int> audioDurationSeconds = GeneratedColumn<int>(
    'audio_duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replyToMessageIdMeta = const VerificationMeta(
    'replyToMessageId',
  );
  @override
  late final GeneratedColumn<String> replyToMessageId = GeneratedColumn<String>(
    'reply_to_message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    senderId,
    recipientId,
    senderName,
    content,
    encryptedPayload,
    nonce,
    payloadHash,
    createdAt,
    expiresAt,
    ttl,
    hopCount,
    status,
    transport,
    relayPath,
    mediaType,
    mediaUrl,
    audioDurationSeconds,
    replyToMessageId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('recipient_id')) {
      context.handle(
        _recipientIdMeta,
        recipientId.isAcceptableOrUnknown(
          data['recipient_id']!,
          _recipientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientIdMeta);
    }
    if (data.containsKey('sender_name')) {
      context.handle(
        _senderNameMeta,
        senderName.isAcceptableOrUnknown(data['sender_name']!, _senderNameMeta),
      );
    } else if (isInserting) {
      context.missing(_senderNameMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('encrypted_payload')) {
      context.handle(
        _encryptedPayloadMeta,
        encryptedPayload.isAcceptableOrUnknown(
          data['encrypted_payload']!,
          _encryptedPayloadMeta,
        ),
      );
    }
    if (data.containsKey('nonce')) {
      context.handle(
        _nonceMeta,
        nonce.isAcceptableOrUnknown(data['nonce']!, _nonceMeta),
      );
    }
    if (data.containsKey('payload_hash')) {
      context.handle(
        _payloadHashMeta,
        payloadHash.isAcceptableOrUnknown(
          data['payload_hash']!,
          _payloadHashMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('ttl')) {
      context.handle(
        _ttlMeta,
        ttl.isAcceptableOrUnknown(data['ttl']!, _ttlMeta),
      );
    }
    if (data.containsKey('hop_count')) {
      context.handle(
        _hopCountMeta,
        hopCount.isAcceptableOrUnknown(data['hop_count']!, _hopCountMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('transport')) {
      context.handle(
        _transportMeta,
        transport.isAcceptableOrUnknown(data['transport']!, _transportMeta),
      );
    } else if (isInserting) {
      context.missing(_transportMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    }
    if (data.containsKey('media_url')) {
      context.handle(
        _mediaUrlMeta,
        mediaUrl.isAcceptableOrUnknown(data['media_url']!, _mediaUrlMeta),
      );
    }
    if (data.containsKey('audio_duration_seconds')) {
      context.handle(
        _audioDurationSecondsMeta,
        audioDurationSeconds.isAcceptableOrUnknown(
          data['audio_duration_seconds']!,
          _audioDurationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('reply_to_message_id')) {
      context.handle(
        _replyToMessageIdMeta,
        replyToMessageId.isAcceptableOrUnknown(
          data['reply_to_message_id']!,
          _replyToMessageIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      recipientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipient_id'],
      )!,
      senderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_name'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      encryptedPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_payload'],
      ),
      nonce: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nonce'],
      ),
      payloadHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_hash'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
      ttl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ttl'],
      )!,
      hopCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hop_count'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      transport: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transport'],
      )!,
      relayPath: $AppMessagesTable.$converterrelayPath.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}relay_path'],
        )!,
      ),
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      mediaUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_url'],
      ),
      audioDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}audio_duration_seconds'],
      ),
      replyToMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_to_message_id'],
      ),
    );
  }

  @override
  $AppMessagesTable createAlias(String alias) {
    return $AppMessagesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterrelayPath =
      const StringListConverter();
}

class AppMessage extends DataClass implements Insertable<AppMessage> {
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
  final String status;
  final String transport;
  final List<String> relayPath;
  final String mediaType;
  final String? mediaUrl;
  final int? audioDurationSeconds;
  final String? replyToMessageId;
  const AppMessage({
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
    required this.ttl,
    required this.hopCount,
    required this.status,
    required this.transport,
    required this.relayPath,
    required this.mediaType,
    this.mediaUrl,
    this.audioDurationSeconds,
    this.replyToMessageId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['sender_id'] = Variable<String>(senderId);
    map['recipient_id'] = Variable<String>(recipientId);
    map['sender_name'] = Variable<String>(senderName);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || encryptedPayload != null) {
      map['encrypted_payload'] = Variable<String>(encryptedPayload);
    }
    if (!nullToAbsent || nonce != null) {
      map['nonce'] = Variable<String>(nonce);
    }
    if (!nullToAbsent || payloadHash != null) {
      map['payload_hash'] = Variable<String>(payloadHash);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    map['ttl'] = Variable<int>(ttl);
    map['hop_count'] = Variable<int>(hopCount);
    map['status'] = Variable<String>(status);
    map['transport'] = Variable<String>(transport);
    {
      map['relay_path'] = Variable<String>(
        $AppMessagesTable.$converterrelayPath.toSql(relayPath),
      );
    }
    map['media_type'] = Variable<String>(mediaType);
    if (!nullToAbsent || mediaUrl != null) {
      map['media_url'] = Variable<String>(mediaUrl);
    }
    if (!nullToAbsent || audioDurationSeconds != null) {
      map['audio_duration_seconds'] = Variable<int>(audioDurationSeconds);
    }
    if (!nullToAbsent || replyToMessageId != null) {
      map['reply_to_message_id'] = Variable<String>(replyToMessageId);
    }
    return map;
  }

  AppMessagesCompanion toCompanion(bool nullToAbsent) {
    return AppMessagesCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      senderId: Value(senderId),
      recipientId: Value(recipientId),
      senderName: Value(senderName),
      content: Value(content),
      encryptedPayload: encryptedPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedPayload),
      nonce: nonce == null && nullToAbsent
          ? const Value.absent()
          : Value(nonce),
      payloadHash: payloadHash == null && nullToAbsent
          ? const Value.absent()
          : Value(payloadHash),
      createdAt: Value(createdAt),
      expiresAt: Value(expiresAt),
      ttl: Value(ttl),
      hopCount: Value(hopCount),
      status: Value(status),
      transport: Value(transport),
      relayPath: Value(relayPath),
      mediaType: Value(mediaType),
      mediaUrl: mediaUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaUrl),
      audioDurationSeconds: audioDurationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(audioDurationSeconds),
      replyToMessageId: replyToMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToMessageId),
    );
  }

  factory AppMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMessage(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      recipientId: serializer.fromJson<String>(json['recipientId']),
      senderName: serializer.fromJson<String>(json['senderName']),
      content: serializer.fromJson<String>(json['content']),
      encryptedPayload: serializer.fromJson<String?>(json['encryptedPayload']),
      nonce: serializer.fromJson<String?>(json['nonce']),
      payloadHash: serializer.fromJson<String?>(json['payloadHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      ttl: serializer.fromJson<int>(json['ttl']),
      hopCount: serializer.fromJson<int>(json['hopCount']),
      status: serializer.fromJson<String>(json['status']),
      transport: serializer.fromJson<String>(json['transport']),
      relayPath: serializer.fromJson<List<String>>(json['relayPath']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      mediaUrl: serializer.fromJson<String?>(json['mediaUrl']),
      audioDurationSeconds: serializer.fromJson<int?>(
        json['audioDurationSeconds'],
      ),
      replyToMessageId: serializer.fromJson<String?>(json['replyToMessageId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'senderId': serializer.toJson<String>(senderId),
      'recipientId': serializer.toJson<String>(recipientId),
      'senderName': serializer.toJson<String>(senderName),
      'content': serializer.toJson<String>(content),
      'encryptedPayload': serializer.toJson<String?>(encryptedPayload),
      'nonce': serializer.toJson<String?>(nonce),
      'payloadHash': serializer.toJson<String?>(payloadHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'ttl': serializer.toJson<int>(ttl),
      'hopCount': serializer.toJson<int>(hopCount),
      'status': serializer.toJson<String>(status),
      'transport': serializer.toJson<String>(transport),
      'relayPath': serializer.toJson<List<String>>(relayPath),
      'mediaType': serializer.toJson<String>(mediaType),
      'mediaUrl': serializer.toJson<String?>(mediaUrl),
      'audioDurationSeconds': serializer.toJson<int?>(audioDurationSeconds),
      'replyToMessageId': serializer.toJson<String?>(replyToMessageId),
    };
  }

  AppMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? recipientId,
    String? senderName,
    String? content,
    Value<String?> encryptedPayload = const Value.absent(),
    Value<String?> nonce = const Value.absent(),
    Value<String?> payloadHash = const Value.absent(),
    DateTime? createdAt,
    DateTime? expiresAt,
    int? ttl,
    int? hopCount,
    String? status,
    String? transport,
    List<String>? relayPath,
    String? mediaType,
    Value<String?> mediaUrl = const Value.absent(),
    Value<int?> audioDurationSeconds = const Value.absent(),
    Value<String?> replyToMessageId = const Value.absent(),
  }) => AppMessage(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    senderId: senderId ?? this.senderId,
    recipientId: recipientId ?? this.recipientId,
    senderName: senderName ?? this.senderName,
    content: content ?? this.content,
    encryptedPayload: encryptedPayload.present
        ? encryptedPayload.value
        : this.encryptedPayload,
    nonce: nonce.present ? nonce.value : this.nonce,
    payloadHash: payloadHash.present ? payloadHash.value : this.payloadHash,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt ?? this.expiresAt,
    ttl: ttl ?? this.ttl,
    hopCount: hopCount ?? this.hopCount,
    status: status ?? this.status,
    transport: transport ?? this.transport,
    relayPath: relayPath ?? this.relayPath,
    mediaType: mediaType ?? this.mediaType,
    mediaUrl: mediaUrl.present ? mediaUrl.value : this.mediaUrl,
    audioDurationSeconds: audioDurationSeconds.present
        ? audioDurationSeconds.value
        : this.audioDurationSeconds,
    replyToMessageId: replyToMessageId.present
        ? replyToMessageId.value
        : this.replyToMessageId,
  );
  AppMessage copyWithCompanion(AppMessagesCompanion data) {
    return AppMessage(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      recipientId: data.recipientId.present
          ? data.recipientId.value
          : this.recipientId,
      senderName: data.senderName.present
          ? data.senderName.value
          : this.senderName,
      content: data.content.present ? data.content.value : this.content,
      encryptedPayload: data.encryptedPayload.present
          ? data.encryptedPayload.value
          : this.encryptedPayload,
      nonce: data.nonce.present ? data.nonce.value : this.nonce,
      payloadHash: data.payloadHash.present
          ? data.payloadHash.value
          : this.payloadHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      ttl: data.ttl.present ? data.ttl.value : this.ttl,
      hopCount: data.hopCount.present ? data.hopCount.value : this.hopCount,
      status: data.status.present ? data.status.value : this.status,
      transport: data.transport.present ? data.transport.value : this.transport,
      relayPath: data.relayPath.present ? data.relayPath.value : this.relayPath,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      mediaUrl: data.mediaUrl.present ? data.mediaUrl.value : this.mediaUrl,
      audioDurationSeconds: data.audioDurationSeconds.present
          ? data.audioDurationSeconds.value
          : this.audioDurationSeconds,
      replyToMessageId: data.replyToMessageId.present
          ? data.replyToMessageId.value
          : this.replyToMessageId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMessage(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderId: $senderId, ')
          ..write('recipientId: $recipientId, ')
          ..write('senderName: $senderName, ')
          ..write('content: $content, ')
          ..write('encryptedPayload: $encryptedPayload, ')
          ..write('nonce: $nonce, ')
          ..write('payloadHash: $payloadHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('ttl: $ttl, ')
          ..write('hopCount: $hopCount, ')
          ..write('status: $status, ')
          ..write('transport: $transport, ')
          ..write('relayPath: $relayPath, ')
          ..write('mediaType: $mediaType, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('audioDurationSeconds: $audioDurationSeconds, ')
          ..write('replyToMessageId: $replyToMessageId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    senderId,
    recipientId,
    senderName,
    content,
    encryptedPayload,
    nonce,
    payloadHash,
    createdAt,
    expiresAt,
    ttl,
    hopCount,
    status,
    transport,
    relayPath,
    mediaType,
    mediaUrl,
    audioDurationSeconds,
    replyToMessageId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMessage &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.senderId == this.senderId &&
          other.recipientId == this.recipientId &&
          other.senderName == this.senderName &&
          other.content == this.content &&
          other.encryptedPayload == this.encryptedPayload &&
          other.nonce == this.nonce &&
          other.payloadHash == this.payloadHash &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt &&
          other.ttl == this.ttl &&
          other.hopCount == this.hopCount &&
          other.status == this.status &&
          other.transport == this.transport &&
          other.relayPath == this.relayPath &&
          other.mediaType == this.mediaType &&
          other.mediaUrl == this.mediaUrl &&
          other.audioDurationSeconds == this.audioDurationSeconds &&
          other.replyToMessageId == this.replyToMessageId);
}

class AppMessagesCompanion extends UpdateCompanion<AppMessage> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> senderId;
  final Value<String> recipientId;
  final Value<String> senderName;
  final Value<String> content;
  final Value<String?> encryptedPayload;
  final Value<String?> nonce;
  final Value<String?> payloadHash;
  final Value<DateTime> createdAt;
  final Value<DateTime> expiresAt;
  final Value<int> ttl;
  final Value<int> hopCount;
  final Value<String> status;
  final Value<String> transport;
  final Value<List<String>> relayPath;
  final Value<String> mediaType;
  final Value<String?> mediaUrl;
  final Value<int?> audioDurationSeconds;
  final Value<String?> replyToMessageId;
  final Value<int> rowid;
  const AppMessagesCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.recipientId = const Value.absent(),
    this.senderName = const Value.absent(),
    this.content = const Value.absent(),
    this.encryptedPayload = const Value.absent(),
    this.nonce = const Value.absent(),
    this.payloadHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.ttl = const Value.absent(),
    this.hopCount = const Value.absent(),
    this.status = const Value.absent(),
    this.transport = const Value.absent(),
    this.relayPath = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.audioDurationSeconds = const Value.absent(),
    this.replyToMessageId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMessagesCompanion.insert({
    required String id,
    required String conversationId,
    required String senderId,
    required String recipientId,
    required String senderName,
    required String content,
    this.encryptedPayload = const Value.absent(),
    this.nonce = const Value.absent(),
    this.payloadHash = const Value.absent(),
    required DateTime createdAt,
    required DateTime expiresAt,
    this.ttl = const Value.absent(),
    this.hopCount = const Value.absent(),
    required String status,
    required String transport,
    this.relayPath = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.audioDurationSeconds = const Value.absent(),
    this.replyToMessageId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       senderId = Value(senderId),
       recipientId = Value(recipientId),
       senderName = Value(senderName),
       content = Value(content),
       createdAt = Value(createdAt),
       expiresAt = Value(expiresAt),
       status = Value(status),
       transport = Value(transport);
  static Insertable<AppMessage> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? senderId,
    Expression<String>? recipientId,
    Expression<String>? senderName,
    Expression<String>? content,
    Expression<String>? encryptedPayload,
    Expression<String>? nonce,
    Expression<String>? payloadHash,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? ttl,
    Expression<int>? hopCount,
    Expression<String>? status,
    Expression<String>? transport,
    Expression<String>? relayPath,
    Expression<String>? mediaType,
    Expression<String>? mediaUrl,
    Expression<int>? audioDurationSeconds,
    Expression<String>? replyToMessageId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (senderId != null) 'sender_id': senderId,
      if (recipientId != null) 'recipient_id': recipientId,
      if (senderName != null) 'sender_name': senderName,
      if (content != null) 'content': content,
      if (encryptedPayload != null) 'encrypted_payload': encryptedPayload,
      if (nonce != null) 'nonce': nonce,
      if (payloadHash != null) 'payload_hash': payloadHash,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (ttl != null) 'ttl': ttl,
      if (hopCount != null) 'hop_count': hopCount,
      if (status != null) 'status': status,
      if (transport != null) 'transport': transport,
      if (relayPath != null) 'relay_path': relayPath,
      if (mediaType != null) 'media_type': mediaType,
      if (mediaUrl != null) 'media_url': mediaUrl,
      if (audioDurationSeconds != null)
        'audio_duration_seconds': audioDurationSeconds,
      if (replyToMessageId != null) 'reply_to_message_id': replyToMessageId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<String>? senderId,
    Value<String>? recipientId,
    Value<String>? senderName,
    Value<String>? content,
    Value<String?>? encryptedPayload,
    Value<String?>? nonce,
    Value<String?>? payloadHash,
    Value<DateTime>? createdAt,
    Value<DateTime>? expiresAt,
    Value<int>? ttl,
    Value<int>? hopCount,
    Value<String>? status,
    Value<String>? transport,
    Value<List<String>>? relayPath,
    Value<String>? mediaType,
    Value<String?>? mediaUrl,
    Value<int?>? audioDurationSeconds,
    Value<String?>? replyToMessageId,
    Value<int>? rowid,
  }) {
    return AppMessagesCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (recipientId.present) {
      map['recipient_id'] = Variable<String>(recipientId.value);
    }
    if (senderName.present) {
      map['sender_name'] = Variable<String>(senderName.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (encryptedPayload.present) {
      map['encrypted_payload'] = Variable<String>(encryptedPayload.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<String>(nonce.value);
    }
    if (payloadHash.present) {
      map['payload_hash'] = Variable<String>(payloadHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (ttl.present) {
      map['ttl'] = Variable<int>(ttl.value);
    }
    if (hopCount.present) {
      map['hop_count'] = Variable<int>(hopCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (transport.present) {
      map['transport'] = Variable<String>(transport.value);
    }
    if (relayPath.present) {
      map['relay_path'] = Variable<String>(
        $AppMessagesTable.$converterrelayPath.toSql(relayPath.value),
      );
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (mediaUrl.present) {
      map['media_url'] = Variable<String>(mediaUrl.value);
    }
    if (audioDurationSeconds.present) {
      map['audio_duration_seconds'] = Variable<int>(audioDurationSeconds.value);
    }
    if (replyToMessageId.present) {
      map['reply_to_message_id'] = Variable<String>(replyToMessageId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMessagesCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderId: $senderId, ')
          ..write('recipientId: $recipientId, ')
          ..write('senderName: $senderName, ')
          ..write('content: $content, ')
          ..write('encryptedPayload: $encryptedPayload, ')
          ..write('nonce: $nonce, ')
          ..write('payloadHash: $payloadHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('ttl: $ttl, ')
          ..write('hopCount: $hopCount, ')
          ..write('status: $status, ')
          ..write('transport: $transport, ')
          ..write('relayPath: $relayPath, ')
          ..write('mediaType: $mediaType, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('audioDurationSeconds: $audioDurationSeconds, ')
          ..write('replyToMessageId: $replyToMessageId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppConversationsTable extends AppConversations
    with TableInfo<$AppConversationsTable, AppConversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _peerIdMeta = const VerificationMeta('peerId');
  @override
  late final GeneratedColumn<String> peerId = GeneratedColumn<String>(
    'peer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _peerPublicKeyMeta = const VerificationMeta(
    'peerPublicKey',
  );
  @override
  late final GeneratedColumn<String> peerPublicKey = GeneratedColumn<String>(
    'peer_public_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _peerFingerprintMeta = const VerificationMeta(
    'peerFingerprint',
  );
  @override
  late final GeneratedColumn<String> peerFingerprint = GeneratedColumn<String>(
    'peer_fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastMessageIdMeta = const VerificationMeta(
    'lastMessageId',
  );
  @override
  late final GeneratedColumn<String> lastMessageId = GeneratedColumn<String>(
    'last_message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unreadCountMeta = const VerificationMeta(
    'unreadCount',
  );
  @override
  late final GeneratedColumn<int> unreadCount = GeneratedColumn<int>(
    'unread_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isGroupMeta = const VerificationMeta(
    'isGroup',
  );
  @override
  late final GeneratedColumn<bool> isGroup = GeneratedColumn<bool>(
    'is_group',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_group" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isNearbyMeta = const VerificationMeta(
    'isNearby',
  );
  @override
  late final GeneratedColumn<bool> isNearby = GeneratedColumn<bool>(
    'is_nearby',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_nearby" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _approximateDistanceMeta =
      const VerificationMeta('approximateDistance');
  @override
  late final GeneratedColumn<String> approximateDistance =
      GeneratedColumn<String>(
        'approximate_distance',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _activeTransportMeta = const VerificationMeta(
    'activeTransport',
  );
  @override
  late final GeneratedColumn<String> activeTransport = GeneratedColumn<String>(
    'active_transport',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('internet'),
  );
  static const VerificationMeta _avatarInitialsMeta = const VerificationMeta(
    'avatarInitials',
  );
  @override
  late final GeneratedColumn<String> avatarInitials = GeneratedColumn<String>(
    'avatar_initials',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    peerId,
    peerPublicKey,
    peerFingerprint,
    lastMessageId,
    unreadCount,
    isGroup,
    isNearby,
    approximateDistance,
    activeTransport,
    avatarInitials,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppConversation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('peer_id')) {
      context.handle(
        _peerIdMeta,
        peerId.isAcceptableOrUnknown(data['peer_id']!, _peerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_peerIdMeta);
    }
    if (data.containsKey('peer_public_key')) {
      context.handle(
        _peerPublicKeyMeta,
        peerPublicKey.isAcceptableOrUnknown(
          data['peer_public_key']!,
          _peerPublicKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_peerPublicKeyMeta);
    }
    if (data.containsKey('peer_fingerprint')) {
      context.handle(
        _peerFingerprintMeta,
        peerFingerprint.isAcceptableOrUnknown(
          data['peer_fingerprint']!,
          _peerFingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_peerFingerprintMeta);
    }
    if (data.containsKey('last_message_id')) {
      context.handle(
        _lastMessageIdMeta,
        lastMessageId.isAcceptableOrUnknown(
          data['last_message_id']!,
          _lastMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('unread_count')) {
      context.handle(
        _unreadCountMeta,
        unreadCount.isAcceptableOrUnknown(
          data['unread_count']!,
          _unreadCountMeta,
        ),
      );
    }
    if (data.containsKey('is_group')) {
      context.handle(
        _isGroupMeta,
        isGroup.isAcceptableOrUnknown(data['is_group']!, _isGroupMeta),
      );
    }
    if (data.containsKey('is_nearby')) {
      context.handle(
        _isNearbyMeta,
        isNearby.isAcceptableOrUnknown(data['is_nearby']!, _isNearbyMeta),
      );
    }
    if (data.containsKey('approximate_distance')) {
      context.handle(
        _approximateDistanceMeta,
        approximateDistance.isAcceptableOrUnknown(
          data['approximate_distance']!,
          _approximateDistanceMeta,
        ),
      );
    }
    if (data.containsKey('active_transport')) {
      context.handle(
        _activeTransportMeta,
        activeTransport.isAcceptableOrUnknown(
          data['active_transport']!,
          _activeTransportMeta,
        ),
      );
    }
    if (data.containsKey('avatar_initials')) {
      context.handle(
        _avatarInitialsMeta,
        avatarInitials.isAcceptableOrUnknown(
          data['avatar_initials']!,
          _avatarInitialsMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppConversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppConversation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      peerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}peer_id'],
      )!,
      peerPublicKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}peer_public_key'],
      )!,
      peerFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}peer_fingerprint'],
      )!,
      lastMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_message_id'],
      ),
      unreadCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unread_count'],
      )!,
      isGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_group'],
      )!,
      isNearby: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_nearby'],
      )!,
      approximateDistance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approximate_distance'],
      ),
      activeTransport: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_transport'],
      )!,
      avatarInitials: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_initials'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppConversationsTable createAlias(String alias) {
    return $AppConversationsTable(attachedDatabase, alias);
  }
}

class AppConversation extends DataClass implements Insertable<AppConversation> {
  final String id;
  final String title;
  final String peerId;
  final String peerPublicKey;
  final String peerFingerprint;
  final String? lastMessageId;
  final int unreadCount;
  final bool isGroup;
  final bool isNearby;
  final String? approximateDistance;
  final String activeTransport;
  final String? avatarInitials;
  final DateTime updatedAt;
  const AppConversation({
    required this.id,
    required this.title,
    required this.peerId,
    required this.peerPublicKey,
    required this.peerFingerprint,
    this.lastMessageId,
    required this.unreadCount,
    required this.isGroup,
    required this.isNearby,
    this.approximateDistance,
    required this.activeTransport,
    this.avatarInitials,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['peer_id'] = Variable<String>(peerId);
    map['peer_public_key'] = Variable<String>(peerPublicKey);
    map['peer_fingerprint'] = Variable<String>(peerFingerprint);
    if (!nullToAbsent || lastMessageId != null) {
      map['last_message_id'] = Variable<String>(lastMessageId);
    }
    map['unread_count'] = Variable<int>(unreadCount);
    map['is_group'] = Variable<bool>(isGroup);
    map['is_nearby'] = Variable<bool>(isNearby);
    if (!nullToAbsent || approximateDistance != null) {
      map['approximate_distance'] = Variable<String>(approximateDistance);
    }
    map['active_transport'] = Variable<String>(activeTransport);
    if (!nullToAbsent || avatarInitials != null) {
      map['avatar_initials'] = Variable<String>(avatarInitials);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppConversationsCompanion toCompanion(bool nullToAbsent) {
    return AppConversationsCompanion(
      id: Value(id),
      title: Value(title),
      peerId: Value(peerId),
      peerPublicKey: Value(peerPublicKey),
      peerFingerprint: Value(peerFingerprint),
      lastMessageId: lastMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageId),
      unreadCount: Value(unreadCount),
      isGroup: Value(isGroup),
      isNearby: Value(isNearby),
      approximateDistance: approximateDistance == null && nullToAbsent
          ? const Value.absent()
          : Value(approximateDistance),
      activeTransport: Value(activeTransport),
      avatarInitials: avatarInitials == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarInitials),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppConversation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppConversation(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      peerId: serializer.fromJson<String>(json['peerId']),
      peerPublicKey: serializer.fromJson<String>(json['peerPublicKey']),
      peerFingerprint: serializer.fromJson<String>(json['peerFingerprint']),
      lastMessageId: serializer.fromJson<String?>(json['lastMessageId']),
      unreadCount: serializer.fromJson<int>(json['unreadCount']),
      isGroup: serializer.fromJson<bool>(json['isGroup']),
      isNearby: serializer.fromJson<bool>(json['isNearby']),
      approximateDistance: serializer.fromJson<String?>(
        json['approximateDistance'],
      ),
      activeTransport: serializer.fromJson<String>(json['activeTransport']),
      avatarInitials: serializer.fromJson<String?>(json['avatarInitials']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'peerId': serializer.toJson<String>(peerId),
      'peerPublicKey': serializer.toJson<String>(peerPublicKey),
      'peerFingerprint': serializer.toJson<String>(peerFingerprint),
      'lastMessageId': serializer.toJson<String?>(lastMessageId),
      'unreadCount': serializer.toJson<int>(unreadCount),
      'isGroup': serializer.toJson<bool>(isGroup),
      'isNearby': serializer.toJson<bool>(isNearby),
      'approximateDistance': serializer.toJson<String?>(approximateDistance),
      'activeTransport': serializer.toJson<String>(activeTransport),
      'avatarInitials': serializer.toJson<String?>(avatarInitials),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppConversation copyWith({
    String? id,
    String? title,
    String? peerId,
    String? peerPublicKey,
    String? peerFingerprint,
    Value<String?> lastMessageId = const Value.absent(),
    int? unreadCount,
    bool? isGroup,
    bool? isNearby,
    Value<String?> approximateDistance = const Value.absent(),
    String? activeTransport,
    Value<String?> avatarInitials = const Value.absent(),
    DateTime? updatedAt,
  }) => AppConversation(
    id: id ?? this.id,
    title: title ?? this.title,
    peerId: peerId ?? this.peerId,
    peerPublicKey: peerPublicKey ?? this.peerPublicKey,
    peerFingerprint: peerFingerprint ?? this.peerFingerprint,
    lastMessageId: lastMessageId.present
        ? lastMessageId.value
        : this.lastMessageId,
    unreadCount: unreadCount ?? this.unreadCount,
    isGroup: isGroup ?? this.isGroup,
    isNearby: isNearby ?? this.isNearby,
    approximateDistance: approximateDistance.present
        ? approximateDistance.value
        : this.approximateDistance,
    activeTransport: activeTransport ?? this.activeTransport,
    avatarInitials: avatarInitials.present
        ? avatarInitials.value
        : this.avatarInitials,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppConversation copyWithCompanion(AppConversationsCompanion data) {
    return AppConversation(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      peerId: data.peerId.present ? data.peerId.value : this.peerId,
      peerPublicKey: data.peerPublicKey.present
          ? data.peerPublicKey.value
          : this.peerPublicKey,
      peerFingerprint: data.peerFingerprint.present
          ? data.peerFingerprint.value
          : this.peerFingerprint,
      lastMessageId: data.lastMessageId.present
          ? data.lastMessageId.value
          : this.lastMessageId,
      unreadCount: data.unreadCount.present
          ? data.unreadCount.value
          : this.unreadCount,
      isGroup: data.isGroup.present ? data.isGroup.value : this.isGroup,
      isNearby: data.isNearby.present ? data.isNearby.value : this.isNearby,
      approximateDistance: data.approximateDistance.present
          ? data.approximateDistance.value
          : this.approximateDistance,
      activeTransport: data.activeTransport.present
          ? data.activeTransport.value
          : this.activeTransport,
      avatarInitials: data.avatarInitials.present
          ? data.avatarInitials.value
          : this.avatarInitials,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppConversation(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('peerId: $peerId, ')
          ..write('peerPublicKey: $peerPublicKey, ')
          ..write('peerFingerprint: $peerFingerprint, ')
          ..write('lastMessageId: $lastMessageId, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('isGroup: $isGroup, ')
          ..write('isNearby: $isNearby, ')
          ..write('approximateDistance: $approximateDistance, ')
          ..write('activeTransport: $activeTransport, ')
          ..write('avatarInitials: $avatarInitials, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    peerId,
    peerPublicKey,
    peerFingerprint,
    lastMessageId,
    unreadCount,
    isGroup,
    isNearby,
    approximateDistance,
    activeTransport,
    avatarInitials,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppConversation &&
          other.id == this.id &&
          other.title == this.title &&
          other.peerId == this.peerId &&
          other.peerPublicKey == this.peerPublicKey &&
          other.peerFingerprint == this.peerFingerprint &&
          other.lastMessageId == this.lastMessageId &&
          other.unreadCount == this.unreadCount &&
          other.isGroup == this.isGroup &&
          other.isNearby == this.isNearby &&
          other.approximateDistance == this.approximateDistance &&
          other.activeTransport == this.activeTransport &&
          other.avatarInitials == this.avatarInitials &&
          other.updatedAt == this.updatedAt);
}

class AppConversationsCompanion extends UpdateCompanion<AppConversation> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> peerId;
  final Value<String> peerPublicKey;
  final Value<String> peerFingerprint;
  final Value<String?> lastMessageId;
  final Value<int> unreadCount;
  final Value<bool> isGroup;
  final Value<bool> isNearby;
  final Value<String?> approximateDistance;
  final Value<String> activeTransport;
  final Value<String?> avatarInitials;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppConversationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.peerId = const Value.absent(),
    this.peerPublicKey = const Value.absent(),
    this.peerFingerprint = const Value.absent(),
    this.lastMessageId = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.isGroup = const Value.absent(),
    this.isNearby = const Value.absent(),
    this.approximateDistance = const Value.absent(),
    this.activeTransport = const Value.absent(),
    this.avatarInitials = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppConversationsCompanion.insert({
    required String id,
    required String title,
    required String peerId,
    required String peerPublicKey,
    required String peerFingerprint,
    this.lastMessageId = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.isGroup = const Value.absent(),
    this.isNearby = const Value.absent(),
    this.approximateDistance = const Value.absent(),
    this.activeTransport = const Value.absent(),
    this.avatarInitials = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       peerId = Value(peerId),
       peerPublicKey = Value(peerPublicKey),
       peerFingerprint = Value(peerFingerprint),
       updatedAt = Value(updatedAt);
  static Insertable<AppConversation> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? peerId,
    Expression<String>? peerPublicKey,
    Expression<String>? peerFingerprint,
    Expression<String>? lastMessageId,
    Expression<int>? unreadCount,
    Expression<bool>? isGroup,
    Expression<bool>? isNearby,
    Expression<String>? approximateDistance,
    Expression<String>? activeTransport,
    Expression<String>? avatarInitials,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (peerId != null) 'peer_id': peerId,
      if (peerPublicKey != null) 'peer_public_key': peerPublicKey,
      if (peerFingerprint != null) 'peer_fingerprint': peerFingerprint,
      if (lastMessageId != null) 'last_message_id': lastMessageId,
      if (unreadCount != null) 'unread_count': unreadCount,
      if (isGroup != null) 'is_group': isGroup,
      if (isNearby != null) 'is_nearby': isNearby,
      if (approximateDistance != null)
        'approximate_distance': approximateDistance,
      if (activeTransport != null) 'active_transport': activeTransport,
      if (avatarInitials != null) 'avatar_initials': avatarInitials,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppConversationsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? peerId,
    Value<String>? peerPublicKey,
    Value<String>? peerFingerprint,
    Value<String?>? lastMessageId,
    Value<int>? unreadCount,
    Value<bool>? isGroup,
    Value<bool>? isNearby,
    Value<String?>? approximateDistance,
    Value<String>? activeTransport,
    Value<String?>? avatarInitials,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppConversationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      peerId: peerId ?? this.peerId,
      peerPublicKey: peerPublicKey ?? this.peerPublicKey,
      peerFingerprint: peerFingerprint ?? this.peerFingerprint,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      unreadCount: unreadCount ?? this.unreadCount,
      isGroup: isGroup ?? this.isGroup,
      isNearby: isNearby ?? this.isNearby,
      approximateDistance: approximateDistance ?? this.approximateDistance,
      activeTransport: activeTransport ?? this.activeTransport,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (peerId.present) {
      map['peer_id'] = Variable<String>(peerId.value);
    }
    if (peerPublicKey.present) {
      map['peer_public_key'] = Variable<String>(peerPublicKey.value);
    }
    if (peerFingerprint.present) {
      map['peer_fingerprint'] = Variable<String>(peerFingerprint.value);
    }
    if (lastMessageId.present) {
      map['last_message_id'] = Variable<String>(lastMessageId.value);
    }
    if (unreadCount.present) {
      map['unread_count'] = Variable<int>(unreadCount.value);
    }
    if (isGroup.present) {
      map['is_group'] = Variable<bool>(isGroup.value);
    }
    if (isNearby.present) {
      map['is_nearby'] = Variable<bool>(isNearby.value);
    }
    if (approximateDistance.present) {
      map['approximate_distance'] = Variable<String>(approximateDistance.value);
    }
    if (activeTransport.present) {
      map['active_transport'] = Variable<String>(activeTransport.value);
    }
    if (avatarInitials.present) {
      map['avatar_initials'] = Variable<String>(avatarInitials.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppConversationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('peerId: $peerId, ')
          ..write('peerPublicKey: $peerPublicKey, ')
          ..write('peerFingerprint: $peerFingerprint, ')
          ..write('lastMessageId: $lastMessageId, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('isGroup: $isGroup, ')
          ..write('isNearby: $isNearby, ')
          ..write('approximateDistance: $approximateDistance, ')
          ..write('activeTransport: $activeTransport, ')
          ..write('avatarInitials: $avatarInitials, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppContactsTable extends AppContacts
    with TableInfo<$AppContactsTable, AppContact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publicKeyMeta = const VerificationMeta(
    'publicKey',
  );
  @override
  late final GeneratedColumn<String> publicKey = GeneratedColumn<String>(
    'public_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isNearbyMeta = const VerificationMeta(
    'isNearby',
  );
  @override
  late final GeneratedColumn<bool> isNearby = GeneratedColumn<bool>(
    'is_nearby',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_nearby" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isOnlineMeta = const VerificationMeta(
    'isOnline',
  );
  @override
  late final GeneratedColumn<bool> isOnline = GeneratedColumn<bool>(
    'is_online',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_online" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _approximateDistanceMeta =
      const VerificationMeta('approximateDistance');
  @override
  late final GeneratedColumn<String> approximateDistance =
      GeneratedColumn<String>(
        'approximate_distance',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    publicKey,
    fingerprint,
    isNearby,
    isOnline,
    approximateDistance,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppContact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('public_key')) {
      context.handle(
        _publicKeyMeta,
        publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_publicKeyMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('is_nearby')) {
      context.handle(
        _isNearbyMeta,
        isNearby.isAcceptableOrUnknown(data['is_nearby']!, _isNearbyMeta),
      );
    }
    if (data.containsKey('is_online')) {
      context.handle(
        _isOnlineMeta,
        isOnline.isAcceptableOrUnknown(data['is_online']!, _isOnlineMeta),
      );
    }
    if (data.containsKey('approximate_distance')) {
      context.handle(
        _approximateDistanceMeta,
        approximateDistance.isAcceptableOrUnknown(
          data['approximate_distance']!,
          _approximateDistanceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppContact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppContact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      publicKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}public_key'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      isNearby: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_nearby'],
      )!,
      isOnline: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_online'],
      )!,
      approximateDistance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approximate_distance'],
      ),
    );
  }

  @override
  $AppContactsTable createAlias(String alias) {
    return $AppContactsTable(attachedDatabase, alias);
  }
}

class AppContact extends DataClass implements Insertable<AppContact> {
  final String id;
  final String name;
  final String? phone;
  final String publicKey;
  final String fingerprint;
  final bool isNearby;
  final bool isOnline;
  final String? approximateDistance;
  const AppContact({
    required this.id,
    required this.name,
    this.phone,
    required this.publicKey,
    required this.fingerprint,
    required this.isNearby,
    required this.isOnline,
    this.approximateDistance,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['public_key'] = Variable<String>(publicKey);
    map['fingerprint'] = Variable<String>(fingerprint);
    map['is_nearby'] = Variable<bool>(isNearby);
    map['is_online'] = Variable<bool>(isOnline);
    if (!nullToAbsent || approximateDistance != null) {
      map['approximate_distance'] = Variable<String>(approximateDistance);
    }
    return map;
  }

  AppContactsCompanion toCompanion(bool nullToAbsent) {
    return AppContactsCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      publicKey: Value(publicKey),
      fingerprint: Value(fingerprint),
      isNearby: Value(isNearby),
      isOnline: Value(isOnline),
      approximateDistance: approximateDistance == null && nullToAbsent
          ? const Value.absent()
          : Value(approximateDistance),
    );
  }

  factory AppContact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppContact(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      publicKey: serializer.fromJson<String>(json['publicKey']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      isNearby: serializer.fromJson<bool>(json['isNearby']),
      isOnline: serializer.fromJson<bool>(json['isOnline']),
      approximateDistance: serializer.fromJson<String?>(
        json['approximateDistance'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'publicKey': serializer.toJson<String>(publicKey),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'isNearby': serializer.toJson<bool>(isNearby),
      'isOnline': serializer.toJson<bool>(isOnline),
      'approximateDistance': serializer.toJson<String?>(approximateDistance),
    };
  }

  AppContact copyWith({
    String? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    String? publicKey,
    String? fingerprint,
    bool? isNearby,
    bool? isOnline,
    Value<String?> approximateDistance = const Value.absent(),
  }) => AppContact(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    publicKey: publicKey ?? this.publicKey,
    fingerprint: fingerprint ?? this.fingerprint,
    isNearby: isNearby ?? this.isNearby,
    isOnline: isOnline ?? this.isOnline,
    approximateDistance: approximateDistance.present
        ? approximateDistance.value
        : this.approximateDistance,
  );
  AppContact copyWithCompanion(AppContactsCompanion data) {
    return AppContact(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      publicKey: data.publicKey.present ? data.publicKey.value : this.publicKey,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      isNearby: data.isNearby.present ? data.isNearby.value : this.isNearby,
      isOnline: data.isOnline.present ? data.isOnline.value : this.isOnline,
      approximateDistance: data.approximateDistance.present
          ? data.approximateDistance.value
          : this.approximateDistance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppContact(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('publicKey: $publicKey, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('isNearby: $isNearby, ')
          ..write('isOnline: $isOnline, ')
          ..write('approximateDistance: $approximateDistance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    publicKey,
    fingerprint,
    isNearby,
    isOnline,
    approximateDistance,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppContact &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.publicKey == this.publicKey &&
          other.fingerprint == this.fingerprint &&
          other.isNearby == this.isNearby &&
          other.isOnline == this.isOnline &&
          other.approximateDistance == this.approximateDistance);
}

class AppContactsCompanion extends UpdateCompanion<AppContact> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String> publicKey;
  final Value<String> fingerprint;
  final Value<bool> isNearby;
  final Value<bool> isOnline;
  final Value<String?> approximateDistance;
  final Value<int> rowid;
  const AppContactsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.isNearby = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.approximateDistance = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppContactsCompanion.insert({
    required String id,
    required String name,
    this.phone = const Value.absent(),
    required String publicKey,
    required String fingerprint,
    this.isNearby = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.approximateDistance = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       publicKey = Value(publicKey),
       fingerprint = Value(fingerprint);
  static Insertable<AppContact> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? publicKey,
    Expression<String>? fingerprint,
    Expression<bool>? isNearby,
    Expression<bool>? isOnline,
    Expression<String>? approximateDistance,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (publicKey != null) 'public_key': publicKey,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (isNearby != null) 'is_nearby': isNearby,
      if (isOnline != null) 'is_online': isOnline,
      if (approximateDistance != null)
        'approximate_distance': approximateDistance,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppContactsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String>? publicKey,
    Value<String>? fingerprint,
    Value<bool>? isNearby,
    Value<bool>? isOnline,
    Value<String?>? approximateDistance,
    Value<int>? rowid,
  }) {
    return AppContactsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      publicKey: publicKey ?? this.publicKey,
      fingerprint: fingerprint ?? this.fingerprint,
      isNearby: isNearby ?? this.isNearby,
      isOnline: isOnline ?? this.isOnline,
      approximateDistance: approximateDistance ?? this.approximateDistance,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<String>(publicKey.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (isNearby.present) {
      map['is_nearby'] = Variable<bool>(isNearby.value);
    }
    if (isOnline.present) {
      map['is_online'] = Variable<bool>(isOnline.value);
    }
    if (approximateDistance.present) {
      map['approximate_distance'] = Variable<String>(approximateDistance.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppContactsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('publicKey: $publicKey, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('isNearby: $isNearby, ')
          ..write('isOnline: $isOnline, ')
          ..write('approximateDistance: $approximateDistance, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppMessagesTable appMessages = $AppMessagesTable(this);
  late final $AppConversationsTable appConversations = $AppConversationsTable(
    this,
  );
  late final $AppContactsTable appContacts = $AppContactsTable(this);
  late final AppDao appDao = AppDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appMessages,
    appConversations,
    appContacts,
  ];
}

typedef $$AppMessagesTableCreateCompanionBuilder =
    AppMessagesCompanion Function({
      required String id,
      required String conversationId,
      required String senderId,
      required String recipientId,
      required String senderName,
      required String content,
      Value<String?> encryptedPayload,
      Value<String?> nonce,
      Value<String?> payloadHash,
      required DateTime createdAt,
      required DateTime expiresAt,
      Value<int> ttl,
      Value<int> hopCount,
      required String status,
      required String transport,
      Value<List<String>> relayPath,
      Value<String> mediaType,
      Value<String?> mediaUrl,
      Value<int?> audioDurationSeconds,
      Value<String?> replyToMessageId,
      Value<int> rowid,
    });
typedef $$AppMessagesTableUpdateCompanionBuilder =
    AppMessagesCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<String> senderId,
      Value<String> recipientId,
      Value<String> senderName,
      Value<String> content,
      Value<String?> encryptedPayload,
      Value<String?> nonce,
      Value<String?> payloadHash,
      Value<DateTime> createdAt,
      Value<DateTime> expiresAt,
      Value<int> ttl,
      Value<int> hopCount,
      Value<String> status,
      Value<String> transport,
      Value<List<String>> relayPath,
      Value<String> mediaType,
      Value<String?> mediaUrl,
      Value<int?> audioDurationSeconds,
      Value<String?> replyToMessageId,
      Value<int> rowid,
    });

class $$AppMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $AppMessagesTable> {
  $$AppMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipientId => $composableBuilder(
    column: $table.recipientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nonce => $composableBuilder(
    column: $table.nonce,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadHash => $composableBuilder(
    column: $table.payloadHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ttl => $composableBuilder(
    column: $table.ttl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hopCount => $composableBuilder(
    column: $table.hopCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transport => $composableBuilder(
    column: $table.transport,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get relayPath => $composableBuilder(
    column: $table.relayPath,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get audioDurationSeconds => $composableBuilder(
    column: $table.audioDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMessagesTable> {
  $$AppMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipientId => $composableBuilder(
    column: $table.recipientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nonce => $composableBuilder(
    column: $table.nonce,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadHash => $composableBuilder(
    column: $table.payloadHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ttl => $composableBuilder(
    column: $table.ttl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hopCount => $composableBuilder(
    column: $table.hopCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transport => $composableBuilder(
    column: $table.transport,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relayPath => $composableBuilder(
    column: $table.relayPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get audioDurationSeconds => $composableBuilder(
    column: $table.audioDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMessagesTable> {
  $$AppMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get recipientId => $composableBuilder(
    column: $table.recipientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nonce =>
      $composableBuilder(column: $table.nonce, builder: (column) => column);

  GeneratedColumn<String> get payloadHash => $composableBuilder(
    column: $table.payloadHash,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<int> get ttl =>
      $composableBuilder(column: $table.ttl, builder: (column) => column);

  GeneratedColumn<int> get hopCount =>
      $composableBuilder(column: $table.hopCount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get transport =>
      $composableBuilder(column: $table.transport, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get relayPath =>
      $composableBuilder(column: $table.relayPath, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get mediaUrl =>
      $composableBuilder(column: $table.mediaUrl, builder: (column) => column);

  GeneratedColumn<int> get audioDurationSeconds => $composableBuilder(
    column: $table.audioDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => column,
  );
}

class $$AppMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMessagesTable,
          AppMessage,
          $$AppMessagesTableFilterComposer,
          $$AppMessagesTableOrderingComposer,
          $$AppMessagesTableAnnotationComposer,
          $$AppMessagesTableCreateCompanionBuilder,
          $$AppMessagesTableUpdateCompanionBuilder,
          (
            AppMessage,
            BaseReferences<_$AppDatabase, $AppMessagesTable, AppMessage>,
          ),
          AppMessage,
          PrefetchHooks Function()
        > {
  $$AppMessagesTableTableManager(_$AppDatabase db, $AppMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> recipientId = const Value.absent(),
                Value<String> senderName = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> encryptedPayload = const Value.absent(),
                Value<String?> nonce = const Value.absent(),
                Value<String?> payloadHash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<int> ttl = const Value.absent(),
                Value<int> hopCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> transport = const Value.absent(),
                Value<List<String>> relayPath = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String?> mediaUrl = const Value.absent(),
                Value<int?> audioDurationSeconds = const Value.absent(),
                Value<String?> replyToMessageId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMessagesCompanion(
                id: id,
                conversationId: conversationId,
                senderId: senderId,
                recipientId: recipientId,
                senderName: senderName,
                content: content,
                encryptedPayload: encryptedPayload,
                nonce: nonce,
                payloadHash: payloadHash,
                createdAt: createdAt,
                expiresAt: expiresAt,
                ttl: ttl,
                hopCount: hopCount,
                status: status,
                transport: transport,
                relayPath: relayPath,
                mediaType: mediaType,
                mediaUrl: mediaUrl,
                audioDurationSeconds: audioDurationSeconds,
                replyToMessageId: replyToMessageId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required String senderId,
                required String recipientId,
                required String senderName,
                required String content,
                Value<String?> encryptedPayload = const Value.absent(),
                Value<String?> nonce = const Value.absent(),
                Value<String?> payloadHash = const Value.absent(),
                required DateTime createdAt,
                required DateTime expiresAt,
                Value<int> ttl = const Value.absent(),
                Value<int> hopCount = const Value.absent(),
                required String status,
                required String transport,
                Value<List<String>> relayPath = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String?> mediaUrl = const Value.absent(),
                Value<int?> audioDurationSeconds = const Value.absent(),
                Value<String?> replyToMessageId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMessagesCompanion.insert(
                id: id,
                conversationId: conversationId,
                senderId: senderId,
                recipientId: recipientId,
                senderName: senderName,
                content: content,
                encryptedPayload: encryptedPayload,
                nonce: nonce,
                payloadHash: payloadHash,
                createdAt: createdAt,
                expiresAt: expiresAt,
                ttl: ttl,
                hopCount: hopCount,
                status: status,
                transport: transport,
                relayPath: relayPath,
                mediaType: mediaType,
                mediaUrl: mediaUrl,
                audioDurationSeconds: audioDurationSeconds,
                replyToMessageId: replyToMessageId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMessagesTable,
      AppMessage,
      $$AppMessagesTableFilterComposer,
      $$AppMessagesTableOrderingComposer,
      $$AppMessagesTableAnnotationComposer,
      $$AppMessagesTableCreateCompanionBuilder,
      $$AppMessagesTableUpdateCompanionBuilder,
      (
        AppMessage,
        BaseReferences<_$AppDatabase, $AppMessagesTable, AppMessage>,
      ),
      AppMessage,
      PrefetchHooks Function()
    >;
typedef $$AppConversationsTableCreateCompanionBuilder =
    AppConversationsCompanion Function({
      required String id,
      required String title,
      required String peerId,
      required String peerPublicKey,
      required String peerFingerprint,
      Value<String?> lastMessageId,
      Value<int> unreadCount,
      Value<bool> isGroup,
      Value<bool> isNearby,
      Value<String?> approximateDistance,
      Value<String> activeTransport,
      Value<String?> avatarInitials,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppConversationsTableUpdateCompanionBuilder =
    AppConversationsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> peerId,
      Value<String> peerPublicKey,
      Value<String> peerFingerprint,
      Value<String?> lastMessageId,
      Value<int> unreadCount,
      Value<bool> isGroup,
      Value<bool> isNearby,
      Value<String?> approximateDistance,
      Value<String> activeTransport,
      Value<String?> avatarInitials,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $AppConversationsTable> {
  $$AppConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get peerId => $composableBuilder(
    column: $table.peerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get peerPublicKey => $composableBuilder(
    column: $table.peerPublicKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get peerFingerprint => $composableBuilder(
    column: $table.peerFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastMessageId => $composableBuilder(
    column: $table.lastMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGroup => $composableBuilder(
    column: $table.isGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNearby => $composableBuilder(
    column: $table.isNearby,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approximateDistance => $composableBuilder(
    column: $table.approximateDistance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeTransport => $composableBuilder(
    column: $table.activeTransport,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarInitials => $composableBuilder(
    column: $table.avatarInitials,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppConversationsTable> {
  $$AppConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get peerId => $composableBuilder(
    column: $table.peerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get peerPublicKey => $composableBuilder(
    column: $table.peerPublicKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get peerFingerprint => $composableBuilder(
    column: $table.peerFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastMessageId => $composableBuilder(
    column: $table.lastMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGroup => $composableBuilder(
    column: $table.isGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNearby => $composableBuilder(
    column: $table.isNearby,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approximateDistance => $composableBuilder(
    column: $table.approximateDistance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeTransport => $composableBuilder(
    column: $table.activeTransport,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarInitials => $composableBuilder(
    column: $table.avatarInitials,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppConversationsTable> {
  $$AppConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get peerId =>
      $composableBuilder(column: $table.peerId, builder: (column) => column);

  GeneratedColumn<String> get peerPublicKey => $composableBuilder(
    column: $table.peerPublicKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get peerFingerprint => $composableBuilder(
    column: $table.peerFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastMessageId => $composableBuilder(
    column: $table.lastMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isGroup =>
      $composableBuilder(column: $table.isGroup, builder: (column) => column);

  GeneratedColumn<bool> get isNearby =>
      $composableBuilder(column: $table.isNearby, builder: (column) => column);

  GeneratedColumn<String> get approximateDistance => $composableBuilder(
    column: $table.approximateDistance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeTransport => $composableBuilder(
    column: $table.activeTransport,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarInitials => $composableBuilder(
    column: $table.avatarInitials,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppConversationsTable,
          AppConversation,
          $$AppConversationsTableFilterComposer,
          $$AppConversationsTableOrderingComposer,
          $$AppConversationsTableAnnotationComposer,
          $$AppConversationsTableCreateCompanionBuilder,
          $$AppConversationsTableUpdateCompanionBuilder,
          (
            AppConversation,
            BaseReferences<
              _$AppDatabase,
              $AppConversationsTable,
              AppConversation
            >,
          ),
          AppConversation,
          PrefetchHooks Function()
        > {
  $$AppConversationsTableTableManager(
    _$AppDatabase db,
    $AppConversationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppConversationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> peerId = const Value.absent(),
                Value<String> peerPublicKey = const Value.absent(),
                Value<String> peerFingerprint = const Value.absent(),
                Value<String?> lastMessageId = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<bool> isGroup = const Value.absent(),
                Value<bool> isNearby = const Value.absent(),
                Value<String?> approximateDistance = const Value.absent(),
                Value<String> activeTransport = const Value.absent(),
                Value<String?> avatarInitials = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppConversationsCompanion(
                id: id,
                title: title,
                peerId: peerId,
                peerPublicKey: peerPublicKey,
                peerFingerprint: peerFingerprint,
                lastMessageId: lastMessageId,
                unreadCount: unreadCount,
                isGroup: isGroup,
                isNearby: isNearby,
                approximateDistance: approximateDistance,
                activeTransport: activeTransport,
                avatarInitials: avatarInitials,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String peerId,
                required String peerPublicKey,
                required String peerFingerprint,
                Value<String?> lastMessageId = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<bool> isGroup = const Value.absent(),
                Value<bool> isNearby = const Value.absent(),
                Value<String?> approximateDistance = const Value.absent(),
                Value<String> activeTransport = const Value.absent(),
                Value<String?> avatarInitials = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppConversationsCompanion.insert(
                id: id,
                title: title,
                peerId: peerId,
                peerPublicKey: peerPublicKey,
                peerFingerprint: peerFingerprint,
                lastMessageId: lastMessageId,
                unreadCount: unreadCount,
                isGroup: isGroup,
                isNearby: isNearby,
                approximateDistance: approximateDistance,
                activeTransport: activeTransport,
                avatarInitials: avatarInitials,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppConversationsTable,
      AppConversation,
      $$AppConversationsTableFilterComposer,
      $$AppConversationsTableOrderingComposer,
      $$AppConversationsTableAnnotationComposer,
      $$AppConversationsTableCreateCompanionBuilder,
      $$AppConversationsTableUpdateCompanionBuilder,
      (
        AppConversation,
        BaseReferences<_$AppDatabase, $AppConversationsTable, AppConversation>,
      ),
      AppConversation,
      PrefetchHooks Function()
    >;
typedef $$AppContactsTableCreateCompanionBuilder =
    AppContactsCompanion Function({
      required String id,
      required String name,
      Value<String?> phone,
      required String publicKey,
      required String fingerprint,
      Value<bool> isNearby,
      Value<bool> isOnline,
      Value<String?> approximateDistance,
      Value<int> rowid,
    });
typedef $$AppContactsTableUpdateCompanionBuilder =
    AppContactsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> phone,
      Value<String> publicKey,
      Value<String> fingerprint,
      Value<bool> isNearby,
      Value<bool> isOnline,
      Value<String?> approximateDistance,
      Value<int> rowid,
    });

class $$AppContactsTableFilterComposer
    extends Composer<_$AppDatabase, $AppContactsTable> {
  $$AppContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNearby => $composableBuilder(
    column: $table.isNearby,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approximateDistance => $composableBuilder(
    column: $table.approximateDistance,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppContactsTable> {
  $$AppContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNearby => $composableBuilder(
    column: $table.isNearby,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approximateDistance => $composableBuilder(
    column: $table.approximateDistance,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppContactsTable> {
  $$AppContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get publicKey =>
      $composableBuilder(column: $table.publicKey, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isNearby =>
      $composableBuilder(column: $table.isNearby, builder: (column) => column);

  GeneratedColumn<bool> get isOnline =>
      $composableBuilder(column: $table.isOnline, builder: (column) => column);

  GeneratedColumn<String> get approximateDistance => $composableBuilder(
    column: $table.approximateDistance,
    builder: (column) => column,
  );
}

class $$AppContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppContactsTable,
          AppContact,
          $$AppContactsTableFilterComposer,
          $$AppContactsTableOrderingComposer,
          $$AppContactsTableAnnotationComposer,
          $$AppContactsTableCreateCompanionBuilder,
          $$AppContactsTableUpdateCompanionBuilder,
          (
            AppContact,
            BaseReferences<_$AppDatabase, $AppContactsTable, AppContact>,
          ),
          AppContact,
          PrefetchHooks Function()
        > {
  $$AppContactsTableTableManager(_$AppDatabase db, $AppContactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String> publicKey = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<bool> isNearby = const Value.absent(),
                Value<bool> isOnline = const Value.absent(),
                Value<String?> approximateDistance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppContactsCompanion(
                id: id,
                name: name,
                phone: phone,
                publicKey: publicKey,
                fingerprint: fingerprint,
                isNearby: isNearby,
                isOnline: isOnline,
                approximateDistance: approximateDistance,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> phone = const Value.absent(),
                required String publicKey,
                required String fingerprint,
                Value<bool> isNearby = const Value.absent(),
                Value<bool> isOnline = const Value.absent(),
                Value<String?> approximateDistance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppContactsCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                publicKey: publicKey,
                fingerprint: fingerprint,
                isNearby: isNearby,
                isOnline: isOnline,
                approximateDistance: approximateDistance,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppContactsTable,
      AppContact,
      $$AppContactsTableFilterComposer,
      $$AppContactsTableOrderingComposer,
      $$AppContactsTableAnnotationComposer,
      $$AppContactsTableCreateCompanionBuilder,
      $$AppContactsTableUpdateCompanionBuilder,
      (
        AppContact,
        BaseReferences<_$AppDatabase, $AppContactsTable, AppContact>,
      ),
      AppContact,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppMessagesTableTableManager get appMessages =>
      $$AppMessagesTableTableManager(_db, _db.appMessages);
  $$AppConversationsTableTableManager get appConversations =>
      $$AppConversationsTableTableManager(_db, _db.appConversations);
  $$AppContactsTableTableManager get appContacts =>
      $$AppContactsTableTableManager(_db, _db.appContacts);
}
