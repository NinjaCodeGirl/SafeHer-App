import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class StealthModeScreen extends StatefulWidget {
  const StealthModeScreen({super.key});

  @override
  State<StealthModeScreen> createState() => _StealthModeScreenState();
}

class _StealthModeScreenState extends State<StealthModeScreen> {
  late DateTime _now;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onLongPress: () {
            // Secret 3-second long press to exit stealth mode back to normal UI
            provider.toggleStealthMode(false);
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Icon(Icons.lock_outline_rounded, color: Colors.white24, size: 28),
                const SizedBox(height: 12),
                Text(
                  _formatTime(_now),
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w200,
                    color: Colors.white70,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(_now),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white38,
                    letterSpacing: 1.0,
                  ),
                ),
                const Spacer(),

                // Tiny discrete indicator at bottom
                if (provider.alertState == AlertState.active)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.emergencyRedStart,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Stealth Protection Active • Hold screen 3s to restore UI',
                        style: TextStyle(color: Colors.white24, fontSize: 10),
                      ),
                    ],
                  )
                else
                  const Text(
                    'Hold screen 3s to restore UI',
                    style: TextStyle(color: Colors.white12, fontSize: 10),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
