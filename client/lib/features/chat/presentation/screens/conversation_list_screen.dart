import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/features/chat/domain/models/conversation.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:provider/provider.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primaryEmerald),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.add,
                      color: AppTheme.primaryEmerald,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),

            // Stories Row
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildStoryAvatar('Your story', 'Y', true, isSelf: true),
                  _buildStoryAvatar('Mike', 'M', true),
                  _buildStoryAvatar('Alex Monroe', 'A', false),
                  _buildStoryAvatar('Maya Patel', 'M', true, hasEmoji: true),
                  _buildStoryAvatar('Emma Brooks', 'E', false),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF2C2C2E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),

            // Chat List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8),
                children: [
                  _buildMockupTile(
                    name: 'Mike',
                    message: 'Great idea!',
                    time: '12:34',
                    isActive: true,
                  ),
                  _buildMockupTile(
                    name: 'Alex Monroe 📌',
                    message: 'Typing...',
                    time: '12:34',
                    unreadCount: 2,
                  ),
                  _buildMockupTile(
                    name: 'Emma Brooks',
                    message: 'I found that café I told you about everythink',
                    time: '12:34',
                    unreadCount: 2,
                    hasHeart: true,
                  ),
                  _buildMockupTile(
                    name: 'Mom 💬',
                    message: 'Don\'t forget your umbrella, they said it might rain.',
                    time: '12:34',
                    isRead: true,
                  ),
                  _buildMockupTile(
                    name: 'Maya Patel 📸',
                    message: 'I\'ll send you the draft tonight, promise',
                    time: '12:34',
                    unreadCount: 1,
                  ),
                  _buildMockupTile(
                    name: 'Liam',
                    message: 'Let me know if something needs fixing.',
                    time: '12:34',
                    unreadCount: 1,
                  ),
                  _buildMockupTile(
                    name: 'Noah',
                    message: 'Don\'t forget your umbrella they said',
                    time: '12:34',
                    unreadCount: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryAvatar(String name, String initial, bool hasStory, {bool isSelf = false, bool hasEmoji = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: hasStory ? AppTheme.primaryEmerald : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.darkCard,
                  child: Text(
                    initial,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              if (isSelf)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryEmerald,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.add, size: 12, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMockupTile({
    required String name,
    required String message,
    required String time,
    bool isActive = false,
    int unreadCount = 0,
    bool hasHeart = false,
    bool isRead = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E1E1E) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: AppTheme.darkCard,
          child: Text(
            name.characters.first,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            color: (unreadCount > 0 || message == 'Typing...') ? Colors.white : Colors.grey,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasHeart)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.favorite, color: AppTheme.primaryEmerald, size: 14),
                  ),
                if (isRead)
                  const Icon(Icons.done_all, color: Colors.grey, size: 16),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryEmerald,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
