import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/occasions.dart';
import '../../core/providers/data_providers.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/template_card.dart';

/// Gallery #2 of 9 — Phase C offline-first.
/// Real templates via DataRepository (Hive + assets).
/// No Firebase needed.
class GalleryScreen extends ConsumerStatefulWidget {
  final String? occasionId;
  const GalleryScreen({super.key, this.occasionId});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.occasionId;
  }

  @override
  Widget build(BuildContext context) {
    final occasions = Occasions.all;
    final templatesAsync = ref.watch(templatesProvider(selected));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selected != null
              ? Occasions.byId(selected!)?.name ?? 'Gallery'
              : 'Gallery',
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: occasions.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                if (i == 0) {
                  final isAll = selected == null;
                  return ChoiceChip(
                    label: const Text('All'),
                    selected: isAll,
                    onSelected: (_) => setState(() => selected = null),
                    selectedColor: AppColors.twilightPlum,
                    labelStyle: TextStyle(
                      color: isAll ? Colors.white : AppColors.charcoalInk,
                    ),
                  );
                }
                final o = occasions[i - 1];
                final sel = selected == o.id;
                return ChoiceChip(
                  label: Text('${o.emoji} ${o.name}'),
                  selected: sel,
                  onSelected: (_) => setState(() => selected = o.id),
                  selectedColor: AppColors.twilightPlum,
                  labelStyle: TextStyle(
                    color: sel ? Colors.white : AppColors.charcoalInk,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: templatesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Failed: $e')),
              data: (templates) {
                if (templates.isEmpty) {
                  return Center(
                    child: Text(
                      'No templates for this occasion yet',
                      style: TextStyle(color: AppColors.hint),
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: templates.length,
                  itemBuilder: (context, i) =>
                      TemplateCard(template: templates[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
