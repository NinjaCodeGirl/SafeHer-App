import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _shakeEnabled = true;
  double _shakeSensitivity = 2.7;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _shakeEnabled = StorageService.getShakeTriggerEnabled();
    _shakeSensitivity = StorageService.getShakeSensitivity();
    _biometricEnabled = StorageService.getBiometricEnabled();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Emergency Triggers', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 14),

              // Shake Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.glassCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.sensors_rounded, color: AppColors.lavender),
                            SizedBox(width: 12),
                            Text('3-Shake Gesture Trigger', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        Switch.adaptive(
                          value: _shakeEnabled,
                          activeTrackColor: AppColors.mintGreen.withValues(alpha: 0.5),
                          activeThumbColor: AppColors.mintGreen,
                          onChanged: (val) {
                            setState(() {
                              _shakeEnabled = val;
                            });
                            StorageService.setShakeTriggerEnabled(val);
                            if (val) {
                              provider.startShakeDetection();
                            } else {
                              provider.stopShakeDetection();
                            }
                          },
                        ),
                      ],
                    ),
                    if (_shakeEnabled) ...[
                      const Divider(color: AppColors.glassBorder, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Shake Sensitivity (G-Force)', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          Text('${_shakeSensitivity.toStringAsFixed(1)} G', style: const TextStyle(color: AppColors.lavender, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Slider(
                        value: _shakeSensitivity,
                        min: 1.5,
                        max: 4.5,
                        divisions: 15,
                        activeColor: AppColors.lavender,
                        inactiveColor: AppColors.glassCard,
                        onChanged: (val) {
                          setState(() {
                            _shakeSensitivity = val;
                          });
                          provider.updateShakeThreshold(val);
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('More Sensitive', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                            Text('Less Sensitive', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text('Security & Biometrics', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 14),

              // Biometric Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.glassCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.fingerprint_rounded, color: AppColors.lavender),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fingerprint / Face ID Lock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('Require auth to open app & settings', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: _biometricEnabled,
                      activeTrackColor: AppColors.mintGreen.withValues(alpha: 0.5),
                      activeThumbColor: AppColors.mintGreen,
                      onChanged: (val) {
                        setState(() {
                          _biometricEnabled = val;
                        });
                        StorageService.setBiometricEnabled(val);
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),
              const Center(
                child: Text(
                  'SafeHer Mobile v1.0.0 • 100% On-Device Protection',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
