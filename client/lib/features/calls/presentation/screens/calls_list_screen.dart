import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';

class CallsListScreen extends StatelessWidget {
  const CallsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;

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
                    'Calls',
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
                      Icons.add_call,
                      color: AppTheme.primaryEmerald,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildCallTile('Rahul', 'Yesterday, 10:30 AM', true, false, isDark, textColor),
                  _buildCallTile('Priya', 'Monday, 2:15 PM', false, true, isDark, textColor),
                  _buildCallTile('Mike', 'Sunday, 11:00 AM', true, true, isDark, textColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallTile(String name, String time, bool isVideo, bool isMissed, bool isDark, Color textColor) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: isDark ? AppTheme.darkCard : Colors.grey.shade300,
        child: Text(name[0], style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      title: Text(
        name,
        style: TextStyle(
          color: isMissed ? Colors.red : textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(isMissed ? Icons.call_missed : Icons.call_received, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
      trailing: Icon(isVideo ? Icons.videocam : Icons.call, color: AppTheme.primaryEmerald),
    );
  }
}
