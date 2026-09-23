import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  @override
  Stream<String?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((event) {
      return event.session?.user.id;
    });
  }

  @override
  Future<String?> signInWithGoogle() async {
    const webClientId = 'my-web-client-id'; // ponytail: placeholder, needs real config
    const iosClientId = 'my-ios-client-id'; // ponytail: placeholder, needs real config

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw 'No Access Token or ID Token found.';
    }

    final res = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    return res.user?.id;
  }

  @override
  Future<String?> signInWithApple() async {
    final rawNonce = _supabase.auth.generateRawNonce();
    final hashedNonce = _supabase.auth.sha256ofString(rawNonce);

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    final res = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
    
    return res.user?.id;
  }
  
  @override
  Future<String?> signInWithEmail(String email, String password) async {
    final res = await _supabase.auth.signInWithPassword(email: email, password: password);
    return res.user?.id;
  }
  
  @override
  Future<String?> signUpWithEmail(String email, String password, String name) async {
    final res = await _supabase.auth.signUp(
      email: email, 
      password: password,
      data: {'display_name': name},
    );
    return res.user?.id;
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
