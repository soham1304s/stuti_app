import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:meshtalk_client/services/sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meshtalk_client/app/providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _enableStoreAndForwardRelay = true;
  bool _batteryOptimization = true;
  String _scanMode = 'Adaptive';
  final int _maxHops = 8;
  int _cacheTtlHours = 24;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final cardColor = isDark ? AppTheme.darkCard : Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
          // Section: Profile
          _buildSectionHeader('ACCOUNT', AppTheme.primaryEmerald),
          Card(
            color: cardColor,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.primaryEmerald,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text('My Profile', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              subtitle: Text('Manage your Node Identity', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              trailing: Icon(Icons.chevron_right, color: Colors.grey.shade500),
              onTap: () => context.push('/profile'),
            ),
          ),
          const SizedBox(height: 16),

          // Section: Appearance
          _buildSectionHeader('APPEARANCE', AppTheme.primaryEmerald),
          Card(
            color: cardColor,
            child: Consumer<StorageService>(
              builder: (context, storage, _) {
                return SwitchListTile(
                  title: Text('Dark Mode', style: TextStyle(color: textColor)),
                  subtitle: Text(
                    'Toggle dark and light theme',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  value: storage.isDarkMode,
                  activeTrackColor: AppTheme.primaryEmerald,
                  onChanged: (val) {
                    storage.toggleTheme();
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Section: Mesh Relay
          _buildSectionHeader('OFF-GRID MESH ROUTING', AppTheme.primaryEmerald),
          Card(
            color: cardColor,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Participate in Store & Forward Relay', style: TextStyle(color: textColor)),
                  subtitle: Text(
                    'Temporarily hold and forward encrypted envelopes for other nearby users without decrypting them.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  value: _enableStoreAndForwardRelay,
                  activeTrackColor: AppTheme.primaryEmerald,
                  onChanged: (val) => setState(() => _enableStoreAndForwardRelay = val),
                ),
                Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade300),
                ListTile(
                  title: Text('BLE Scan Profile', style: TextStyle(color: textColor)),
                  subtitle: Text(
                    '$_scanMode (Balances battery life & instant peer discovery)',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  trailing: DropdownButton<String>(
                    value: _scanMode,
                    underline: const SizedBox.shrink(),
                    dropdownColor: isDark ? AppTheme.darkSurface : Colors.white,
                    style: TextStyle(color: textColor),
                    items: const [
                      DropdownMenuItem(value: 'Adaptive', child: Text('Adaptive')),
                      DropdownMenuItem(value: 'Continuous', child: Text('Continuous (High)')),
                      DropdownMenuItem(value: 'Battery Saver', child: Text('Battery Saver')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _scanMode = val);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section: Cache & Storage
          _buildSectionHeader('STORAGE & PRIVACY', AppTheme.meshCyan),
          Card(
            color: cardColor,
            child: Column(
              children: [
                ListTile(
                  title: Text('Offline Message Expiration (TTL)', style: TextStyle(color: textColor)),
                  subtitle: Text(
                    '$_cacheTtlHours Hours (Purges expired payloads automatically)',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  trailing: DropdownButton<int>(
                    value: _cacheTtlHours,
                    underline: const SizedBox.shrink(),
                    dropdownColor: isDark ? AppTheme.darkSurface : Colors.white,
                    style: TextStyle(color: textColor),
                    items: const [
                      DropdownMenuItem(value: 12, child: Text('12 Hours')),
                      DropdownMenuItem(value: 24, child: Text('24 Hours')),
                      DropdownMenuItem(value: 48, child: Text('48 Hours')),
                      DropdownMenuItem(value: 168, child: Text('7 Days')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _cacheTtlHours = val);
                    },
                  ),
                ),
                Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade300),
                SwitchListTile(
                  title: Text('Strict Battery Optimization', style: TextStyle(color: textColor)),
                  subtitle: Text(
                    'Throttle background radio when battery is below 20%',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  value: _batteryOptimization,
                  activeTrackColor: AppTheme.meshCyan,
                  onChanged: (val) => setState(() => _batteryOptimization = val),
                ),
                Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade300),
                ListTile(
                  leading: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                  title: const Text(
                    'Clear Relayed Envelope Cache',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    final sync = context.read<SyncService>();
                    sync.syncPendingQueueToCloud();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Temporary mesh relay cache cleared.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Version Card
          Center(
            child: Column(
              children: [
                Text(
                  'MeshTalk v1.0.0 (Production Client)',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 2),
                Text(
                  'Protocol: meshtalk/v1 • Ed25519 & AES-GCM Envelope',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
      ),
      ],
      ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: color,
        ),
      ),
    );
  }
}
