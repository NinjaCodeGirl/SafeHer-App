import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'views/fake_call_screen.dart';
import 'views/grace_cancel_screen.dart';
import 'views/home_screen.dart';
import 'views/sos_active_screen.dart';
import 'views/stealth_mode_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive Local Database
  await StorageService.init();
  await StorageService.saveInitialDefaultContactsIfEmpty();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const SafeHerApp(),
    ),
  );
}

/// Custom ScrollBehavior allowing mouse, trackpad, and touch drag scrolling
class MobileScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class SafeHerApp extends StatelessWidget {
  const SafeHerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeHer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      scrollBehavior: MobileScrollBehavior(),
      builder: (context, child) {
        // Desktop responsive mobile frame wrapper
        final media = MediaQuery.of(context);
        if (media.size.width > 600) {
          return Container(
            color: const Color(0xFF070408),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  width: 430,
                  height: 900,
                  constraints: BoxConstraints(
                    maxHeight: media.size.height * 0.95,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkBg,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: const Color(0xFF2E1C38),
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
            ),
          );
        }
        return child!;
      },
      home: const MainStateWrapper(),
    );
  }
}

class MainStateWrapper extends StatelessWidget {
  const MainStateWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    // If Stealth Mode is enabled, show discreet clock screen
    if (provider.isStealthMode) {
      return const StealthModeScreen();
    }

    // If Fake Call trigger is active, show full-screen incoming call UI
    if (provider.isFakeCallActive) {
      return const FakeCallScreen();
    }

    // If SOS Grace Period countdown is active, show 5-second cancel window
    if (provider.alertState == AlertState.gracePeriod) {
      return const GraceCancelScreen();
    }

    // If SOS Alert is active, show pitch-identical emergency dashboard
    if (provider.alertState == AlertState.active) {
      return const SOSActiveScreen();
    }

    // Otherwise show primary Dashboard
    return const HomeScreen();
  }
}
