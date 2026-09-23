import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/features/nearby/domain/models/nearby_device.dart';
import 'package:meshtalk_client/services/connectivity_service.dart';
import 'package:meshtalk_client/services/nearby_device_service.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meshtalk_client/app/providers.dart';

class NearbyRadarScreen extends ConsumerStatefulWidget {
  const NearbyRadarScreen({super.key});

  @override
  State<NearbyRadarScreen> createState() => _NearbyRadarScreenState();
}

class _NearbyRadarScreenState extends ConsumerState<NearbyRadarScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Start discovery scan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nearbyDeviceServiceProvider).startScanning();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _connectAndOpenChat(NearbyDevice device) {
    final storage = ref.read(storageServiceProvider);
    final conversation = storage.getOrCreateConversationForPeer(
      peerId: device.deviceId,
      peerName: device.name,
      peerPublicKey: device.publicKey,
      peerFingerprint: device.fingerprint,
      isNearby: true,
      approximateDistance: device.approximateDistance,
    );

    context.push('/chats/${conversation.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearby = ref.watch(nearbyDeviceServiceProvider);
    final connectivity = ref.watch(connectivityServiceProvider);
    final devices = nearby.devices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Mesh Radar'),
        actions: [
          IconButton(
            icon: Icon(
              nearby.isScanning ? Icons.stop_circle_outlined : Icons.radar,
              color: nearby.isScanning ? AppTheme.meshCyan : null,
            ),
            tooltip: nearby.isScanning ? 'Stop Scanning' : 'Start Scanning',
            onPressed: () {
              if (nearby.isScanning) {
                nearby.stopScanning();
              } else {
                nearby.startScanning();
              }
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Radar Visualization Graphic
          SliverToBoxAdapter(
            child: Container(
              height: 240,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Concentric animated radar waves
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(220, 220),
                        painter: _RadarPainter(
                          pulseProgress: _pulseController.value,
                          deviceCount: devices.length,
                        ),
                      );
                    },
                  ),

                  // Center Node (Me)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryEmerald,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryEmerald.withValues(alpha: 0.5),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_pin_circle_rounded,
                      color: Colors.black,
                      size: 26,
                    ),
                  ),

                  // Top indicator label
                  Positioned(
                    top: 14,
                    left: 16,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryEmerald,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          nearby.isScanning
                              ? 'Continuous BLE Scanning'
                              : 'Scan Paused',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Peer count chip
                  Positioned(
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Text(
                        '${devices.length} Mesh Nodes Discovered',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.meshCyan,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Discovered Peers List Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Text(
                    'Nearby MeshTalk Users',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    connectivity.isInternetAvailable
                        ? 'Internet Available'
                        : 'Operating in Offline Mesh',
                    style: TextStyle(
                      fontSize: 12,
                      color: connectivity.isInternetAvailable
                          ? AppTheme.onlineColor
                          : AppTheme.nearbyMeshColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Peer Cards List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final device = devices[index];
                  return _NearbyDeviceCard(
                    device: device,
                    onConnect: () => _connectAndOpenChat(device),
                  );
                },
                childCount: devices.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyDeviceCard extends ConsumerWidget {
  final NearbyDevice device;
  final VoidCallback onConnect;

  const _NearbyDeviceCard({
    required this.device,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.darkCard,
                  child: const Icon(
                    Icons.bluetooth,
                    color: AppTheme.nearbyMeshColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.onlineColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            device.approximateDistance,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'RSSI: ${device.rssi} dBm',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onConnect,
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryEmerald,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Fingerprint: ${device.fingerprint.substring(0, 9)}...',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                const Spacer(),
                Wrap(
                  spacing: 4,
                  children: device.capabilities
                      .map(
                        (cap) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF334155),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            cap,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double pulseProgress;
  final int deviceCount;

  _RadarPainter({required this.pulseProgress, required this.deviceCount});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    final circlePaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw static concentric rings
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, (maxRadius / 3) * i, circlePaint);
    }

    // Draw expanding animated pulse wave
    final wavePaint = Paint()
      ..color = AppTheme.meshCyan.withValues(alpha: (1.0 - pulseProgress) * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, maxRadius * pulseProgress, wavePaint);

    // Draw sweeping radar angle
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          AppTheme.primaryEmerald.withValues(alpha: 0.15),
        ],
        transform: GradientRotation(pulseProgress * 2 * pi),
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, maxRadius, sweepPaint);

    // Draw peer node dots based on deviceCount
    final dotPaint = Paint()
      ..color = AppTheme.nearbyMeshColor
      ..style = PaintingStyle.fill;

    final dotGlow = Paint()
      ..color = AppTheme.nearbyMeshColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final points = [
      Offset(center.dx - 45, center.dy - 35), // Rahul (3m)
      Offset(center.dx + 55, center.dy + 45), // Priya (7m)
      Offset(center.dx - 65, center.dy + 50), // Relay (15m)
    ];

    for (int i = 0; i < min(deviceCount, points.length); i++) {
      canvas.drawCircle(points[i], 8, dotGlow);
      canvas.drawCircle(points[i], 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.pulseProgress != pulseProgress ||
        oldDelegate.deviceCount != deviceCount;
  }
}
