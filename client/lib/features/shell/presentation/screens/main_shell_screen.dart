import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/app/providers.dart';

class MainShellScreen extends ConsumerWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/contacts')) return 0; // People
    if (location.startsWith('/calls')) return 1;    // Calls
    if (location.startsWith('/chats')) return 2;    // Chats
    if (location.startsWith('/settings')) return 3; // Settings
    return 2; // Default to Chats
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/contacts');
        break;
      case 1:
        context.go('/calls');
        break;
      case 2:
        context.go('/chats');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  void _showNetworkSimulatorSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final connectivity = ref.watch(connectivityServiceProvider);
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.tune, color: AppTheme.primaryEmerald),
                        const SizedBox(width: 8),
                        const Text(
                          'Mesh Network Environment Simulator',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Test real-time offline fallback, BLE routing, and store-and-forward mesh switching.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    ),
                    const Divider(height: 24),

                    // Internet Toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Internet Connectivity',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        connectivity.isInternetAvailable
                            ? 'Cloud WebSocket Active'
                            : 'Internet Disconnected (Simulating Outage)',
                        style: TextStyle(
                          color: connectivity.isInternetAvailable
                              ? AppTheme.onlineColor
                              : const Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                      value: connectivity.isInternetAvailable,
                      activeTrackColor: AppTheme.primaryEmerald,
                      onChanged: (val) {
                        connectivity.toggleInternet(val);
                      },
                    ),

                    // Bluetooth Toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Bluetooth Low Energy (BLE)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        connectivity.isBluetoothAvailable
                            ? 'BLE Scanning & Advertising Active'
                            : 'Bluetooth Radio Disabled',
                        style: TextStyle(
                          color: connectivity.isBluetoothAvailable
                              ? AppTheme.nearbyMeshColor
                              : const Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                      value: connectivity.isBluetoothAvailable,
                      activeTrackColor: AppTheme.meshCyan,
                      onChanged: (val) {
                        connectivity.toggleBluetooth(val);
                      },
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      'Quick Presets:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFCBD5E1),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionChip(
                          avatar: const Icon(
                            Icons.cloud_done_outlined,
                            size: 16,
                            color: AppTheme.onlineColor,
                          ),
                          label: const Text('Normal (Online)'),
                          onPressed: () {
                            connectivity.setSimulatedMode(ConnectivityMode.online);
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(
                            Icons.bluetooth_connected,
                            size: 16,
                            color: AppTheme.nearbyMeshColor,
                          ),
                          label: const Text('Internet Cut (BLE Active)'),
                          onPressed: () {
                            connectivity.setSimulatedMode(ConnectivityMode.nearbyMesh);
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(
                            Icons.wifi_off,
                            size: 16,
                            color: AppTheme.offlineColor,
                          ),
                          label: const Text('Total Outage (Offline Queue)'),
                          onPressed: () {
                            connectivity.setSimulatedMode(ConnectivityMode.offline);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityServiceProvider);
    final mode = connectivity.currentMode;

    final currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: child),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (idx) => _onItemTapped(idx, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt, color: AppTheme.primaryEmerald),
            label: 'People',
          ),
          NavigationDestination(
            icon: Icon(Icons.phone_outlined),
            selectedIcon: Icon(Icons.phone, color: AppTheme.primaryEmerald),
            label: 'Calls',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble, color: AppTheme.primaryEmerald),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppTheme.primaryEmerald),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

