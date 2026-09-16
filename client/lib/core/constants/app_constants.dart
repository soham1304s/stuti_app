/// Core constants and enums for MeshTalk
class AppConstants {
  static const String appName = 'MeshTalk';
  static const String appTagline = 'Offline-First Resilient Messaging';
  static const String protocolName = 'meshtalk';
  static const int protocolVersion = 1;
  static const int defaultTTL = 8; // Maximum hops before message is discarded
  static const int messageExpiryHours = 24;

  // Storage Keys
  static const String keyUserIdentity = 'meshtalk_user_identity';
  static const String keyConversations = 'meshtalk_conversations';
  static const String keyMessages = 'meshtalk_messages';
  static const String keyContacts = 'meshtalk_contacts';
  static const String keySettings = 'meshtalk_settings';
  static const String keySeenMessageIds = 'meshtalk_seen_msg_ids';
}

/// Transports available for message propagation
enum MessageTransport {
  internet,
  bluetooth,
  meshRelay,
}

extension MessageTransportExtension on MessageTransport {
  String get displayName {
    switch (this) {
      case MessageTransport.internet:
        return 'Internet';
      case MessageTransport.bluetooth:
        return 'Bluetooth Low Energy';
      case MessageTransport.meshRelay:
        return 'Multi-Hop Mesh';
    }
  }

  String get shortTag {
    switch (this) {
      case MessageTransport.internet:
        return 'Cloud';
      case MessageTransport.bluetooth:
        return 'BLE';
      case MessageTransport.meshRelay:
        return 'Mesh';
    }
  }
}

/// Lifecycle delivery status for a message
enum MessageStatus {
  pending,
  sending,
  sent,
  delivered,
  read,
  failed,
  queuedOffline,
  forwarded,
}

extension MessageStatusExtension on MessageStatus {
  String get label {
    switch (this) {
      case MessageStatus.pending:
        return 'Pending';
      case MessageStatus.sending:
        return 'Sending...';
      case MessageStatus.sent:
        return 'Sent';
      case MessageStatus.delivered:
        return 'Delivered';
      case MessageStatus.read:
        return 'Read';
      case MessageStatus.failed:
        return 'Failed';
      case MessageStatus.queuedOffline:
        return 'Queued Offline';
      case MessageStatus.forwarded:
        return 'Forwarded';
    }
  }
}

/// Overall connectivity state of the node
enum ConnectivityMode {
  online,
  nearbyMesh,
  connecting,
  offline,
}

extension ConnectivityModeExtension on ConnectivityMode {
  String get displayName {
    switch (this) {
      case ConnectivityMode.online:
        return 'Online';
      case ConnectivityMode.nearbyMesh:
        return 'Nearby Mesh';
      case ConnectivityMode.connecting:
        return 'Connecting...';
      case ConnectivityMode.offline:
        return 'Offline';
    }
  }
}
