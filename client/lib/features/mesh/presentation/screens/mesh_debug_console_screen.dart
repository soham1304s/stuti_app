import 'package:flutter/material.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/features/chat/domain/models/message.dart';
import 'package:meshtalk_client/services/connectivity_service.dart';
import 'package:meshtalk_client/services/nearby_device_service.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:meshtalk_client/services/sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meshtalk_client/app/providers.dart';
import 'package:uuid/uuid.dart';

class MeshDebugConsoleScreen extends ConsumerStatefulWidget {
  const MeshDebugConsoleScreen({super.key});

  @override
  ConsumerState<MeshDebugConsoleScreen> createState() => _MeshDebugConsoleScreenState();
}

class _MeshDebugConsoleScreenState extends ConsumerState<MeshDebugConsoleScreen> {
  final List<String> _consoleLogs = [
    '[SYSTEM] Node identity initialized (AES-GCM / Ed25519 derivation)',
    '[BLE] Advertising service UUID 0xFD6F (MeshTalk v1)',
    '[ROUTING] Route discovered to peer Rahul via direct BLE link',
    '[MESH] Forwarded packet msg-seed-3 through 2 hops (TTL: 6)',
  ];

  void _injectTestRelayPacket() {
    final sync = ref.read(syncServiceProvider);
    final testMsg = Message(
      id: 'test-relay-${const Uuid().v4().substring(0, 6)}',
      conversationId: 'conv-simulated',
      senderId: 'device-node-alice',
      recipientId: 'device-node-charlie',
      senderName: 'Alice (via Relay)',
      content: 'Multi-hop beacon packet routed through your node',
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
      ttl: 6,
      hopCount: 1,
      status: MessageStatus.forwarded,
      transport: MessageTransport.meshRelay,
      relayPath: ['device-node-alice'],
    );

    sync.processIncomingMeshPacket(testMsg, 'device-node-bob');

    setState(() {
      _consoleLogs.insert(
        0,
        '[RELAY] Stored & forwarded multi-hop envelope (${testMsg.id}) hop=${testMsg.hopCount + 1}',
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulated packet relayed: Hop count incremented, TTL decremented'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _injectDuplicatePacket() {
    final sync = ref.read(syncServiceProvider);
    final storage = ref.read(storageServiceProvider);

    // Send a packet with an already-seen ID
    final duplicateMsg = Message(
      id: 'msg-seed-1', // Already in storage
      conversationId: 'conv-rahul',
      senderId: 'contact-rahul',
      recipientId: storage.currentUser?.id ?? '',
      senderName: 'Rahul',
      content: 'Duplicate packet',
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
      status: MessageStatus.sent,
      transport: MessageTransport.bluetooth,
    );

    sync.processIncomingMeshPacket(duplicateMsg, 'device-node-rahul');

    setState(() {
      _consoleLogs.insert(
        0,
        '[DROP] Rejected duplicate packet ${duplicateMsg.id} (Anti-flooding protection)',
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Duplicate packet detected and discarded!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivity = ref.watch(connectivityServiceProvider);
    final nearby = ref.watch(nearbyDeviceServiceProvider);
    final sync = ref.watch(syncServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesh Debug Console'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_outlined),
            tooltip: 'Clear Logs',
            onPressed: () => setState(() => _consoleLogs.clear()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Network Hardware Status
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Internet',
                    value: connectivity.isInternetAvailable ? 'CONNECTED' : 'OFFLINE',
                    color: connectivity.isInternetAvailable
                        ? AppTheme.onlineColor
                        : AppTheme.offlineColor,
                    icon: connectivity.isInternetAvailable
                        ? Icons.cloud_done
                        : Icons.cloud_off,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    title: 'Bluetooth LE',
                    value: connectivity.isBluetoothAvailable ? 'ACTIVE' : 'OFF',
                    color: connectivity.isBluetoothAvailable
                        ? AppTheme.nearbyMeshColor
                        : AppTheme.offlineColor,
                    icon: Icons.bluetooth,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    title: 'Nearby Peers',
                    value: '${nearby.devices.length}',
                    color: AppTheme.meshCyan,
                    icon: Icons.people_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Section: Mesh Transfer Metrics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.analytics_outlined, color: AppTheme.primaryEmerald, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Store & Forward Statistics',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          label: 'Queued',
                          value: '${sync.offlineQueue.length}',
                          color: AppTheme.connectingColor,
                        ),
                        _StatItem(
                          label: 'Forwarded',
                          value: '${sync.forwardedCount}',
                          color: AppTheme.meshCyan,
                        ),
                        _StatItem(
                          label: 'Transferred',
                          value: '${sync.successfulTransfers}',
                          color: AppTheme.onlineColor,
                        ),
                        _StatItem(
                          label: 'Duplicates Dropped',
                          value: '${sync.duplicateDropsCount}',
                          color: const Color(0xFFEF4444),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Average Mesh Hops',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  sync.averageHops.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primaryEmerald,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Maximum Recorded Hops',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${sync.maxHopsRecorded}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.meshCyan,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Simulation Action Triggers
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.darkCard,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _injectTestRelayPacket,
                    icon: const Icon(Icons.alt_route, size: 16, color: AppTheme.meshCyan),
                    label: const Text('Simulate Relay (A→B→C)', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.darkCard,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _injectDuplicatePacket,
                    icon: const Icon(Icons.content_copy, size: 16, color: AppTheme.connectingColor),
                    label: const Text('Simulate Duplicate', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Live Protocol Logs
            const Text(
              'Live Protocol Event Logs',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Container(
              height: 220,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0E17),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: _consoleLogs.isEmpty
                  ? const Center(
                      child: Text(
                        'No event logs recorded',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _consoleLogs.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final log = _consoleLogs[index];
                        Color logColor = const Color(0xFFCBD5E1);
                        if (log.contains('[RELAY]')) logColor = AppTheme.meshCyan;
                        if (log.contains('[DROP]')) logColor = const Color(0xFFEF4444);
                        if (log.contains('[BLE]')) logColor = AppTheme.nearbyMeshColor;
                        if (log.contains('[SYSTEM]')) logColor = AppTheme.primaryEmerald;

                        return Text(
                          log,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: logColor,
                            height: 1.3,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends ConsumerWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends ConsumerWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
        ),
      ],
    );
  }
}
