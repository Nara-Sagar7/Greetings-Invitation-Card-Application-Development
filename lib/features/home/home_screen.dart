import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/occasions.dart';
import '../../core/constants/app_constants.dart';

/// Home Screen - #1 of 9 - PRD 07
/// Occasion-first browsing (not design style). Matches Invitaciones Digitales pattern.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Greetings'),
        actions: [
          IconButton(
            onPressed: () => context.push('/my-cards'),
            icon: const Icon(Icons.card_giftcard),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.plumGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What you see\nis what they get.',
                    style: AppTypography.headingPlayfair.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Premium invitations & greetings. Reliable, no hidden paywalls.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go('/gallery'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.marigoldGold,
                      foregroundColor: AppColors.charcoalInk,
                    ),
                    child: const Text('Browse Templates'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Evergreen',
              style: AppTypography.heading2.copyWith(
                color: AppColors.charcoalInk,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '9 occasions • 10-15 templates each',
              style: AppTypography.bodySmall.copyWith(color: AppColors.hint),
            ),
            const SizedBox(height: 12),
            _OccasionGrid(occasions: Occasions.evergreen),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'Indian Festivals',
                  style: AppTypography.heading2.copyWith(
                    color: AppColors.charcoalInk,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.marigoldGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'CULTURAL GATE',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.twilightPlum,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '5 pan-India festivals • domain-expert reviewed',
              style: AppTypography.bodySmall.copyWith(color: AppColors.hint),
            ),
            const SizedBox(height: 12),
            _OccasionGrid(occasions: Occasions.indianFestivals),
            const SizedBox(height: 24),
            Text(
              'Broad Festivals',
              style: AppTypography.heading2.copyWith(
                color: AppColors.charcoalInk,
              ),
            ),
            const SizedBox(height: 12),
            _OccasionGrid(occasions: Occasions.broadFestivals),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    color: AppColors.success,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppConstants.offlineLabel,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OccasionGrid extends StatelessWidget {
  final List<Occasion> occasions;
  const _OccasionGrid({required this.occasions});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemCount: occasions.length,
      itemBuilder: (context, i) {
        final o = occasions[i];
        return InkWell(
          onTap: () => context.push('/gallery?occasion=${o.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: o.id.contains('diwali') || o.id.contains('holi')
                  ? o.accentColor.withOpacity(0.12)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(o.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 6),
                Text(
                  o.name,
                  textAlign: TextAlign.center,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.charcoalInk,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (o.needsCulturalReview) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
