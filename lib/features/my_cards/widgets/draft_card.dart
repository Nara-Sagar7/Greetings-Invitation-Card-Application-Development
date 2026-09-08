import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/event_model.dart';

class DraftCard extends StatelessWidget {
  final EventModel draft;
  const DraftCard({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              color: AppColors.warmIvory,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Text('🎨', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(draft.title, style: AppTypography.labelLarge),
                const SizedBox(height: 2),
                Text(
                  draft.templateId,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.hint,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 12,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        draft.status == 'draft'
                            ? 'Saved • Ready to send — offline ready'
                            : draft.status,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.warning,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                context.push('/editor/${draft.templateId}?draftId=${draft.id}'),
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }
}
