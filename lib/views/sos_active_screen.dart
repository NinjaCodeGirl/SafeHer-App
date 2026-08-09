import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class SOSActiveScreen extends StatefulWidget {
  const SOSActiveScreen({super.key});

  @override
  State<SOSActiveScreen> createState() => _SOSActiveScreenState();
}

class _SOSActiveScreenState extends State<SOSActiveScreen> {
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTimer(int s) {
    final mins = (s ~/ 60).toString().padLeft(2, '0');
    final secs = (s % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.activeEmergencyBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.emergencyRedStart,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'EMERGENCY ACTIVE',
                        style: TextStyle(
                          color: AppColors.emergencyRedStart,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _formatTimer(_seconds),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Pulsing Radar Circle
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emergencyRedDark.withValues(alpha: 0.3),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.emergencyRedGlow,
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.emergencyRedStart, AppColors.emergencyRedEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.sensors_rounded,
                      size: 46,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Text(
                'Help is on the way',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your trusted network has been notified',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),

              const SizedBox(height: 30),

              // Live Status Items
              Expanded(
                child: ListView(
                  children: [
                    _StatusCard(
                      icon: Icons.check_circle_rounded,
                      iconColor: AppColors.mintGreen,
                      title: provider.dispatchedCount > 0
                          ? '${provider.dispatchedCount} contacts alerted'
                          : '${provider.contacts.length} contacts alerting...',
                      subtitle: provider.contacts.isNotEmpty
                          ? provider.contacts.map((c) => c.name).join(', ')
                          : 'Add trusted contacts in Settings',
                      isActive: provider.dispatchedCount > 0,
                    ),
                    const SizedBox(height: 10),
                    _StatusCard(
                      icon: Icons.location_on_rounded,
                      iconColor: AppColors.mintGreen,
                      title: 'Live location shared',
                      subtitle: provider.currentPosition != null
                          ? 'GPS: ${provider.currentPosition!.latitude.toStringAsFixed(4)}, ${provider.currentPosition!.longitude.toStringAsFixed(4)}'
                          : 'Acquiring GPS coordinates...',
                      isActive: true,
                    ),
                    const SizedBox(height: 10),
                    _StatusCard(
                      icon: Icons.mic_rounded,
                      iconColor: provider.isRecordingAudio ? AppColors.emergencyRedStart : AppColors.mintGreen,
                      title: provider.isRecordingAudio ? 'Audio evidence recording...' : 'Audio recorder standby',
                      subtitle: provider.isRecordingAudio
                          ? 'Real microphone • Saved locally • Encrypted'
                          : 'Microphone permission required',
                      isActive: provider.isRecordingAudio,
                    ),
                    const SizedBox(height: 10),
                    _StatusCard(
                      icon: Icons.wifi_tethering_rounded,
                      iconColor: AppColors.mintGreen,
                      title: 'Tracking enabled',
                      subtitle: 'Periodic location updates active',
                      isActive: true,
                    ),
                  ],
                ),
              ),

              // Action Buttons Bottom
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.glassBorder),
                        backgroundColor: AppColors.glassCard,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        provider.launchNearbySearch('nearest police station');
                      },
                      icon: const Icon(Icons.share_rounded, color: Colors.white, size: 18),
                      label: const Text('Share update', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.glassBorder),
                        backgroundColor: AppColors.glassCard,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        provider.launchHelpline('112');
                      },
                      icon: const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
                      label: const Text('Call 112', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Stop Emergency Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    provider.resolveAlert();
                  },
                  icon: const Icon(Icons.stop_rounded, color: Colors.black, size: 22),
                  label: const Text(
                    'Stop Emergency',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isActive;

  const _StatusCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.glassCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.statusGreenDot : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
