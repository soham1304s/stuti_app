import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/core/crypto/crypto_helper.dart';
import 'package:meshtalk_client/features/auth/domain/models/user_identity.dart';
import 'package:meshtalk_client/features/chat/domain/models/conversation.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';
import 'package:meshtalk_client/features/contacts/domain/models/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends ChangeNotifier {
  SharedPreferences? _prefs;
  UserIdentity? _currentUser;
  final List<Conversation> _conversations = [];
  final Map<String, List<Message>> _messagesByConversation = {};
  final List<Contact> _contacts = [];
  final Set<String> _seenMessageIds = {};
  bool _isDarkMode = true;

  UserIdentity? get currentUser => _currentUser;
  List<Conversation> get conversations => List.unmodifiable(_conversations);
  List<Contact> get contacts => List.unmodifiable(_contacts);
  Set<String> get seenMessageIds => Set.unmodifiable(_seenMessageIds);
  bool get isDarkMode => _isDarkMode;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs?.getBool('isDarkMode') ?? true;
    await _loadUserIdentity();
    await _loadContacts();
    await _loadConversations();
    await _loadSeenMessageIds();
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
      // Default identity generation
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

  Future<void> _loadContacts() async {
    _contacts.clear();
    final contactsJson = _prefs?.getString(AppConstants.keyContacts);
    if (contactsJson != null) {
      final List<dynamic> list = jsonDecode(contactsJson);
      _contacts.addAll(list.map((e) => Contact.fromJson(e)));
    } else {
      // Seed initial contacts from README
      _contacts.addAll([
        Contact(
          id: 'contact-rahul',
          name: 'Rahul',
          phone: '+91 98123 45678',
          publicKey: 'PUBKEY_RAHUL_44919028',
          fingerprint: '3B81-229F-A810-7C01',
          isNearby: true,
          isOnline: false,
          approximateDistance: '3m',
        ),
        Contact(
          id: 'contact-priya',
          name: 'Priya',
          phone: '+91 97123 99887',
          publicKey: 'PUBKEY_PRIYA_88192019',
          fingerprint: '992A-4F01-C34E-B882',
          isNearby: true,
          isOnline: false,
          approximateDistance: '7m',
        ),
        Contact(
          id: 'contact-charlie',
          name: 'Charlie (Remote)',
          phone: '+91 96555 12345',
          publicKey: 'PUBKEY_CHARLIE_339180',
          fingerprint: '118E-AA40-9281-CC20',
          isNearby: false,
          isOnline: false,
        ),
        Contact(
          id: 'contact-vikram',
          name: 'Vikram',
          phone: '+91 99887 76655',
          publicKey: 'PUBKEY_VIKRAM_552109',
          fingerprint: '6F42-0199-8812-DDF1',
          isNearby: false,
          isOnline: true,
        ),
      ]);
      await _persistContacts();
    }
  }

  Future<void> _persistContacts() async {
    final list = _contacts.map((c) => c.toJson()).toList();
    await _prefs?.setString(AppConstants.keyContacts, jsonEncode(list));
    notifyListeners();
  }

  Future<void> _loadConversations() async {
    _conversations.clear();
    _messagesByConversation.clear();

    final now = DateTime.now();

    // Default Seed Conversations matching README scenarios
    final msgRahul = Message(
      id: 'msg-seed-1',
      conversationId: 'conv-rahul',
      senderId: 'contact-rahul',
      recipientId: _currentUser!.id,
      senderName: 'Rahul',
      content: 'Hey! The internet went down, are you in mesh range?',
      createdAt: now.subtract(const Duration(minutes: 6)),
      expiresAt: now.add(const Duration(hours: 24)),
      status: MessageStatus.read,
      transport: MessageTransport.bluetooth,
      hopCount: 0,
    );

    final msgPriya = Message(
      id: 'msg-seed-2',
      conversationId: 'conv-priya',
      senderId: _currentUser!.id,
      recipientId: 'contact-priya',
      senderName: _currentUser!.displayName,
      content: 'Here is the emergency map coordinate screenshot.',
      createdAt: now.subtract(const Duration(hours: 1)),
      expiresAt: now.add(const Duration(hours: 23)),
      status: MessageStatus.delivered,
      transport: MessageTransport.bluetooth,
      hopCount: 0,
      mediaType: MessageMediaType.image,
      mediaUrl: 'assets/sample_map.png',
    );

    final msgCharlie = Message(
      id: 'msg-seed-3',
      conversationId: 'conv-charlie',
      senderId: _currentUser!.id,
      recipientId: 'contact-charlie',
      senderName: _currentUser!.displayName,
      content: 'Relaying this emergency alert through Bob to you.',
      createdAt: now.subtract(const Duration(minutes: 18)),
      expiresAt: now.add(const Duration(hours: 24)),
      status: MessageStatus.forwarded,
      transport: MessageTransport.meshRelay,
      hopCount: 2,
      relayPath: ['PUBKEY_RAHUL_44919028', 'PUBKEY_BOB_77123'],
    );

    _messagesByConversation['conv-rahul'] = [msgRahul];
    _messagesByConversation['conv-priya'] = [msgPriya];
    _messagesByConversation['conv-charlie'] = [msgCharlie];

    _conversations.addAll([
      Conversation(
        id: 'conv-rahul',
        title: 'Rahul',
        peerId: 'contact-rahul',
        peerPublicKey: 'PUBKEY_RAHUL_44919028',
        peerFingerprint: '3B81-229F-A810-7C01',
        lastMessage: msgRahul,
        isNearby: true,
        approximateDistance: '3m',
        activeTransport: MessageTransport.bluetooth,
        avatarInitials: 'R',
        updatedAt: msgRahul.createdAt,
      ),
      Conversation(
        id: 'conv-priya',
        title: 'Priya',
        peerId: 'contact-priya',
        peerPublicKey: 'PUBKEY_PRIYA_88192019',
        peerFingerprint: '992A-4F01-C34E-B882',
        lastMessage: msgPriya,
        isNearby: true,
        approximateDistance: '7m',
        activeTransport: MessageTransport.bluetooth,
        avatarInitials: 'P',
        updatedAt: msgPriya.createdAt,
      ),
      Conversation(
        id: 'conv-charlie',
        title: 'Charlie',
        peerId: 'contact-charlie',
        peerPublicKey: 'PUBKEY_CHARLIE_339180',
        peerFingerprint: '118E-AA40-9281-CC20',
        lastMessage: msgCharlie,
        isNearby: false,
        activeTransport: MessageTransport.meshRelay,
        avatarInitials: 'C',
        updatedAt: msgCharlie.createdAt,
      ),
    ]);

    _seenMessageIds.addAll(['msg-seed-1', 'msg-seed-2', 'msg-seed-3']);
  }

  Future<void> _loadSeenMessageIds() async {
    final list = _prefs?.getStringList(AppConstants.keySeenMessageIds);
    if (list != null) {
      _seenMessageIds.addAll(list);
    }
  }

  List<Message> getMessagesForConversation(String conversationId) {
    return _messagesByConversation[conversationId] ?? [];
  }

  Future<void> saveMessage(Message message) async {
    _seenMessageIds.add(message.id);

    final list = _messagesByConversation.putIfAbsent(
      message.conversationId,
      () => [],
    );
    final index = list.indexWhere((m) => m.id == message.id);
    if (index >= 0) {
      list[index] = message;
    } else {
      list.add(message);
    }

    // Update conversation last message
    final convIndex = _conversations.indexWhere((c) => c.id == message.conversationId);
    if (convIndex >= 0) {
      final updated = _conversations[convIndex].copyWith(
        lastMessage: message,
        updatedAt: message.createdAt,
        activeTransport: message.transport,
      );
      _conversations.removeAt(convIndex);
      _conversations.insert(0, updated);
    }

    notifyListeners();
  }

  Future<void> updateMessageStatus(String messageId, MessageStatus status, {int? hopCount}) async {
    for (final messages in _messagesByConversation.values) {
      final index = messages.indexWhere((m) => m.id == messageId);
      if (index >= 0) {
        messages[index] = messages[index].copyWith(
          status: status,
          hopCount: hopCount ?? messages[index].hopCount,
        );
        notifyListeners();
        return;
      }
    }
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
    if (existing != null) {
      return existing;
    }

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

    _conversations.insert(0, newConv);
    notifyListeners();
    return newConv;
  }
}
