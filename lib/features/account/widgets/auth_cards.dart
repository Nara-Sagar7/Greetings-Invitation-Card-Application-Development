import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class AccountUserCard extends ConsumerWidget {
  final String? name;
  final String? email;
  const AccountUserCard({super.key, this.name, this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.twilightPlum,
            child: Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'User',
                  style: AppTypography.heading3.copyWith(fontSize: 16),
                ),
                Text(
                  email ?? '',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.hint,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    'Signed In',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.success,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Signed out')));
              }
            },
            icon: const Icon(Icons.logout, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}

class AccountLoginCard extends ConsumerStatefulWidget {
  const AccountLoginCard({super.key});

  @override
  ConsumerState<AccountLoginCard> createState() => _AccountLoginCardState();
}

class _AccountLoginCardState extends ConsumerState<AccountLoginCard> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome to Greetings',
            style: AppTypography.heading3.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Sign in to sync drafts & send cards',
            style: AppTypography.bodySmall.copyWith(color: AppColors.hint),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.email_outlined, size: 18),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passCtrl,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outline, size: 18),
            ),
            obscureText: true,
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ],
          const SizedBox(height: 12),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else ...[
            FilledButton(
              onPressed: () => _signIn(auth),
              child: const Text('Sign In with Email'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _signUp(auth),
              child: const Text('Create Account'),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('or'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _google(auth),
              icon: const Icon(Icons.login, size: 18),
              label: const Text('Continue with Google'),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'Offline drafts work without sign-in. Sign in to sync.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.hint,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _signIn(dynamic auth) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await auth.signInWithEmail(_emailCtrl.text.trim(), _passCtrl.text.trim());
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Signed in')));
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signUp(dynamic auth) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await auth.signUpWithEmail(_emailCtrl.text.trim(), _passCtrl.text.trim());
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Account created')));
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _google(dynamic auth) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cred = await auth.signInWithGoogle();
      if (cred == null && mounted) setState(() => _error = 'Cancelled');
      if (cred != null && mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Signed in with Google')));
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
