import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'providers/guest_list_provider.dart';

/// Guest List - 6.5 real Hive + CSV export
class GuestListScreen extends ConsumerStatefulWidget {
  const GuestListScreen({super.key});
  @override
  ConsumerState<GuestListScreen> createState() => _GuestListScreenState();
}

class _GuestListScreenState extends ConsumerState<GuestListScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _exportCsv() async {
    final csv = ref.read(guestListProvider.notifier).toCsv();
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/guests_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(csv);
    await Share.shareXFiles([XFile(file.path)], text: 'Guest List');
  }

  @override
  Widget build(BuildContext context) {
    final guests = ref.watch(guestListProvider);
    final notifier = ref.read(guestListProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest List'),
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Import contacts - coming soon')),
            ),
            icon: const Icon(Icons.upload_file_outlined),
          ),
          IconButton(
            onPressed: guests.isEmpty ? null : _exportCsv,
            icon: const Icon(Icons.download_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.marigoldGold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.marigoldGold.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.contact_page_outlined,
                  color: AppColors.twilightPlum,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Import from device contacts (email only)',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.charcoalInk,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contacts import soon')),
                  ),
                  child: const Text('Import'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () async {
                    final ok = await notifier.addGuest(
                      _nameCtrl.text,
                      _emailCtrl.text,
                    );
                    if (!ok && context.mounted)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid or duplicate email'),
                        ),
                      );
                    if (ok) {
                      _nameCtrl.clear();
                      _emailCtrl.clear();
                    }
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: guests.isEmpty
                ? Center(
                    child: Text(
                      'No guests yet. Add above.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.hint,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: guests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final g = guests[i];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.twilightPlum
                                  .withValues(alpha: 0.1),
                              child: Text(
                                g.name.isNotEmpty ? g.name[0] : '?',
                                style: const TextStyle(
                                  color: AppColors.twilightPlum,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(g.name, style: AppTypography.labelLarge),
                                  Text(
                                    g.email,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.hint,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => notifier.removeGuest(g.email),
                              icon: const Icon(
                                Icons.close,
                                size: 18,
                                color: AppColors.hint,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${guests.length} guests',
                      style: AppTypography.labelLarge,
                    ),
                    const Spacer(),
                    Text(
                      'Copyable RSVP link per guest',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.hint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push('/send'),
                    child: const Text('Next: Send →'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
