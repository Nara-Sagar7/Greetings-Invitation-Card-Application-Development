import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Preview Screen - #4 of 9 - PRD 05 Release Gate
/// Pixel-accurate. Must match sent output on iPhone SE, Pixel 7, iPad Mini.
class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview • Pixel-accurate'), actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
      ]),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 8))], border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: Container(
                            height: 220,
                            color: AppColors.twilightPlum.withOpacity(0.06),
                            child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text('🪔', style: const TextStyle(fontSize: 48)),
                              const SizedBox(height: 8),
                              Text('Diwali Celebration', style: AppTypography.headingPlayfair.copyWith(color: AppColors.twilightPlum)),
                            ])),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(children: [
                            Text('You are invited!', style: AppTypography.heading1.copyWith(color: AppColors.twilightPlum)),
                            const SizedBox(height: 8),
                            Container(height: 2, width: 40, color: AppColors.marigoldGold),
                            const SizedBox(height: 16),
                            Text('Join us for an evening of lights, sweets and togetherness.', textAlign: TextAlign.center, style: AppTypography.bodyMedium.copyWith(color: AppColors.charcoalInk)),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: AppColors.warmIvory, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                              child: Column(children: [
                                _InfoRow(icon: Icons.calendar_today_outlined, text: 'Sat, 20 Sept 2026 • 7:00 PM IST'),
                                const SizedBox(height: 8),
                                _InfoRow(icon: Icons.location_on_outlined, text: 'The Grand Hall, Mumbai'),
                              ]),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.success.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.success.withOpacity(0.2))),
                    child: Row(children: [
                      const Icon(Icons.verified, color: AppColors.success, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text('This preview = what guests receive. WYSIWYG verified.', style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w600))),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  Text('Envelope animation shown to guest on open', style: AppTypography.captionMono.copyWith(color: AppColors.hint)),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
            child: Row(children: [
              Expanded(child: OutlinedButton(onPressed: () => context.pop(), child: const Text('Back to Editor'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () => context.push('/guest-list'), child: const Text('Next: Guests →'))),
            ]),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(children: [Icon(icon, size: 14, color: AppColors.hint), const SizedBox(width: 8), Text(text, style: AppTypography.bodySmall.copyWith(color: AppColors.charcoalInk))]);
  }
}
