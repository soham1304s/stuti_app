import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meshtalk_client/services/connectivity_service.dart';
import 'package:meshtalk_client/services/encryption_service.dart';
import 'package:meshtalk_client/services/nearby_device_service.dart';
import 'package:meshtalk_client/services/storage_service.dart';
import 'package:meshtalk_client/services/story_server_service.dart';
import 'package:meshtalk_client/services/sync_service.dart';
import 'package:meshtalk_client/services/transport_manager.dart';

final storageServiceProvider = ChangeNotifierProvider<StorageService>((ref) {
  final service = StorageService();
  // ponytail: async initialization should be awaited, but we keep it synchronous for UI simplicity here
  service.initialize();
  return service;
});

final connectivityServiceProvider = ChangeNotifierProvider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final nearbyDeviceServiceProvider = ChangeNotifierProvider<NearbyDeviceService>((ref) {
  return NearbyDeviceService();
});

final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  return EncryptionService();
});

final syncServiceProvider = ChangeNotifierProvider<SyncService>((ref) {
  return SyncService(
    storageService: ref.watch(storageServiceProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

final transportManagerProvider = ChangeNotifierProvider<TransportManager>((ref) {
  return TransportManager(
    connectivityService: ref.watch(connectivityServiceProvider),
    nearbyDeviceService: ref.watch(nearbyDeviceServiceProvider),
    encryptionService: ref.watch(encryptionServiceProvider),
    storageService: ref.watch(storageServiceProvider),
    syncService: ref.watch(syncServiceProvider),
  );
});

final storyServerServiceProvider = ChangeNotifierProvider<StoryServerService>((ref) {
  return StoryServerService();
});
