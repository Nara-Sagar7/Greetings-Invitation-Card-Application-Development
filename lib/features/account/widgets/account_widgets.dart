import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/billing_service.dart';
import '../../../services/purchase_service.dart';

class PremiumCard extends ConsumerStatefulWidget {
  const PremiumCard({super.key});
  @override
  ConsumerState<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends ConsumerState<PremiumCard> {
  bool _loading = false;
  Future<void> _buy(bool monthly) async {
    setState(() => _loading = true);
    final svc = PurchaseService();
    final ok = monthly ? await svc.buyMonthly() : await svc.buyAnnual();
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Premium activated ✓' : 'Purchase failed')));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: BillingService.isPremium,
      builder: (context, snap) {
        final isPrem = snap.data ?? false;
        if (isPrem) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: AppColors.plumGradient, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [const Icon(Icons.verified, color: Colors.white), const SizedBox(width: 8), Text('Premium Active • Unlimited', style: AppTypography.labelLarge.copyWith(color: Colors.white))]),
          );
        }
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: AppColors.plumGradient, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('Premium • No Tricks', style: AppTypography.heading3.copyWith(color: Colors.white, fontSize: 16)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.marigoldGold, borderRadius: BorderRadius.circular(20)), child: Text('One table. Zero hidden paywalls.', style: AppTypography.labelSmall.copyWith(color: AppColors.charcoalInk, fontSize: 9))),
            ]),
            const SizedBox(height: 12),
            const CompareRow(feature: 'Templates', free: 'Limited', premium: 'All 200'),
            const CompareRow(feature: 'Events/cards', free: '3 / 5 per month', premium: 'Unlimited'),
            const CompareRow(feature: 'Watermark', free: 'Small', premium: 'No watermark'),
            const CompareRow(feature: 'RSVP & Calendar', free: 'Included', premium: 'Included'),
            const SizedBox(height: 12),
            if (_loading)
              const Center(child: CircularProgressIndicator(color: Colors.white))
            else
              Row(children: [
                Expanded(child: FilledButton(onPressed: () => _buy(true), style: FilledButton.styleFrom(backgroundColor: AppColors.marigoldGold, foregroundColor: AppColors.charcoalInk), child: Text('Monthly ${AppConstants.premiumMonthlyPrice}'))),
                const SizedBox(width: 12),
                Expanded(child: FilledButton(onPressed: () => _buy(false), style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.twilightPlum), child: Text('Annual ${AppConstants.premiumAnnualPrice}'))),
              ]),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Single comparison table shown once.',
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      );
      },
    );
  }
}

class CompareRow extends StatelessWidget {
  final String feature;
  final String free;
  final String premium;
  const CompareRow({
    super.key,
    required this.feature,
    required this.free,
    required this.premium,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              free,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              premium,
              style: const TextStyle(
                color: AppColors.marigoldGold,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isDestructive;
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
    this.isDestructive = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.twilightPlum,
          size: 20,
        ),
        title: Text(
          title,
          style: AppTypography.labelLarge.copyWith(
            color: isDestructive ? AppColors.error : AppColors.charcoalInk,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.hint,
            fontSize: 11,
          ),
        ),
        trailing:
            trailing ??
            (onTap != null
                ? const Icon(
                    Icons.chevron_right,
                    color: AppColors.hint,
                    size: 18,
                  )
                : null),
        onTap: onTap,
      ),
    );
  }
}

class FaqTile extends StatelessWidget {
  final String question;
  const FaqTile({super.key, required this.question});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        title: Text(
          question,
          style: AppTypography.bodyMedium.copyWith(fontSize: 13),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 16,
          color: AppColors.hint,
        ),
      ),
    );
  }
}
