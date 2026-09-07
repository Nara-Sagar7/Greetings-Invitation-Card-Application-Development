import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

/// Account / Settings Screen - #9 of 9 - PRD 07
/// Calendar sync, billing, support chatbot entry.
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                const CircleAvatar(radius: 28, backgroundColor: AppColors.twilightPlum, child: Icon(Icons.person, color: Colors.white, size: 28)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Sagar Organizer', style: AppTypography.heading3.copyWith(fontSize: 16)), Text('sagar@example.com', style: AppTypography.bodySmall.copyWith(color: AppColors.hint)), const SizedBox(height: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.warmIvory, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)), child: Text('Free Plan', style: AppTypography.labelSmall.copyWith(fontSize: 10)))])),
                const Icon(Icons.chevron_right, color: AppColors.hint),
              ]),
            ),
            const SizedBox(height: 20),
            // Premium comparison - PRD 06.9 One comparison, No Tricks
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(gradient: AppColors.plumGradient, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Text('Premium • No Tricks', style: AppTypography.heading3.copyWith(color: Colors.white, fontSize: 16)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.marigoldGold, borderRadius: BorderRadius.circular(20)), child: Text('One table. Zero hidden paywalls.', style: AppTypography.labelSmall.copyWith(color: AppColors.charcoalInk, fontSize: 9)))]),
                const SizedBox(height: 12),
                _CompareRow(feature: 'Templates', free: 'Limited', premium: 'All 200'),
                _CompareRow(feature: 'Events/cards', free: '3 / 5 per month', premium: 'Unlimited'),
                _CompareRow(feature: 'Watermark', free: 'Small watermark', premium: 'No watermark'),
                _CompareRow(feature: 'RSVP & Calendar', free: 'Included', premium: 'Included'),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: AppColors.marigoldGold, foregroundColor: AppColors.charcoalInk), child: Text('Monthly ${AppConstants.premiumMonthlyPrice}'))),
                  const SizedBox(width: 12),
                  Expanded(child: FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.twilightPlum), child: Text('Annual ${AppConstants.premiumAnnualPrice}'))),
                ]),
                const SizedBox(height: 8),
                Center(child: Text('Single comparison table shown once — no hidden gates, ever.', style: AppTypography.bodySmall.copyWith(color: Colors.white.withOpacity(0.7), fontSize: 11), textAlign: TextAlign.center)),
              ]),
            ),
            const SizedBox(height: 20),
            Text('Settings', style: AppTypography.heading3.copyWith(fontSize: 14)),
            const SizedBox(height: 8),
            _SettingsTile(icon: Icons.calendar_today_outlined, title: 'Google Calendar Sync', subtitle: 'Host OAuth • auto create/update/cancel • Guest .ics', trailing: Switch(value: false, onChanged: (_) {}, activeColor: AppColors.twilightPlum)),
            _SettingsTile(icon: Icons.language, title: 'Language', subtitle: 'English • Hindi (V1) • More in V2', onTap: () {}),
            _SettingsTile(icon: Icons.dark_mode_outlined, title: 'Dark Mode', subtitle: 'Accent stays Marigold #E8A33D', trailing: Switch(value: false, onChanged: (_) {}, activeColor: AppColors.twilightPlum)),
            _SettingsTile(icon: Icons.support_agent_outlined, title: 'Help & Support', subtitle: 'AI chatbot for FAQs • email escalation', onTap: () => _showChatbot(context)),
            _SettingsTile(icon: Icons.logout, title: 'Sign Out', subtitle: 'Email/password + Google Sign-In', onTap: () {}, isDestructive: true),
            const SizedBox(height: 16),
            Center(child: Text('V1 • One codebase • iOS & Android • Firebase BaaS\nIn Jesus name we pray. Amen. 🙏', textAlign: TextAlign.center, style: AppTypography.bodySmall.copyWith(color: AppColors.hint, fontSize: 11))),
          ],
        ),
      ),
    );
  }

  void _showChatbot(BuildContext context) {
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => DraggableScrollableSheet(expand: false, initialChildSize: 0.7, maxChildSize: 0.9, builder: (context, controller) => Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))), const SizedBox(height: 16), Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.twilightPlum.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.smart_toy_outlined, color: AppColors.twilightPlum)), const SizedBox(width: 8), Text('FAQ Assistant', style: AppTypography.heading3), const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text('PRD 6.8 • FAQ only, no content creation', style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontSize: 9)))]), const SizedBox(height: 12), Text('How can we help?', style: AppTypography.bodySmall.copyWith(color: AppColors.hint)), const SizedBox(height: 12), _FaqTile(question: 'Why does my preview not match sent card?'), _FaqTile(question: 'How to import contacts?'), _FaqTile(question: 'How does 3-way RSVP work?'), const Spacer(), TextField(decoration: InputDecoration(hintText: 'Ask a question...', suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.send, color: AppColors.twilightPlum)))), Text('Escalation to ${AppConstants.supportEmail} for unresolved queries', style: AppTypography.bodySmall.copyWith(color: AppColors.hint, fontSize: 10))]))));
  }
}

class _CompareRow extends StatelessWidget {
  final String feature;
  final String free;
  final String premium;
  const _CompareRow({required this.feature, required this.free, required this.premium});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(flex: 2, child: Text(feature, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12))),
        Expanded(child: Text(free, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12), textAlign: TextAlign.center)),
        Expanded(child: Text(premium, style: const TextStyle(color: AppColors.marigoldGold, fontSize: 12, fontWeight: FontWeight.w700), textAlign: TextAlign.center)),
      ]),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isDestructive;
  const _SettingsTile({required this.icon, required this.title, required this.subtitle, this.onTap, this.trailing, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? AppColors.error : AppColors.twilightPlum, size: 20),
        title: Text(title, style: AppTypography.labelLarge.copyWith(color: isDestructive ? AppColors.error : AppColors.charcoalInk, fontSize: 13)),
        subtitle: Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.hint, fontSize: 11)),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: AppColors.hint, size: 18) : null),
        onTap: onTap,
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  const _FaqTile({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: AppColors.warmIvory, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: ListTile(title: Text(question, style: AppTypography.bodyMedium.copyWith(fontSize: 13)), trailing: const Icon(Icons.chevron_right, size: 16, color: AppColors.hint)),
    );
  }
}
