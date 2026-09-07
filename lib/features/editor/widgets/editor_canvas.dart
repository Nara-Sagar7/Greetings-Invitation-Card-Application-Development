import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/editor_state.dart';

/// WYSIWYG canvas — same renderer as preview/export.
/// Pixel ratio 2.0 per PRD 05. Phase C offline.
class EditorCanvas extends StatelessWidget {
  final EditorState state;
  const EditorCanvas({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.warmIvory,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Text(
                            state.title.isEmpty
                                ? 'You are invited!'
                                : state.title,
                            style: AppTypography.headingPlayfair.copyWith(
                              fontSize: state.fontSize,
                              color: AppColors.twilightPlum,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 1,
                            width: 40,
                            color: AppColors.marigoldGold,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Sat, 20 Sept • 7:00 PM\nThe Grand Hall, Mumbai',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.charcoalInk,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.twilightPlum,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'INFO BLOCK',
                              style: AppTypography.labelSmall.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '2× pixel ratio • Fonts preloaded • Same renderer as export',
                      style: AppTypography.captionMono.copyWith(
                        color: AppColors.hint,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Snapping guides ON',
                  style: AppTypography.captionMono.copyWith(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
