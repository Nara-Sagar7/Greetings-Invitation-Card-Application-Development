import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import 'widgets/auth_cards.dart';
import 'widgets/account_widgets.dart';

/// Account / Settings - P0-4 auth android/ios only
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            authState.when(
              data: (user) => user == null
                  ? const AccountLoginCard()
                  : AccountUserCard(name: user.displayName, email: user.email),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const AccountLoginCard(),
            ),
            const SizedBox(height: 20),
            const PremiumCard(),
            const SizedBox(height: 20),
            Text(
              'Settings',
              style: AppTypography.heading3.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 8),
            SettingsTile(
              icon: Icons.calendar_today_outlined,
              title: 'Google Calendar Sync',
              subtitle: 'Host OAuth • auto create/update/cancel • Guest .ics',
              trailing: Switch(
                value: false,
                onChanged: (_) {},
                activeColor: AppColors.twilightPlum,
              ),
            ),
            SettingsTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English • Hindi (V1) • More in V2',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'Accent stays Marigold #E8A33D',
              trailing: Switch(
                value: false,
                onChanged: (_) {},
                activeColor: AppColors.twilightPlum,
              ),
            ),
            SettingsTile(
              icon: Icons.support_agent_outlined,
              title: 'Help & Support',
              subtitle: 'AI chatbot for FAQs',
              onTap: () => _showChatbot(context),
            ),
            Consumer(
              builder: (context, ref2, _) {
                final logged = ref.watch(isLoggedInProvider);
                if (!logged) return const SizedBox.shrink();
                return SettingsTile(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  subtitle: 'Email/password + Google',
                  onTap: () async {
                    await ref.read(authServiceProvider).signOut();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Signed out')),
                      );
                    }
                  },
                  isDestructive: true,
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'V1 • One codebase • iOS & Android • Firebase BaaS\nIn Jesus name we pray. Amen. 🙏',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.hint,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatbot(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (context, ctl) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.twilightPlum.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.smart_toy_outlined,
                      color: AppColors.twilightPlum,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('FAQ Assistant', style: AppTypography.heading3),
                ],
              ),
              const SizedBox(height: 12),
              const FaqTile(question: 'Why does preview not match sent card?'),
              const FaqTile(question: 'How to import contacts?'),
              const FaqTile(question: 'How does 3-way RSVP work?'),
              const Spacer(),
              Builder(
                builder: (context) {
                  final ctrl = TextEditingController();
                  return Column(
                    children: [
                      TextField(
                        controller: ctrl,
                        decoration: InputDecoration(
                          hintText: 'Ask a question...',
                          suffixIcon: IconButton(
                            onPressed: () async {
                              final q = ctrl.text.trim();
                              if (q.isEmpty) return;
                              final uri = Uri(
                                scheme: 'mailto',
                                path: AppConstants.supportEmail,
                                query: 'subject=Support: $q&body=Question: $q',
                              );
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Email ${AppConstants.supportEmail}',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                              color: AppColors.twilightPlum,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'FAQ only - no content creation. Escalation to ${AppConstants.supportEmail}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.hint,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
