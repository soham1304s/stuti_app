abstract class AuthRepository {
  Stream<String?> get authStateChanges;
  Future<String?> signInWithGoogle();
  Future<String?> signInWithApple();
  Future<String?> signInWithEmail(String email, String password);
  Future<String?> signUpWithEmail(String email, String password, String name);
  Future<void> signOut();
}
