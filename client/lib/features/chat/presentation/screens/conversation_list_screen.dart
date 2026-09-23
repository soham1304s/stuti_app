import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/features/chat/domain/models/conversation.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:meshtalk_client/services/story_server_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meshtalk_client/app/providers.dart';

class ConversationListScreen extends ConsumerStatefulWidget {
  const ConversationListScreen({super.key});

  @override
  ConsumerState<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends ConsumerState<ConversationListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade200;
    final searchBgColor = isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                  Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
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
              child: Consumer(
                builder: (context, ref, child) {
                  final storyService = ref.watch(storyServerServiceProvider);
                  final myStory = storyService.myStory;
                  final peerStories = storyService.peerStories.values.toList();
                  
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Allow user to post a story locally (their device becomes the server)
                          _showPostStoryDialog(context, storyService);
                        },
                        child: _buildStoryAvatar(
                          'Your story', 
                          'Y', 
                          myStory != null, 
                          isSelf: true, 
                          isDark: isDark, 
                          textColor: textColor
                        ),
                      ),
                      ...peerStories.map((story) {
                        return GestureDetector(
                          onTap: () => _showStoryViewer(context, story),
                          child: _buildStoryAvatar(
                            story.authorName, 
                            story.authorName[0], 
                            true, 
                            isDark: isDark, 
                            textColor: textColor
                          ),
                        );
                      }),
                      // Mock hardcoded ones if no real ones
                      if (peerStories.isEmpty) ...[
                        _buildStoryAvatar('Mike', 'M', true, isDark: isDark, textColor: textColor),
                        _buildStoryAvatar('Alex Monroe', 'A', false, isDark: isDark, textColor: textColor),
                        _buildStoryAvatar('Maya Patel', 'M', true, hasEmoji: true, isDark: isDark, textColor: textColor),
                        _buildStoryAvatar('Emma Brooks', 'E', false, isDark: isDark, textColor: textColor),
                      ]
                    ],
                  );
                },
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
                  fillColor: searchBgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: textColor),
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
                    textColor: textColor,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                  _buildMockupTile(
                    name: 'Alex Monroe 📌',
                    message: 'Typing...',
                    time: '12:34',
                    unreadCount: 2,
                    textColor: textColor,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                  _buildMockupTile(
                    name: 'Emma Brooks',
                    message: 'I found that café I told you about everythink',
                    time: '12:34',
                    unreadCount: 2,
                    hasHeart: true,
                    textColor: textColor,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                  _buildMockupTile(
                    name: 'Mom 💬',
                    message: 'Don\'t forget your umbrella, they said it might rain.',
                    time: '12:34',
                    isRead: true,
                    textColor: textColor,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                  _buildMockupTile(
                    name: 'Maya Patel 📸',
                    message: 'I\'ll send you the draft tonight, promise',
                    time: '12:34',
                    unreadCount: 1,
                    textColor: textColor,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                  _buildMockupTile(
                    name: 'Liam',
                    message: 'Let me know if something needs fixing.',
                    time: '12:34',
                    unreadCount: 1,
                    textColor: textColor,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                  _buildMockupTile(
                    name: 'Noah',
                    message: 'Don\'t forget your umbrella they said',
                    time: '12:34',
                    unreadCount: 1,
                    textColor: textColor,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostStoryDialog(BuildContext context, StoryServerService service) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.darkSurface : Colors.white,
        title: Text('Post a Status (Local Server)', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your phone will act as an HTTP server on port 8081. Nearby devices will fetch this directly from your IP.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'What\'s on your mind?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                final storage = ref.read(storageServiceProvider);
                final name = storage.currentUser?.displayName ?? 'Me';
                service.postStory(name, controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Post (Host locally)'),
          ),
        ],
      ),
    );
  }

  void _showStoryViewer(BuildContext context, Story story) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryEmerald, AppTheme.meshCyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.white24, child: Text(story.authorName[0])),
                  const SizedBox(width: 12),
                  Text(story.authorName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              const Spacer(),
              Text(
                story.content,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                'Fetched directly from peer via LAN',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryAvatar(String name, String initial, bool hasStory, {bool isSelf = false, bool hasEmoji = false, required bool isDark, required Color textColor}) {
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
                  backgroundColor: isDark ? AppTheme.darkCard : Colors.grey.shade300,
                  child: Text(
                    initial,
                    style: TextStyle(fontSize: 24, color: textColor),
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
            style: TextStyle(fontSize: 12, color: textColor),
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
    required Color textColor,
    required Color cardColor,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? cardColor : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: isDark ? AppTheme.darkCard : Colors.grey.shade300,
          child: Text(
            name.characters.first,
            style: TextStyle(fontSize: 20, color: textColor),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor,
          ),
        ),
        subtitle: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            color: (unreadCount > 0 || message == 'Typing...') ? textColor : Colors.grey,
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
