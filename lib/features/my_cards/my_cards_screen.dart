import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/data_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'widgets/draft_card.dart';
import 'widgets/event_card.dart';
import 'widgets/placeholder_card.dart';

/// My Cards #8 of 9 — Phase C offline.
/// Drafts tab now real (Hive). Sent/Events remain
/// placeholder until Firebase Phase B.
class MyCardsScreen extends ConsumerStatefulWidget {
  const MyCardsScreen({super.key});

  @override
  ConsumerState<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends ConsumerState<MyCardsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draftsAsync = ref.watch(draftsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cards & Events'),
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.twilightPlum,
          unselectedLabelColor: AppColors.hint,
          indicatorColor: AppColors.twilightPlum,
          tabs: const [
            Tab(text: 'Drafts'),
            Tab(text: 'Sent'),
            Tab(text: 'Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          // Drafts — REAL (Hive)
          draftsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Failed: $e')),
            data: (drafts) {
              if (drafts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.card_giftcard_outlined,
                          size: 48,
                          color: AppColors.hint,
                        ),
                        const SizedBox(height: 12),
                        Text('No drafts yet', style: AppTypography.labelLarge),
                        const SizedBox(height: 4),
                        Text(
                          'Create one from Gallery — saved offline',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.hint,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.go('/gallery'),
                          child: const Text('Browse Templates'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(draftsProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: drafts.length,
                  itemBuilder: (c, i) => DraftCard(draft: drafts[i]),
                ),
              );
            },
          ),
          // Sent — placeholder until Firebase
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sent history needs Firebase — Phase B. '
                        'Drafts sync queued: “Saved — will send when you’re back online”',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.warning,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const PlaceholderCard(
                title: 'Wedding Invite (preview)',
                subtitle: '💍 Wedding • Sent 2 days ago • 12 opened',
              ),
            ],
          ),
          // Events — placeholder
          ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              EventCard(
                title: 'Ganesh Chaturthi Puja',
                date: '31 Aug 2026 • 10 AM',
                guests: '18 guests • 12 Yes, 4 Maybe, 2 No',
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/gallery'),
        backgroundColor: AppColors.twilightPlum,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create New'),
      ),
    );
  }
}
