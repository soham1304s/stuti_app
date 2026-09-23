import 'dart:convert';
import 'package:drift/drift.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();
  @override
  List<String> fromSql(String fromDb) => List<String>.from(jsonDecode(fromDb));
  @override
  String toSql(List<String> value) => jsonEncode(value);
}

class AppMessages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text()();
  TextColumn get senderId => text()();
  TextColumn get recipientId => text()();
  TextColumn get senderName => text()();
  TextColumn get content => text()();
  TextColumn get encryptedPayload => text().nullable()();
  TextColumn get nonce => text().nullable()();
  TextColumn get payloadHash => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();
  IntColumn get ttl => integer().withDefault(const Constant(8))();
  IntColumn get hopCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text()();
  TextColumn get transport => text()();
  TextColumn get relayPath => text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get mediaType => text().withDefault(const Constant('text'))();
  TextColumn get mediaUrl => text().nullable()();
  IntColumn get audioDurationSeconds => integer().nullable()();
  TextColumn get replyToMessageId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class AppConversations extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get peerId => text()();
  TextColumn get peerPublicKey => text()();
  TextColumn get peerFingerprint => text()();
  TextColumn get lastMessageId => text().nullable()();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  BoolColumn get isGroup => boolean().withDefault(const Constant(false))();
  BoolColumn get isNearby => boolean().withDefault(const Constant(false))();
  TextColumn get approximateDistance => text().nullable()();
  TextColumn get activeTransport => text().withDefault(const Constant('internet'))();
  TextColumn get avatarInitials => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AppContacts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get publicKey => text()();
  TextColumn get fingerprint => text()();
  BoolColumn get isNearby => boolean().withDefault(const Constant(false))();
  BoolColumn get isOnline => boolean().withDefault(const Constant(false))();
  TextColumn get approximateDistance => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
