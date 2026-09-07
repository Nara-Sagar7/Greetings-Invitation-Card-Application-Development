import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

/// Send Screen - #6 of 9 - PRD 06.5
/// Email only. Personalized card + RSVP/view link. Copyable link. Scheduled.
class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  bool scheduleLater = false;
  DateTime? scheduledAt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.email_outlined, color: AppColors.twilightPlum, size: 18),
                  const SizedBox(width: 8),
                  Text('Email delivery', style: AppTypography.labelLarge),
                  const Spacer(),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text('SendGrid/SES', style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontSize: 10))),
                ]),
                const SizedBox(height: 8),
                Text('Each guest gets a personalized card + direct RSVP/view link. Link is copyable for manual forwarding.', style: AppTypography.bodySmall.copyWith(color: AppColors.hint)),
                const SizedBox(height: 8),
                Text('SPF / DKIM / DMARC required • Mail-Tester ≥ 9/10 gate', style: AppTypography.captionMono.copyWith(color: AppColors.hint, fontSize: 9)),
              ]),
            ),
            const SizedBox(height: 16),
            Text('RSVP link (copyable)', style: AppTypography.labelLarge),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.warmIvory, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Expanded(child: Text('https://greetings.app/rsvp/abc123', style: AppTypography.captionMono.copyWith(color: AppColors.twilightPlum))),
                IconButton(onPressed: () {}, icon: const Icon(Icons.copy, size: 18, color: AppColors.twilightPlum)),
              ]),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: scheduleLater,
              onChanged: (v) => setState(() => scheduleLater = v),
              title: Text('Schedule for later', style: AppTypography.labelLarge),
              subtitle: Text('Send immediately or at a chosen time', style: AppTypography.bodySmall.copyWith(color: AppColors.hint)),
              activeColor: AppColors.twilightPlum,
            ),
            if (scheduleLater)
              ListTile(
                leading: const Icon(Icons.schedule, color: AppColors.twilightPlum),
                title: Text(scheduledAt != null ? scheduledAt.toString() : 'Pick date & time', style: AppTypography.bodyMedium),
                trailing: TextButton(onPressed: () async {
                  final d = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)), initialDate: DateTime.now());
                  if (d != null) setState(() => scheduledAt = d);
                }, child: const Text('Select')),
              ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.info.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(AppConstants.offlineLabel, style: AppTypography.bodySmall.copyWith(color: AppColors.info))),
              ]),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => context.go('/rsvp/event_123'), child: Text(scheduleLater ? 'Schedule Send' : 'Send Now • Email'))),
            const SizedBox(height: 8),
            Center(child: Text('Guests need no app — just a link. Auto reminder 24h before event.', style: AppTypography.bodySmall.copyWith(color: AppColors.hint), textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}
