import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/template_model.dart';
import '../../../services/billing_service.dart';

class TemplateCard extends StatelessWidget {
  final TemplateModel template;
  const TemplateCard({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (template.isPremium) {
          final isPrem = await BillingService.isPremium;
          if (!isPrem && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Premium template. Upgrade to unlock all 200.'),
              ),
            );
            return;
          }
        }
        if (context.mounted) context.push('/editor/${template.id}');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: template.isPremium
                      ? AppColors.marigoldGold.withValues(alpha: 0.12)
                      : AppColors.twilightPlum.withValues(alpha: 0.06),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    if (template.thumbnailUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: template.thumbnailUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (_, __) => const Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: AppColors.hint,
                            ),
                          ),
                          errorWidget: (_, __, ___) => const Center(
                            child: Text('🎨', style: TextStyle(fontSize: 36)),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Text(
                          template.occasionId.contains('diwali') ? '🪔' : '🎨',
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                    if (template.isPremium)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.marigoldGold,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'PREMIUM',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.charcoalInk,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'WYSIWYG',
                          style: AppTypography.captionMono.copyWith(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: AppTypography.labelLarge.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    template.isPremium
                        ? 'Premium • No watermark'
                        : 'Free • Small watermark',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.hint,
                      fontSize: 10,
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
