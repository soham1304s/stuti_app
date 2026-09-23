import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';
import 'package:meshtalk_client/services/connectivity_service.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:meshtalk_client/app/data/local/drift/daos.dart';
import 'package:meshtalk_client/app/data/local/drift/database.dart';

class SyncService extends ChangeNotifier {
  final StorageService storageService;
  final ConnectivityService connectivityService;
  final SupabaseClient _supabase = Supabase.instance.client;
  
  RealtimeChannel? _messagesChannel;
  StreamSubscription? _pendingMessagesSub;

  final List<Message> _offlineQueue = [];
  int _forwardedCount = 7;
  int _successfulTransfers = 15;
  int _failedTransfers = 1;
  int _duplicateDropsCount = 4;
  double _averageHops = 1.7;
  int _maxHopsRecorded = 4;

  List<Message> get offlineQueue => List.unmodifiable(_offlineQueue);
  int get forwardedCount => _forwardedCount;
  int get successfulTransfers => _successfulTransfers;
  int get failedTransfers => _failedTransfers;
  int get duplicateDropsCount => _duplicateDropsCount;
  double get averageHops => _averageHops;
  int get maxHopsRecorded => _maxHopsRecorded;

  SyncService({
    required this.storageService,
    required this.connectivityService,
  }) {
    // ponytail: we are cutting a corner here by doing simple one-way sync and realtime subscriptions, 
    // ceiling: full CRDT or sync token based reconciliation for robust offline-first.
    _initSupabaseSync();
  }

  void _initSupabaseSync() {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) return;
    
    _messagesChannel = _supabase.channel('public:messages');
    _messagesChannel?.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'recipient_id',
        value: currentUserId,
      ),
      callback: (payload) {
        _handleIncomingCloudMessage(payload.newRecord);
      },
    ).subscribe();

    // Listen to local pending messages to push
    // ponytail: a polling approach or a robust background task queue is better here.
    _pendingMessagesSub = storageService.dao.watchPendingMessages().listen((messages) {
      if (connectivityService.currentMode == ConnectivityMode.online) {
        _pushPendingMessages(messages);
      }
    });
  }
  
  Future<void> _handleIncomingCloudMessage(Map<String, dynamic> record) async {
    // ponytail: mapping directly here
    final msg = AppMessage(
      id: record['id'] as String,
      conversationId: record['conversation_id'] as String,
      senderId: record['sender_id'] as String,
      recipientId: record['recipient_id'] as String,
      senderName: record['sender_name'] ?? 'Unknown',
      content: record['content'] as String,
      createdAt: DateTime.parse(record['created_at'] as String),
      expiresAt: DateTime.parse(record['expires_at'] as String),
      status: 'delivered',
      transport: 'internet',
      ttl: record['ttl'] ?? 8,
      hopCount: record['hop_count'] ?? 0,
      relayPath: [],
      mediaType: 'text',
    );
    await storageService.dao.insertMessage(msg);
  }

  Future<void> _pushPendingMessages(List<AppMessage> pending) async {
    for (final m in pending) {
      try {
        await _supabase.from('messages').insert({
          'id': m.id,
          'conversation_id': m.conversationId,
          'sender_id': m.senderId,
          'recipient_id': m.recipientId,
          'sender_name': m.senderName,
          'content': m.content,
          'status': 'sent',
          'transport': 'internet',
        });
        await storageService.dao.updateMessageStatus(m.id, 'sent');
      } catch (e) {
        print('Error pushing message: ');
      }
    }
  }

  @override
  void dispose() {
    _messagesChannel?.unsubscribe();
    _pendingMessagesSub?.cancel();
    super.dispose();
  }

  // --- Legacy Mock Mesh Methods ---

  Future<void> enqueueOfflineMessage(Message message) async {
    final queuedMessage = message.copyWith(
      status: MessageStatus.queuedOffline,
      transport: MessageTransport.meshRelay,
    );
    _offlineQueue.add(queuedMessage);
    await storageService.saveMessage(queuedMessage);
    notifyListeners();
  }

  Future<bool> processIncomingMeshPacket(Message packet, String peerDeviceId) async {
    if (storageService.seenMessageIds.contains(packet.id)) {
      _duplicateDropsCount++;
      notifyListeners();
      return false;
    }
    if (packet.isExpired) {
      _failedTransfers++;
      notifyListeners();
      return false;
    }
    final currentUserId = storageService.currentUser?.id ?? '';
    final isForMe = packet.recipientId == currentUserId;
    if (isForMe) {
      final delivered = packet.copyWith(
        status: MessageStatus.delivered,
        hopCount: packet.hopCount + 1,
      );
      await storageService.saveMessage(delivered);
      _successfulTransfers++;
      _recordHopMetric(delivered.hopCount);
      notifyListeners();
      return true;
    } else {
      if (packet.ttl > 1) {
        final forwardedPacket = packet.copyWith(
          hopCount: packet.hopCount + 1,
          ttl: packet.ttl - 1,
          relayPath: [...packet.relayPath, peerDeviceId],
          status: MessageStatus.forwarded,
        );
        _forwardedCount++;
        _offlineQueue.add(forwardedPacket);
        await storageService.saveMessage(forwardedPacket);
        _recordHopMetric(forwardedPacket.hopCount);
        notifyListeners();
        return true;
      } else {
        _failedTransfers++;
        notifyListeners();
        return false;
      }
    }
  }

  void _recordHopMetric(int hops) {
    if (hops > _maxHopsRecorded) {
      _maxHopsRecorded = hops;
    }
    _averageHops = ((_averageHops * _successfulTransfers) + hops) / (_successfulTransfers + 1);
  }

  Future<void> syncPendingQueueToCloud() async {
    if (_offlineQueue.isEmpty) return;
    final messagesToSync = List<Message>.from(_offlineQueue);
    for (final message in messagesToSync) {
      await Future.delayed(const Duration(milliseconds: 300));
      await storageService.updateMessageStatus(message.id, MessageStatus.delivered);
      _successfulTransfers++;
    }
    _offlineQueue.clear();
    notifyListeners();
  }
}
