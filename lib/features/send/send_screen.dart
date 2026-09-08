import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/data_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/event_model.dart';
import '../../services/billing_service.dart';
import '../guest_list/providers/guest_list_provider.dart';
import 'widgets/send_widgets.dart';

/// Send Screen 6.5 - per-guest uuid links + Firestore + schedule
class SendScreen extends ConsumerStatefulWidget {
  const SendScreen({super.key});
  @override
  ConsumerState<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends ConsumerState<SendScreen> {
  bool scheduleLater = false;
  DateTime? scheduledAt;
  bool sending = false;
  final _uuid = const Uuid();

  String _linkFor(String eventId, String email) =>
      'https://greetings.app/rsvp/$eventId?guest=${Uri.encodeComponent(email)}&id=${_uuid.v4().substring(0, 8)}';

  Future<void> _send() async {
    final guests = ref.read(guestListProvider);
    if (guests.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Add guests first')));
      return;
    }
    if (!await BillingService.canCreateEvent()) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Free limit 3 events/month reached. Upgrade.'),
          ),
        );
      return;
    }
    setState(() => sending = true);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'local_user';
    final eventId = 'event_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final event = EventModel(
      id: eventId,
      hostId: uid,
      title: 'Greetings Event',
      dateTime: scheduledAt ?? now.add(const Duration(days: 7)),
      timezone: 'Asia/Kolkata',
      location: 'To be decided',
      description: 'Sent via Greetings',
      templateId: 'template_diwali_1',
      canvasJson: {'eventId': eventId},
      status: scheduleLater ? 'scheduled' : 'sent',
      guestEmails: guests.map((g) => g.email).toList(),
      createdAt: now,
      updatedAt: now,
    );
    try {
      await ref.read(dataRepositoryProvider).saveDraft(event);
      // Write to Firestore events + per-guest docs if logged in
      if (uid != 'local_user') {
        final fs = FirebaseFirestore.instance;
        await fs
            .collection('users')
            .doc(uid)
            .collection('events')
            .doc(eventId)
            .set(event.toJson());
        for (final g in guests) {
          final link = _linkFor(eventId, g.email);
          await fs
              .collection('events')
              .doc(eventId)
              .collection('rsvps')
              .doc(g.email)
              .set({
                'email': g.email,
                'name': g.name,
                'rsvp': 'pending',
                'link': link,
                'scheduledAt': scheduledAt?.toIso8601String(),
                'createdAt': FieldValue.serverTimestamp(),
              });
        }
      }
      await BillingService.recordEvent();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            scheduleLater
                ? 'Scheduled for ${scheduledAt.toString().split('.').first}'
                : 'Sent to ${guests.length} guests • ${AppConstants.offlineLabel}',
          ),
        ),
      );
      context.go('/rsvp/$eventId');
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Send failed: $e')));
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final guests = ref.watch(guestListProvider);
    final eventId = 'event_${DateTime.now().millisecondsSinceEpoch}';
    return Scaffold(
      appBar: AppBar(title: const Text('Send')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const EmailDeliveryCard(),
            const SizedBox(height: 16),
            Text(
              'RSVP links (${guests.length} guests)',
              style: AppTypography.labelLarge,
            ),
            const SizedBox(height: 8),
            if (guests.isEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warmIvory,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  'No guests yet. Add in Guest List.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.hint,
                  ),
                ),
              )
            else
              ...guests.map(
                (g) =>
                    GuestLinkTile(guest: g, link: _linkFor(eventId, g.email)),
              ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: scheduleLater,
              onChanged: (v) => setState(() => scheduleLater = v),
              title: Text(
                'Schedule for later',
                style: AppTypography.labelLarge,
              ),
              subtitle: Text(
                'Send immediately or later',
                style: AppTypography.bodySmall.copyWith(color: AppColors.hint),
              ),
              activeColor: AppColors.twilightPlum,
            ),
            if (scheduleLater)
              ListTile(
                leading: const Icon(
                  Icons.schedule,
                  color: AppColors.twilightPlum,
                ),
                title: Text(
                  scheduledAt != null
                      ? scheduledAt.toString().split('.').first
                      : 'Pick date & time',
                  style: AppTypography.bodyMedium,
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDate: DateTime.now(),
                    );
                    if (d == null) return;
                    final t = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (t == null) return;
                    setState(
                      () => scheduledAt = DateTime(
                        d.year,
                        d.month,
                        d.day,
                        t.hour,
                        t.minute,
                      ),
                    );
                  },
                  child: const Text('Select'),
                ),
              ),
            const SizedBox(height: 8),
            const OfflineInfo(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: sending ? null : _send,
                child: sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        scheduleLater ? 'Schedule Send' : 'Send Now • Email',
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Guests need no app — just a link. Auto reminder 24h.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.hint),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
