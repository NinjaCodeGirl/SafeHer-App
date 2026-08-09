import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class FakeCallScreen extends StatefulWidget {
  const FakeCallScreen({super.key});

  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  bool _isCallConnected = false;
  int _callSeconds = 0;
  Timer? _callTimer;

  void _acceptCall() {
    setState(() {
      _isCallConnected = true;
    });
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callSeconds++;
        });
      }
    });
  }

  void _declineCall() {
    _callTimer?.cancel();
    Provider.of<AppProvider>(context, listen: false).dismissFakeCall();
  }

  String _formatTimer(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Caller Info Header
              Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.glassCard,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 60,
                      color: AppColors.lavender,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    Provider.of<AppProvider>(context, listen: false).fakeCallerName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isCallConnected
                        ? _formatTimer(_callSeconds)
                        : 'Incoming Mobile Call...',
                    style: TextStyle(
                      fontSize: 16,
                      color: _isCallConnected ? Colors.greenAccent : Colors.grey,
                    ),
                  ),
                ],
              ),

              // Action Buttons Bottom
              _isCallConnected
                  ? Column(
                      children: [
                        const Text(
                          'Simulating call to exit uncomfortable situation...',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: _declineCall,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.redAccent,
                            ),
                            child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 36),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Decline
                        Column(
                          children: [
                            GestureDetector(
                              onTap: _declineCall,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.redAccent,
                                ),
                                child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 36),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('Decline', style: TextStyle(color: Colors.white, fontSize: 14)),
                          ],
                        ),
                        
                        // Accept
                        Column(
                          children: [
                            GestureDetector(
                              onTap: _acceptCall,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: const Icon(Icons.call_rounded, color: Colors.white, size: 36),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('Accept', style: TextStyle(color: Colors.white, fontSize: 14)),
                          ],
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
