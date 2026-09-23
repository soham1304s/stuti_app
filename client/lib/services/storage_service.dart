import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/core/crypto/crypto_helper.dart';
import 'package:meshtalk_client/features/auth/domain/models/user_identity.dart';
import 'package:meshtalk_client/features/chat/domain/models/conversation.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';
import 'package:meshtalk_client/features/contacts/domain/models/contact.dart';
import 'package:meshtalk_client/app/data/local/drift/database.dart';
import 'package:meshtalk_client/app/data/local/drift/daos.dart';

class StorageService extends ChangeNotifier {
  final AppDatabase db;
  late final AppDao dao;
  SharedPreferences? _prefs;
  
  UserIdentity? _currentUser;
  final List<Conversation> _conversations = [];
  final Map<String, List<Message>> _messagesByConversation = {};
  final List<Contact> _contacts = [];
  final Set<String> _seenMessageIds = {};
  bool _isDarkMode = true;

  StorageService({required this.db}) {
    dao = db.appDao;
  }

  UserIdentity? get currentUser => _currentUser;
  List<Conversation> get conversations => List.unmodifiable(_conversations);
  List<Contact> get contacts => List.unmodifiable(_contacts);
  Set<String> get seenMessageIds => Set.unmodifiable(_seenMessageIds);
  bool get isDarkMode => _isDarkMode;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs?.getBool('isDarkMode') ?? true;
    await _loadUserIdentity();
    
    // We will sync with Drift. For now, we seed if empty.
    _listenToDrift();
    
    await _seedIfNeeded();
  }

  void _listenToDrift() {
    dao.watchAllConversations().listen((dbConvs) {
      _conversations.clear();
      _conversations.addAll(dbConvs.map((c) => Conversation(
        id: c.id,
        title: c.title,
        peerId: c.peerId,
        peerPublicKey: c.peerPublicKey,
        peerFingerprint: c.peerFingerprint,
        lastMessage: null, // We'd need to join this, simplify for now
        isNearby: c.isNearby,
        approximateDistance: c.approximateDistance,
        activeTransport: _parseTransport(c.activeTransport),
        avatarInitials: c.avatarInitials,
        updatedAt: c.updatedAt,
      )));
      notifyListeners();
    });
    
    dao.watchAllContacts().listen((dbContacts) {
      _contacts.clear();
      _contacts.addAll(dbContacts.map((c) => Contact(
        id: c.id,
        name: c.name,
        phone: c.phone ?? '',
        publicKey: c.publicKey,
        fingerprint: c.fingerprint,
        isNearby: c.isNearby,
        isOnline: c.isOnline,
        approximateDistance: c.approximateDistance,
      )));
      notifyListeners();
    });
  }
  
  MessageTransport _parseTransport(String val) {
    switch(val) {
      case 'bluetooth': return MessageTransport.bluetooth;
      
      case 'meshRelay': return MessageTransport.meshRelay;
      case 'internet': default: return MessageTransport.internet;
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs?.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> _loadUserIdentity() async {
    final userJson = _prefs?.getString(AppConstants.keyUserIdentity);
    if (userJson != null) {
      _currentUser = UserIdentity.fromJson(jsonDecode(userJson));
    } else {
      final idPair = CryptoHelper.generateIdentity();
      _currentUser = UserIdentity(
        id: idPair.deviceId,
        displayName: 'Soham Mondal',
        phone: '+91 98765 43210',
        publicKey: idPair.publicKey,
        privateKey: idPair.privateKey,
        fingerprint: idPair.fingerprint,
        createdAt: DateTime.now(),
      );
      await saveUserIdentity(_currentUser!);
    }
  }

  Future<void> saveUserIdentity(UserIdentity user) async {
    _currentUser = user;
    await _prefs?.setString(AppConstants.keyUserIdentity, jsonEncode(user.toJson()));
    notifyListeners();
  }

  Future<void> _seedIfNeeded() async {
    // Check if contacts exist in drift
    final existingContacts = await dao.watchAllContacts().first;
    if (existingContacts.isEmpty) {
      await dao.insertOrUpdateContact(AppContact(
        id: 'contact-rahul',
        name: 'Rahul',
        phone: '+91 98123 45678',
        publicKey: 'PUBKEY_RAHUL_44919028',
        fingerprint: '3B81-229F-A810-7C01',
        isNearby: true,
        isOnline: false,
        approximateDistance: '3m',
      ));
      // Add more seeds...
    }
  }

  List<Message> getMessagesForConversation(String conversationId) {
    // Let's make it load async and return what we have in cache
    if (!_messagesByConversation.containsKey(conversationId)) {
      _messagesByConversation[conversationId] = [];
      _loadMessagesForConv(conversationId);
    }
    return _messagesByConversation[conversationId] ?? [];
  }
  
  void _loadMessagesForConv(String conversationId) {
    dao.watchMessagesForConversation(conversationId).listen((dbMsgs) {
      _messagesByConversation[conversationId] = dbMsgs.map((m) => Message(
        id: m.id,
        conversationId: m.conversationId,
        senderId: m.senderId,
        recipientId: m.recipientId,
        senderName: m.senderName,
        content: m.content,
        createdAt: m.createdAt,
        expiresAt: m.expiresAt,
        status: _parseStatus(m.status),
        transport: _parseTransport(m.transport),
        hopCount: m.hopCount,
        mediaType: _parseMediaType(m.mediaType),
      )).toList();
      notifyListeners();
    });
  }
  
  MessageStatus _parseStatus(String val) {
    switch(val) {
      case 'sent': return MessageStatus.sent;
      case 'delivered': return MessageStatus.delivered;
      case 'read': return MessageStatus.read;
      case 'forwarded': return MessageStatus.forwarded;
      case 'failed': return MessageStatus.failed;
      case 'pending': default: return MessageStatus.pending;
    }
  }
  
  MessageMediaType _parseMediaType(String val) {
    switch(val) {
      case 'image': return MessageMediaType.image;
      case 'audio': return MessageMediaType.audio;
      case 'document': return MessageMediaType.document;
      case 'text': default: return MessageMediaType.text;
    }
  }

  Future<void> saveMessage(Message message) async {
    _seenMessageIds.add(message.id);

    await dao.insertMessage(AppMessage(
      id: message.id,
      conversationId: message.conversationId,
      senderId: message.senderId,
      recipientId: message.recipientId,
      senderName: message.senderName,
      content: message.content,
      createdAt: message.createdAt,
      expiresAt: message.expiresAt,
      status: message.status.name,
      transport: message.transport.name,
      hopCount: message.hopCount,
      mediaType: message.mediaType.name,
      mediaUrl: message.mediaUrl,
      ttl: message.ttl,
      relayPath: message.relayPath,
    ));

    notifyListeners();
  }

  Future<void> updateMessageStatus(String messageId, MessageStatus status, {int? hopCount}) async {
    await dao.updateMessageStatus(messageId, status.name);
    // hopCount would need another DAO method, keeping simple for ponytail
  }

  Conversation? getConversationById(String id) {
    try {
      return _conversations.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Conversation getOrCreateConversationForPeer({
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
  }
}
