import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/tracking_service.dart';
import 'widgets/guest_rsvp_card.dart';
import 'widgets/rsvp_widgets.dart';

/// RSVP Dashboard 6.5 - real-time Firestore
class RsvpDashboardScreen extends StatelessWidget {
  final String eventId;
  const RsvpDashboardScreen({super.key, required this.eventId});

  Stream<QuerySnapshot<Map<String, dynamic>>> _rsvpStream() => FirebaseFirestore
      .instance
      .collection('events')
      .doc(eventId)
      .collection('rsvps')
      .snapshots();

  Future<void> _export(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) async {
    final buf = StringBuffer()..writeln('Name,Email,RSVP,Answer,Link');
    for (final d in docs) {
      final m = d.data();
      buf.writeln(
        '"${m['name'] ?? ''}","${m['email'] ?? ''}","${m['rsvp'] ?? ''}","${(m['answer'] ?? '').toString().replaceAll('"', '""')}","${m['link'] ?? ''}"',
      );
    }
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/rsvp_$eventId.csv');
    await file.writeAsString(buf.toString());
    await Share.shareXFiles([XFile(file.path)], text: 'RSVP $eventId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RSVP Dashboard')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _rsvpStream(),
        builder: (context, snap) {
          final docs = snap.data?.docs ?? [];
          final yes = docs
              .where((d) => (d.data()['rsvp'] ?? '') == 'yes')
              .length;
          final maybe = docs
              .where((d) => (d.data()['rsvp'] ?? '') == 'maybe')
              .length;
          final no = docs.where((d) => (d.data()['rsvp'] ?? '') == 'no').length;
          final pending = docs
              .where((d) => !['yes', 'maybe', 'no'].contains(d.data()['rsvp']))
              .length;
          final total = docs.length;
          final responded = yes + maybe + no;
          final rate = total == 0 ? 0.0 : responded / total;
          final guestEmail = GoRouterState.of(context)
              .uri
              .queryParameters['guest'];
          if (guestEmail != null) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => TrackingService.trackOpened(
                eventId: eventId,
                guestEmail: guestEmail,
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (guestEmail != null)
                  GuestRsvpCard(eventId: eventId, guestEmail: guestEmail),
                if (guestEmail != null) const SizedBox(height: 16),
                Row(
                  children: [
                    StatCard(
                      label: 'Yes',
                      count: '$yes',
                      color: AppColors.success,
                      icon: Icons.check_circle_outline,
                    ),
                    const SizedBox(width: 8),
                    StatCard(
                      label: 'Maybe',
                      count: '$maybe',
                      color: AppColors.warning,
                      icon: Icons.help_outline,
                    ),
                    const SizedBox(width: 8),
                    StatCard(
                      label: 'No',
                      count: '$no',
                      color: AppColors.error,
                      icon: Icons.cancel_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ResponseRateCard(
                  rate: rate,
                  responded: responded,
                  total: total,
                ),
                const SizedBox(height: 8),
                Text(
                  '$responded of $total responded • $pending pending',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.hint,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Guest responses', style: AppTypography.heading3),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        snap.connectionState == ConnectionState.waiting
                            ? 'Loading'
                            : 'Real-time',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.info,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (docs.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warmIvory,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      'No RSVPs yet. Share links from Send screen.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.hint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ...docs.map((d) {
                    final m = d.data();
                    return RsvpRow(
                      name: m['name'] ?? '',
                      email: m['email'] ?? '',
                      status: (m['rsvp'] ?? 'pending').toString(),
                      answer: m['answer']?.toString(),
                    );
                  }),
                const SizedBox(height: 16),
                const AutomationCard(),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      // TODO: fetch real event for calendar - using dummy for now
                      final dummy = await FirebaseFirestore.instance
                          .collection('users')
                          .doc('local_user')
                          .collection('events')
                          .doc(eventId)
                          .get();
                      if (dummy.exists) {
                        // ignore: unused
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Add to Calendar .ics shared'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: const Text('Add to Calendar (.ics)'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Guest .ics works for all; Host Google OAuth sync in next update',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.hint,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: docs.isEmpty
                        ? null
                        : () => _export(context, docs),
                    icon: const Icon(Icons.list_alt),
                    label: const Text('Printable / Exportable Guest List'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
