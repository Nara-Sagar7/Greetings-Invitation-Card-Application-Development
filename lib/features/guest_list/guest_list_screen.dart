import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Guest List Screen - #5 of 9 - PRD 06.2
/// Manual entry or import from device contacts (email only). Exportable.
class GuestListScreen extends StatefulWidget {
  const GuestListScreen({super.key});

  @override
  State<GuestListScreen> createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {
  final List<Map<String, String>> guests = [
    {'name': 'Priya Sharma', 'email': 'priya@example.com'},
    {'name': 'Arjun Patel', 'email': 'arjun@example.com'},
  ];
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guest List'), actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.upload_file_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.download_outlined)),
      ]),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.marigoldGold.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.marigoldGold.withOpacity(0.2))),
            child: Row(children: [
              const Icon(Icons.contact_page_outlined, color: AppColors.twilightPlum, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('Import from device contacts (email only) • One-click import', style: AppTypography.bodySmall.copyWith(color: AppColors.charcoalInk))),
              TextButton(onPressed: () {}, child: const Text('Import')),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(child: TextField(controller: _nameCtrl, decoration: const InputDecoration(hintText: 'Name', isDense: true))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: _emailCtrl, decoration: const InputDecoration(hintText: 'Email', isDense: true))),
              const SizedBox(width: 8),
              FilledButton(onPressed: () {
                if (_nameCtrl.text.isNotEmpty && _emailCtrl.text.isNotEmpty) {
                  setState(() => guests.add({'name': _nameCtrl.text, 'email': _emailCtrl.text}));
                  _nameCtrl.clear();
                  _emailCtrl.clear();
                }
              }, style: FilledButton.styleFrom(minimumSize: const Size(48, 48), padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Icon(Icons.add)),
            ]),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: guests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final g = guests[i];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: Row(children: [
                    CircleAvatar(backgroundColor: AppColors.twilightPlum.withOpacity(0.1), child: Text(g['name']![0], style: TextStyle(color: AppColors.twilightPlum))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(g['name']!, style: AppTypography.labelLarge), Text(g['email']!, style: AppTypography.bodySmall.copyWith(color: AppColors.hint))])),
                    IconButton(onPressed: () => setState(() => guests.removeAt(i)), icon: const Icon(Icons.close, size: 18, color: AppColors.hint)),
                  ]),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
            child: Column(children: [
              Row(children: [Text('${guests.length} guests', style: AppTypography.labelLarge), const Spacer(), Text('Copyable RSVP link per guest', style: AppTypography.bodySmall.copyWith(color: AppColors.hint))]),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => context.push('/send'), child: const Text('Next: Send →'))),
            ]),
          ),
        ],
      ),
    );
  }
}
