import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class EditorControls extends StatelessWidget {
  final TextEditingController titleCtrl;
  final double fontSize;
  final bool canUndo;
  final bool canRedo;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<double> onFontSizeChanged;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onSaveDraft;
  final VoidCallback onPreview;
  final VoidCallback onPickImage;
  final VoidCallback onPickSticker;
  final VoidCallback onPickColor;
  final VoidCallback onClearImage;

  const EditorControls({
    super.key,
    required this.titleCtrl,
    required this.fontSize,
    required this.canUndo,
    required this.canRedo,
    required this.onTitleChanged,
    required this.onFontSizeChanged,
    required this.onUndo,
    required this.onRedo,
    required this.onSaveDraft,
    required this.onPreview,
    required this.onPickImage,
    required this.onPickSticker,
    required this.onPickColor,
    required this.onClearImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleCtrl,
            onChanged: onTitleChanged,
            decoration: const InputDecoration(
              labelText: 'Title (Info Block)',
              hintText: 'Event title',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Font size', style: AppTypography.labelMedium),
              Expanded(
                child: Slider(
                  value: fontSize,
                  min: 14,
                  max: 32,
                  activeColor: AppColors.twilightPlum,
                  onChanged: onFontSizeChanged,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.twilightPlum.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${fontSize.toInt()} pt',
                  style: AppTypography.labelSmall,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ToolChip(icon: Icons.text_fields, label: 'Text', onTap: () {}),
                _ToolChip(
                  icon: Icons.photo,
                  label: 'Photo',
                  onTap: onPickImage,
                ),
                _ToolChip(icon: Icons.crop, label: 'Crop', onTap: onClearImage),
                _ToolChip(
                  icon: Icons.emoji_emotions_outlined,
                  label: 'Sticker',
                  onTap: onPickSticker,
                ),
                _ToolChip(
                  icon: Icons.color_lens_outlined,
                  label: 'Color',
                  onTap: onPickColor,
                ),
                _ToolChip(
                  icon: Icons.undo,
                  label: 'Undo',
                  enabled: canUndo,
                  onTap: onUndo,
                ),
                _ToolChip(
                  icon: Icons.redo,
                  label: 'Redo',
                  enabled: canRedo,
                  onTap: onRedo,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onSaveDraft,
                  child: const Text('Save Draft'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onPreview,
                  child: const Text('Preview →'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Auto-saved • Unlimited undo/redo',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.hint,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  const _ToolChip({
    required this.icon,
    required this.label,
    this.enabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: AppTypography.labelSmall.copyWith(fontSize: 11),
        ),
        avatar: Icon(
          icon,
          size: 14,
          color: enabled ? AppColors.twilightPlum : AppColors.hint,
        ),
        selected: false,
        onSelected: enabled ? (_) => onTap() : null,
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
      ),
    );
  }
}
