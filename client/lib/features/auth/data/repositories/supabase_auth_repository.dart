import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:meshtalk_client/features/auth/domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  @override
  Stream<String?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((event) {
      return event.session?.user.id;
    });
  }

  @override
  String? get currentUser => _supabase.auth.currentUser?.id;

  Future<void> _ensureProfileExists(User? user) async {
    if (user == null) return;
    try {
      final response = await _supabase
          .from('profiles')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        // Create profile
        await _supabase.from('profiles').insert({
          'id': user.id,
          'email': user.email ?? '',
          'display_name': user.userMetadata?['full_name'] ?? user.userMetadata?['name'] ?? 'User',
          'avatar_url': user.userMetadata?['avatar_url'],
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      // Ignore errors for now, or log them
    }
  }

  @override
  Future<String?> signInWithGoogle() async {
    // Note: These must be configured in Google Cloud Console and Supabase Dashboard
    const webClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
    const iosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com';

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
    
    await _ensureProfileExists(res.user);
    return res.user?.id;
  }

  @override
  Future<String?> signInWithApple() async {
    final rawNonce = _supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

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
    
    await _ensureProfileExists(res.user);
    return res.user?.id;
  }
  
  @override
  Future<String?> signInWithEmail(String email, String password) async {
    final res = await _supabase.auth.signInWithPassword(email: email, password: password);
    await _ensureProfileExists(res.user);
    return res.user?.id;
  }
  
  @override
  Future<String?> signUpWithEmail(String email, String password, String name) async {
    final res = await _supabase.auth.signUp(
      email: email, 
      password: password,
      data: {'full_name': name},
    );
    await _ensureProfileExists(res.user);
    return res.user?.id;
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
