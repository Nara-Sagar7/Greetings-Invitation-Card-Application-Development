import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/event_model.dart';

class EmailDeliveryCard extends StatelessWidget {
  const EmailDeliveryCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.email_outlined,
                color: AppColors.twilightPlum,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text('Email delivery', style: AppTypography.labelLarge),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'SendGrid/SES',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.success,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Each guest gets personalized card + RSVP link. Copyable.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.hint),
          ),
          const SizedBox(height: 8),
          Text(
            'SPF/DKIM/DMARC • Mail-Tester ≥ ${AppConstants.mailTesterGate}/10',
            style: AppTypography.captionMono.copyWith(
              color: AppColors.hint,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class GuestLinkTile extends StatelessWidget {
  final GuestModel guest;
  final String link;
  const GuestLinkTile({super.key, required this.guest, required this.link});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(guest.name, style: AppTypography.labelMedium),
                Text(
                  link,
                  style: AppTypography.captionMono.copyWith(
                    color: AppColors.twilightPlum,
                    fontSize: 9,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: link));
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Link copied')));
            },
            icon: const Icon(
              Icons.copy,
              size: 18,
              color: AppColors.twilightPlum,
            ),
          ),
        ],
      ),
    );
  }
}

class OfflineInfo extends StatelessWidget {
  const OfflineInfo({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.info, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppConstants.offlineLabel,
              style: AppTypography.bodySmall.copyWith(color: AppColors.info),
            ),
          ),
        ],
      ),
    );
  }
}
