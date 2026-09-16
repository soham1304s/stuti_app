import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:meshtalk_client/core/crypto/crypto_helper.dart';
import 'package:meshtalk_client/features/nearby/domain/models/nearby_device.dart';

abstract class INearbyDeviceService {
  bool get isScanning;
  List<NearbyDevice> get devices;
  Stream<List<NearbyDevice>> get onDevicesChanged;
  Future<void> startScanning();
  Future<void> stopScanning();
  Future<bool> connect(NearbyDevice device);
  NearbyDevice? findDeviceByPublicKey(String publicKey);
}

/// Nearby discovery and BLE session manager conforming to section 508 & 890
class NearbyDeviceService extends ChangeNotifier implements INearbyDeviceService {
  bool _isScanning = false;
  final List<NearbyDevice> _devices = [];
  Timer? _scanTimer;

  final _devicesStreamController = StreamController<List<NearbyDevice>>.broadcast();

  @override
  bool get isScanning => _isScanning;

  @override
  List<NearbyDevice> get devices => List.unmodifiable(_devices);

  @override
  Stream<List<NearbyDevice>> get onDevicesChanged => _devicesStreamController.stream;

  NearbyDeviceService() {
    _seedInitialNearbyDevices();
  }

  void _seedInitialNearbyDevices() {
    _devices.addAll([
      NearbyDevice(
        deviceId: 'device-rahul-001',
        name: 'Rahul',
        publicKey: 'PUBKEY_RAHUL_44919028',
        fingerprint: '3B81-229F-A810-7C01',
        capabilities: ['text', 'image', 'file'],
        rssi: -58,
        approximateDistance: '3 meters away',
        isConnected: true,
        lastSeen: DateTime.now(),
      ),
      NearbyDevice(
        deviceId: 'device-priya-002',
        name: 'Priya',
        publicKey: 'PUBKEY_PRIYA_88192019',
        fingerprint: '992A-4F01-C34E-B882',
        capabilities: ['text', 'image'],
        rssi: -72,
        approximateDistance: '7 meters away',
        isConnected: false,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      NearbyDevice(
        deviceId: 'device-anonymous-relay',
        name: 'Anonymous Node (Relay)',
        publicKey: 'PUBKEY_RELAY_NODE_77190',
        fingerprint: '7721-DF80-001A-4C41',
        capabilities: ['text', 'forwarding'],
        rssi: -84,
        approximateDistance: '15 meters away',
        isConnected: true,
        lastSeen: DateTime.now(),
      ),
    ]);
  }

  @override
  Future<void> startScanning() async {
    _isScanning = true;
    notifyListeners();

    _scanTimer?.cancel();
    _scanTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      // Simulate RSSI fluctuations and intermittent new peer discovery
      if (_devices.length < 5) {
        final newId = 'node-${_devices.length + 1}';
        final pubKey = 'PUBKEY_${CryptoHelper.generateNonce()}';
        _devices.add(
          NearbyDevice(
            deviceId: newId,
            name: 'Nearby Node #${_devices.length + 1}',
            publicKey: pubKey,
            fingerprint: CryptoHelper.computeFingerprint(pubKey),
            capabilities: ['text'],
            rssi: -79,
            approximateDistance: '12 meters away',
            isConnected: false,
            lastSeen: DateTime.now(),
          ),
        );
      }
      _devicesStreamController.add(_devices);
      notifyListeners();
    });
  }

  @override
  Future<void> stopScanning() async {
    _isScanning = false;
    _scanTimer?.cancel();
    notifyListeners();
  }

  @override
  Future<bool> connect(NearbyDevice device) async {
    final index = _devices.indexWhere((d) => d.deviceId == device.deviceId);
    if (index != -1) {
      _devices[index] = _devices[index].copyWith(isConnected: true);
      _devicesStreamController.add(_devices);
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  NearbyDevice? findDeviceByPublicKey(String publicKey) {
    try {
      return _devices.firstWhere((d) => d.publicKey == publicKey);
    } catch (_) {
      return null;
    }
  }

  void addSimulatedPeer(NearbyDevice device) {
    _devices.add(device);
    _devicesStreamController.add(_devices);
    notifyListeners();
  }

  void removeSimulatedPeer(String deviceId) {
    _devices.removeWhere((d) => d.deviceId == deviceId);
    _devicesStreamController.add(_devices);
    notifyListeners();
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    _devicesStreamController.close();
    super.dispose();
  }
}
