import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../services/billing_service.dart';
import '../providers/editor_state.dart';

/// Shared WYSIWYG renderer - single source for editor/preview/export
/// Pixel ratio 2.0 per AppConstants.canvasPixelRatio
/// Preview == Export pixel-identical (guides outside boundary)
class CanvasRenderer extends StatelessWidget {
  final EditorState state;
  final bool showGuides;
  final GlobalKey? repaintKey;
  final void Function(Offset delta)? onTitleDrag;

  const CanvasRenderer({
    super.key,
    required this.state,
    this.showGuides = true,
    this.repaintKey,
    this.onTitleDrag,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        state.canvasJson['dateLabel'] as String? ?? 'Sat, 20 Sept • 7:00 PM';
    final location =
        state.canvasJson['location'] as String? ?? 'The Grand Hall, Mumbai';
    final accent = state.canvasJson['accentColor'] as int?;
    final bgColor = accent != null
        ? Color(accent).withValues(alpha: 0.06)
        : AppColors.warmIvory;
    return Container(
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
            // Export boundary - only card
            RepaintBoundary(
              key: repaintKey,
              child: AspectRatio(
                aspectRatio: 0.72,
                child: Stack(
                  children: [
                    Positioned.fill(child: Container(color: bgColor)),
                    if (state.imagePath != null)
                      Positioned.fill(
                        child: Image.file(
                          File(state.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onPanUpdate: onTitleDrag == null
                                    ? null
                                    : (d) => onTitleDrag!(d.delta),
                                child: Transform.translate(
                                  offset: state.titleOffset,
                                  child: Text(
                                    state.title.isEmpty
                                        ? 'You are invited!'
                                        : state.title,
                                    style: AppTypography.headingPlayfair
                                        .copyWith(
                                          fontSize: state.fontSize,
                                          color: AppColors.twilightPlum,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                height: 1,
                                width: 40,
                                color: AppColors.marigoldGold,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '$dateLabel\n$location',
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.charcoalInk,
                                ),
                              ),
                              if (state.sticker != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  state.sticker!,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ],
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
                      ),
                    ),
                    FutureBuilder<bool>(
                      future: BillingService.isPremium,
                      builder: (context, snap) {
                        final isPrem = snap.data ?? false;
                        if (isPrem) return const SizedBox.shrink();
                        return Positioned(
                          bottom: 6,
                          right: 6,
                          child: Opacity(
                            opacity: 0.35,
                            child: Text(
                              'Greetings • Free',
                              style: AppTypography.captionMono.copyWith(
                                fontSize: 7,
                                color: AppColors.hint,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Guides outside export - not captured
            if (showGuides)
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${AppConstants.canvasPixelRatio}× • Same as export',
                  style: AppTypography.captionMono.copyWith(
                    color: AppColors.hint,
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
