import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class GraceCancelScreen extends StatelessWidget {
  const GraceCancelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.emergencyBadgeBg,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.emergencyRedStart),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppColors.emergencyRedStart, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'EMERGENCY ALERT TRIGGERED',
                          style: TextStyle(
                            color: AppColors.emergencyRedStart,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sending SOS Alert in...',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
              
              // Countdown Display
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emergencyRedDark.withOpacity(0.3),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.emergencyRedGlow,
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: CircularProgressIndicator(
                      value: provider.graceCountdown / 5.0,
                      strokeWidth: 10,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.emergencyRedStart),
                      backgroundColor: AppColors.glassCard,
                    ),
                  ),
                  Text(
                    '${provider.graceCountdown}',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              // Cancel Action Button
              Column(
                children: [
                  const Text(
                    'Tap below if this was a false alarm',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        provider.cancelGracePeriod();
                      },
                      icon: const Icon(Icons.cancel_rounded, color: Colors.black, size: 24),
                      label: const Text(
                        'CANCEL EMERGENCY ALERT',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Location, Audio & Contacts dispatch active upon countdown expiry.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
