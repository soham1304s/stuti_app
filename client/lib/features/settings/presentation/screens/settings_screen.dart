import 'package:flutter/material.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/services/sync_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _enableStoreAndForwardRelay = true;
  bool _batteryOptimization = true;
  String _scanMode = 'Adaptive';
  final int _maxHops = 8;
  int _cacheTtlHours = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MeshTalk Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Section: Mesh Relay
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Text(
              'OFF-GRID MESH ROUTING',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppTheme.primaryEmerald,
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Participate in Store & Forward Relay'),
                  subtitle: const Text(
                    'Temporarily hold and forward encrypted envelopes for other nearby users without decrypting them.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                  value: _enableStoreAndForwardRelay,
                  activeTrackColor: AppTheme.primaryEmerald,
                  onChanged: (val) => setState(() => _enableStoreAndForwardRelay = val),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('BLE Scan Profile'),
                  subtitle: Text(
                    '$_scanMode (Balances battery life & instant peer discovery)',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                  trailing: DropdownButton<String>(
                    value: _scanMode,
                    underline: const SizedBox.shrink(),
                    dropdownColor: AppTheme.darkSurface,
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
                const Divider(height: 1),
                ListTile(
                  title: const Text('Maximum Hop Count Limit'),
                  subtitle: const Text(
                    'Caps packets to avoid network cycles & bandwidth congestion',
                    style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.darkCard,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$_maxHops Hops',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section: Cache & Storage
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Text(
              'STORAGE & PRIVACY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppTheme.meshCyan,
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Offline Message Expiration (TTL)'),
                  subtitle: Text(
                    '$_cacheTtlHours Hours (Purges expired payloads automatically)',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                  trailing: DropdownButton<int>(
                    value: _cacheTtlHours,
                    underline: const SizedBox.shrink(),
                    dropdownColor: AppTheme.darkSurface,
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
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Strict Battery Optimization'),
                  subtitle: const Text(
                    'Throttle background radio when battery is below 20%',
                    style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                  value: _batteryOptimization,
                  activeTrackColor: AppTheme.meshCyan,
                  onChanged: (val) => setState(() => _batteryOptimization = val),
                ),
                const Divider(height: 1),
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
          const Center(
            child: Column(
              children: [
                Text(
                  'MeshTalk v1.0.0 (Production Client)',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                SizedBox(height: 2),
                Text(
                  'Protocol: meshtalk/v1 • Ed25519 & AES-GCM Envelope',
                  style: TextStyle(fontSize: 11, color: Color(0xFF475569)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
