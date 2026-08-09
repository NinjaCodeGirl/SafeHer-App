import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('Activity History'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.glassCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.history_rounded, color: AppColors.lavender, size: 26),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'All emergency logs and audio evidence files are stored locally on your device only.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Recent Emergency Events',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: const [
                    _HistoryItemTile(
                      date: 'Today, 4:15 PM',
                      title: 'Fake Call Simulator Activated',
                      details: 'Duration: 1m 24s • Local ringtone simulation',
                      icon: Icons.phone_callback_rounded,
                      iconColor: AppColors.fakeCallPurple,
                    ),
                    SizedBox(height: 12),
                    _HistoryItemTile(
                      date: 'Yesterday, 10:30 PM',
                      title: 'Walk Home Safe Timer Completed',
                      details: '15 minute countdown • Confirmed safe by user',
                      icon: Icons.timer_rounded,
                      iconColor: AppColors.safetyTimerTeal,
                    ),
                    SizedBox(height: 12),
                    _HistoryItemTile(
                      date: '26 days ago',
                      title: '3-Shake Test Event',
                      details: 'Grace period cancelled by user • No SMS dispatched',
                      icon: Icons.sensors_rounded,
                      iconColor: AppColors.lavender,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryItemTile extends StatelessWidget {
  final String date;
  final String title;
  final String details;
  final IconData icon;
  final Color iconColor;

  const _HistoryItemTile({
    required this.date,
    required this.title,
    required this.details,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(details, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
