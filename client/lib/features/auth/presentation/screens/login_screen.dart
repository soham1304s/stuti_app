import 'package:flutter/material.dart';
import 'package:meshtalk_client/core/theme/app_theme.dart';
import 'package:meshtalk_client/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Icon
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryEmerald, AppTheme.meshCyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryEmerald.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.hub_rounded,
                    size: 46,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Welcome to MeshTalk',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sign in to link your cryptographic identity across devices, or remain purely offline-first.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 48),

              // Buttons
              if (authProvider.isLoading)
                const Center(child: CircularProgressIndicator(color: AppTheme.primaryEmerald))
              else ...[
                ElevatedButton.icon(
                  onPressed: () => authProvider.signInWithGoogle(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppTheme.darkCard : Colors.white,
                    foregroundColor: textColor,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.redAccent),
                  label: const Text('Sign in with Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => authProvider.signInWithApple(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppTheme.darkCard : Colors.black,
                    foregroundColor: isDark ? textColor : Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.apple, size: 28),
                  label: const Text('Sign in with Apple', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
