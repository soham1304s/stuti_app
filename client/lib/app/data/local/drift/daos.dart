import 'package:drift/drift.dart';
import 'database.dart';
import 'tables.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [AppMessages, AppConversations, AppContacts])
class AppDao extends DatabaseAccessor<AppDatabase> with _$AppDaoMixin {
  AppDao(super.db);

  // ---------- Messages ----------
  
  Future<void> insertMessage(AppMessage message) => into(appMessages).insert(message, mode: InsertMode.insertOrReplace);
  
  Future<void> updateMessageStatus(String id, String status) {
    return (update(appMessages)..where((m) => m.id.equals(id))).write(AppMessagesCompanion(status: Value(status)));
  }

  Stream<List<AppMessage>> watchMessagesForConversation(String conversationId) {
    return (select(appMessages)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([(m) => OrderingTerm(expression: m.createdAt, mode: OrderingMode.asc)]))
        .watch();
  }

  Future<List<AppMessage>> getPendingMessages() {
    return (select(appMessages)..where((m) => m.status.equals('pending'))).get();
  }

  Stream<List<AppMessage>> watchPendingMessages() {
    return (select(appMessages)..where((m) => m.status.equals('pending'))).watch();
  }

  // ---------- Conversations ----------
  
  Future<void> insertOrUpdateConversation(AppConversation conv) => into(appConversations).insert(conv, mode: InsertMode.insertOrReplace);

  Stream<List<AppConversation>> watchAllConversations() {
    return (select(appConversations)
          ..orderBy([(c) => OrderingTerm(expression: c.updatedAt, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<void> updateConversationUnreadCount(String id, int unreadCount) {
    return (update(appConversations)..where((c) => c.id.equals(id))).write(AppConversationsCompanion(unreadCount: Value(unreadCount)));
  }

  // ---------- Contacts ----------
  
  Future<void> insertOrUpdateContact(AppContact contact) => into(appContacts).insert(contact, mode: InsertMode.insertOrReplace);

  Stream<List<AppContact>> watchAllContacts() {
    return (select(appContacts)
          ..orderBy([(c) => OrderingTerm(expression: c.name, mode: OrderingMode.asc)]))
        .watch();
  }
}
