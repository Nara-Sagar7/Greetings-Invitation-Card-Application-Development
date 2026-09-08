import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../services/tracking_service.dart';

class GuestRsvpCard extends StatelessWidget {
  final String eventId;
  final String guestEmail;
  const GuestRsvpCard({
    super.key,
    required this.eventId,
    required this.guestEmail,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.marigoldGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.marigoldGold),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi ${guestEmail.split('@').first}, please RSVP',
            style: AppTypography.labelLarge,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => TrackingService.trackRsvp(
                    eventId: eventId,
                    email: guestEmail,
                    rsvp: 'yes',
                  ),
                  child: const Text('Yes'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => TrackingService.trackRsvp(
                    eventId: eventId,
                    email: guestEmail,
                    rsvp: 'maybe',
                  ),
                  child: const Text('Maybe'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => TrackingService.trackRsvp(
                    eventId: eventId,
                    email: guestEmail,
                    rsvp: 'no',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                  child: const Text('No'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Guest link • No app needed',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.hint,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
