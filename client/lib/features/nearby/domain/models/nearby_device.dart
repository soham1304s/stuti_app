import 'package:meshtalk_client/core/constants/app_constants.dart';

class NearbyDevice {
  final String deviceId;
  final String name;
  final String publicKey;
  final String fingerprint;
  final List<String> capabilities;
  final int rssi; // Received Signal Strength Indication (e.g. -50 dBm = very close)
  final String approximateDistance;
  final bool isConnected;
  final DateTime lastSeen;

  NearbyDevice({
    required this.deviceId,
    required this.name,
    required this.publicKey,
    required this.fingerprint,
    this.capabilities = const ['text', 'image', 'file'],
    required this.rssi,
    required this.approximateDistance,
    this.isConnected = false,
    required this.lastSeen,
  });

  NearbyDevice copyWith({
    String? deviceId,
    String? name,
    String? publicKey,
    String? fingerprint,
    List<String>? capabilities,
    int? rssi,
    String? approximateDistance,
    bool? isConnected,
    DateTime? lastSeen,
  }) {
    return NearbyDevice(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      publicKey: publicKey ?? this.publicKey,
      fingerprint: fingerprint ?? this.fingerprint,
      capabilities: capabilities ?? this.capabilities,
      rssi: rssi ?? this.rssi,
      approximateDistance: approximateDistance ?? this.approximateDistance,
      isConnected: isConnected ?? this.isConnected,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  /// Calculates human-friendly signal strength bars (1 to 4)
  int get signalBars {
    if (rssi >= -60) return 4;
    if (rssi >= -75) return 3;
    if (rssi >= -88) return 2;
    return 1;
  }

  Map<String, dynamic> toJson() => {
        'protocol': AppConstants.protocolName,
        'version': AppConstants.protocolVersion,
        'deviceId': deviceId,
        'name': name,
        'publicKey': publicKey,
        'fingerprint': fingerprint,
        'capabilities': capabilities,
        'rssi': rssi,
        'approximateDistance': approximateDistance,
        'isConnected': isConnected,
        'lastSeen': lastSeen.toIso8601String(),
      };

  factory NearbyDevice.fromJson(Map<String, dynamic> json) {
    return NearbyDevice(
      deviceId: json['deviceId'] as String,
      name: json['name'] as String? ?? 'Nearby Mesh Node',
      publicKey: json['publicKey'] as String,
      fingerprint: json['fingerprint'] as String? ?? 'UNKNOWN',
      capabilities: List<String>.from(json['capabilities'] ?? ['text']),
      rssi: json['rssi'] as int? ?? -70,
      approximateDistance: json['approximateDistance'] as String? ?? 'Nearby',
      isConnected: json['isConnected'] as bool? ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : DateTime.now(),
    );
  }
}
