import 'package:flutter/foundation.dart';
import 'package:meshtalk_client/features/auth/domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  bool _isLoading = false;
  String? _userId;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _userId != null;
  String? get userId => _userId;

  AuthProvider(this._authRepository) {
    _authRepository.authStateChanges.listen((uid) {
      _userId = uid;
      notifyListeners();
    });
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      await _authRepository.signInWithGoogle();
    } catch (e) {
      debugPrint("Error signing in with Google: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithApple() async {
    _setLoading(true);
    try {
      await _authRepository.signInWithApple();
    } catch (e) {
      debugPrint("Error signing in with Apple: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    await _authRepository.signOut();
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
