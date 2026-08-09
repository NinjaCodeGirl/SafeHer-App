import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('Privacy & Security'),
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
                  color: AppColors.mintGreenBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified_user_rounded, color: AppColors.mintGreen, size: 28),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Privacy Is the Foundation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          SizedBox(height: 2),
                          Text('No accounts, no email, no central servers. Your data stays 100% on your phone.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Core Safeguards', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: const [
                    _PrivacyFeatureTile(
                      icon: Icons.storage_rounded,
                      title: 'On-Device Storage',
                      description: 'Sensitive data — location, audio evidence, emergency contacts — stays strictly on your phone unless an alert is triggered.',
                    ),
                    SizedBox(height: 12),
                    _PrivacyFeatureTile(
                      icon: Icons.location_off_rounded,
                      title: 'No Background Tracking',
                      description: 'SafeHer does not monitor or log your location outside of an active emergency alert.',
                    ),
                    SizedBox(height: 12),
                    _PrivacyFeatureTile(
                      icon: Icons.fingerprint_rounded,
                      title: 'Biometric Lock',
                      description: 'App access, contacts list, and settings edits are protected by Fingerprint or Face ID.',
                    ),
                    SizedBox(height: 12),
                    _PrivacyFeatureTile(
                      icon: Icons.signal_cellular_alt_rounded,
                      title: 'Offline & Limited Signal Support',
                      description: 'Direct SMS fallback ensures alerts queue and send the moment cellular signal is available.',
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

class _PrivacyFeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PrivacyFeatureTile({
    required this.icon,
    required this.title,
    required this.description,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lavenderBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.lavender, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
