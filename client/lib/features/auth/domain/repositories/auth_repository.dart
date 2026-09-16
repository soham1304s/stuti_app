abstract class AuthRepository {
  Stream<String?> get authStateChanges;
  Future<String?> signInWithGoogle();
  Future<String?> signInWithApple();
  Future<void> signOut();
}
