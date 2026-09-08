import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String count;
  final Color color;
  final IconData icon;
  const StatCard({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              count,
              style: AppTypography.heading1.copyWith(
                color: color,
                fontSize: 22,
              ),
            ),
            Text(label, style: AppTypography.labelSmall.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class ResponseRateCard extends StatelessWidget {
  final double rate;
  final int responded;
  final int total;
  const ResponseRateCard({
    super.key,
    required this.rate,
    required this.responded,
    required this.total,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Response rate', style: AppTypography.labelLarge),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: rate,
                  backgroundColor: AppColors.border,
                  color: AppColors.twilightPlum,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(rate * 100).toInt()}%',
            style: AppTypography.heading2.copyWith(
              color: AppColors.twilightPlum,
            ),
          ),
        ],
      ),
    );
  }
}

class AutomationCard extends StatelessWidget {
  const AutomationCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_outlined,
                size: 16,
                color: AppColors.twilightPlum,
              ),
              const SizedBox(width: 6),
              Text('Automation', style: AppTypography.labelMedium),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '• Single reminder 24h before\n• Editing re-notifies guests\n• Optional custom question',
            style: AppTypography.bodySmall.copyWith(color: AppColors.hint),
          ),
        ],
      ),
    );
  }
}

class RsvpRow extends StatelessWidget {
  final String name;
  final String email;
  final String status;
  final String? answer;
  const RsvpRow({
    super.key,
    required this.name,
    required this.email,
    required this.status,
    this.answer,
  });
  @override
  Widget build(BuildContext context) {
    Color c;
    IconData icon;
    String label;
    switch (status) {
      case 'yes':
        c = AppColors.success;
        icon = Icons.check_circle;
        label = 'Yes';
        break;
      case 'no':
        c = AppColors.error;
        icon = Icons.cancel;
        label = 'No';
        break;
      default:
        c = AppColors.warning;
        icon = Icons.help;
        label = 'Maybe';
        break;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: c, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.labelLarge.copyWith(fontSize: 13),
                ),
                Text(
                  email,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.hint,
                    fontSize: 11,
                  ),
                ),
                if (answer != null)
                  Text(
                    'Answer: $answer',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.hint,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: c.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: c,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
