import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String guests;
  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.guests,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.labelLarge),
          const SizedBox(height: 4),
          Text(
            date,
            style: AppTypography.bodySmall.copyWith(color: AppColors.hint),
          ),
          const SizedBox(height: 4),
          Text(
            guests,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.twilightPlum,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push('/rsvp/event_123'),
              child: const Text('View RSVP Dashboard'),
            ),
          ),
        ],
      ),
    );
  }
}
