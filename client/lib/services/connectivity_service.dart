import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:meshtalk_client/core/constants/app_constants.dart';

abstract class IConnectivityService {
  ConnectivityMode get currentMode;
  Stream<ConnectivityMode> get onModeChanged;
  bool get isInternetAvailable;
  bool get isBluetoothAvailable;
  void setSimulatedMode(ConnectivityMode mode);
}

/// Central Connectivity Manager implementing section 401 & 879 of the spec
class ConnectivityService extends ChangeNotifier implements IConnectivityService {
  ConnectivityMode _currentMode = ConnectivityMode.online;
  bool _isInternetAvailable = true;
  bool _isBluetoothAvailable = true;
  int _nearbyPeerCount = 3;

  final _modeController = StreamController<ConnectivityMode>.broadcast();

  @override
  ConnectivityMode get currentMode => _currentMode;

  @override
  Stream<ConnectivityMode> get onModeChanged => _modeController.stream;

  @override
  bool get isInternetAvailable => _isInternetAvailable;

  @override
  bool get isBluetoothAvailable => _isBluetoothAvailable;

  int get nearbyPeerCount => _nearbyPeerCount;

  ConnectivityService() {
    _updateState();
  }

  void updateNearbyPeerCount(int count) {
    _nearbyPeerCount = count;
    _updateState();
    notifyListeners();
  }

  void toggleInternet(bool enabled) {
    _isInternetAvailable = enabled;
    _updateState();
    notifyListeners();
  }

  void toggleBluetooth(bool enabled) {
    _isBluetoothAvailable = enabled;
    _updateState();
    notifyListeners();
  }

  @override
  void setSimulatedMode(ConnectivityMode mode) {
    _currentMode = mode;
    switch (mode) {
      case ConnectivityMode.online:
        _isInternetAvailable = true;
        _isBluetoothAvailable = true;
        break;
      case ConnectivityMode.nearbyMesh:
        _isInternetAvailable = false;
        _isBluetoothAvailable = true;
        if (_nearbyPeerCount == 0) _nearbyPeerCount = 2;
        break;
      case ConnectivityMode.connecting:
        _isInternetAvailable = false;
        _isBluetoothAvailable = true;
        break;
      case ConnectivityMode.offline:
        _isInternetAvailable = false;
        _isBluetoothAvailable = false;
        _nearbyPeerCount = 0;
        break;
    }
    _modeController.add(_currentMode);
    notifyListeners();
  }

  void _updateState() {
    if (_isInternetAvailable) {
      _currentMode = ConnectivityMode.online;
    } else if (_isBluetoothAvailable && _nearbyPeerCount > 0) {
      _currentMode = ConnectivityMode.nearbyMesh;
    } else if (_isBluetoothAvailable) {
      _currentMode = ConnectivityMode.connecting;
    } else {
      _currentMode = ConnectivityMode.offline;
    }
    _modeController.add(_currentMode);
  }

  @override
  void dispose() {
    _modeController.close();
    super.dispose();
  }
}
