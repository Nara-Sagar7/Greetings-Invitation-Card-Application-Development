import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// RSVP Dashboard - #7 of 9 - PRD 06.2 KEY DIFFERENTIATOR
/// 3-way RSVP Yes/No/Maybe, real-time, auto reminder, exportable, re-notify on edit.
class RsvpDashboardScreen extends StatelessWidget {
  final String eventId;
  const RsvpDashboardScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RSVP Dashboard'), actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.download_outlined)),
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              _StatCard(label: 'Yes', count: '12', color: AppColors.success, icon: Icons.check_circle_outline),
              const SizedBox(width: 8),
              _StatCard(label: 'Maybe', count: '4', color: AppColors.warning, icon: Icons.help_outline),
              const SizedBox(width: 8),
              _StatCard(label: 'No', count: '3', color: AppColors.error, icon: Icons.cancel_outlined),
            ]),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Response rate', style: AppTypography.labelLarge), const SizedBox(height: 4), LinearProgressIndicator(value: 0.63, backgroundColor: AppColors.border, color: AppColors.twilightPlum, borderRadius: BorderRadius.circular(4))])),
                const SizedBox(width: 12),
                Text('63%', style: AppTypography.heading2.copyWith(color: AppColors.twilightPlum)),
              ]),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Text('Guest responses', style: AppTypography.heading3),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text('Real-time', style: AppTypography.labelSmall.copyWith(color: AppColors.info, fontSize: 10))),
            ]),
            const SizedBox(height: 12),
            _RsvpRow(name: 'Priya Sharma', email: 'priya@example.com', status: 'yes', answer: 'Veg meal'),
            _RsvpRow(name: 'Arjun Patel', email: 'arjun@example.com', status: 'maybe', answer: 'Will confirm tomorrow'),
            _RsvpRow(name: 'Sneha Rao', email: 'sneha@example.com', status: 'no', answer: null),
            _RsvpRow(name: 'Vikram Singh', email: 'vikram@example.com', status: 'yes', answer: null),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.warmIvory, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [const Icon(Icons.notifications_outlined, size: 16, color: AppColors.twilightPlum), const SizedBox(width: 6), Text('Automation', style: AppTypography.labelMedium)]),
                const SizedBox(height: 6),
                Text('• Single reminder email 24h before event\n• Editing event re-notifies all guests automatically\n• Optional custom guest question', style: AppTypography.bodySmall.copyWith(color: AppColors.hint)),
              ]),
            ),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.list_alt), label: const Text('Printable / Exportable Guest List'))),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String count;
  final Color color;
  final IconData icon;
  const _StatCard({required this.label, required this.count, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))),
        child: Column(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(count, style: AppTypography.heading1.copyWith(color: color, fontSize: 22)),
          Text(label, style: AppTypography.labelSmall.copyWith(color: color)),
        ]),
      ),
    );
  }
}

class _RsvpRow extends StatelessWidget {
  final String name;
  final String email;
  final String status;
  final String? answer;
  const _RsvpRow({required this.name, required this.email, required this.status, this.answer});

  @override
  Widget build(BuildContext context) {
    Color c;
    IconData icon;
    String label;
    switch (status) {
      case 'yes': c = AppColors.success; icon = Icons.check_circle; label = 'Yes'; break;
      case 'no': c = AppColors.error; icon = Icons.cancel; label = 'No'; break;
      default: c = AppColors.warning; icon = Icons.help; label = 'Maybe'; break;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Icon(icon, color: c, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: AppTypography.labelLarge.copyWith(fontSize: 13)), Text(email, style: AppTypography.bodySmall.copyWith(color: AppColors.hint, fontSize: 11)), if (answer != null) Text('Answer: $answer', style: AppTypography.bodySmall.copyWith(color: AppColors.hint, fontStyle: FontStyle.italic)) ])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(20)), child: Text(label, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700))),
      ]),
    );
  }
}
