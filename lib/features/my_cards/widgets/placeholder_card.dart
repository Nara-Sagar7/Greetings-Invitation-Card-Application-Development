import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class PlaceholderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const PlaceholderCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.twilightPlum.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              color: AppColors.twilightPlum,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLarge),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.hint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
