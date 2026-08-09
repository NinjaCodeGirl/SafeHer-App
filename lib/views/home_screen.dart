import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'contacts_screen.dart';
import 'history_screen.dart';
import 'privacy_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  void _showFakeCallDialog(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    String selectedCaller = 'Mom';
    int delaySeconds = 1;
    final customNameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkBgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.fakeCallPurpleBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.phone_callback_rounded, color: AppColors.fakeCallPurple),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fake Call Setup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('Simulate realistic incoming call to exit situations', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text('SELECT CALLER', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Mom', 'Dad', 'Boss', 'Police', 'Custom'].map((caller) {
                      final isSelected = selectedCaller == caller;
                      return ChoiceChip(
                        label: Text(caller),
                        selected: isSelected,
                        selectedColor: AppColors.fakeCallPurple,
                        backgroundColor: AppColors.glassCard,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              selectedCaller = caller;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),

                  if (selectedCaller == 'Custom') ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: customNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Enter Caller Name (e.g. Inspector Sharma)',
                        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBorder)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lavender)),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  const Text('TRIGGER TIMING', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: delaySeconds == 1 ? AppColors.lavenderBg : AppColors.glassCard,
                            side: BorderSide(color: delaySeconds == 1 ? AppColors.lavender : AppColors.glassBorder),
                          ),
                          onPressed: () => setModalState(() => delaySeconds = 1),
                          child: const Text('Instant (1s)', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: delaySeconds == 5 ? AppColors.lavenderBg : AppColors.glassCard,
                            side: BorderSide(color: delaySeconds == 5 ? AppColors.lavender : AppColors.glassBorder),
                          ),
                          onPressed: () => setModalState(() => delaySeconds = 5),
                          child: const Text('In 5 Sec', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: delaySeconds == 10 ? AppColors.lavenderBg : AppColors.glassCard,
                            side: BorderSide(color: delaySeconds == 10 ? AppColors.lavender : AppColors.glassBorder),
                          ),
                          onPressed: () => setModalState(() => delaySeconds = 10),
                          child: const Text('In 10 Sec', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fakeCallPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        final name = selectedCaller == 'Custom' && customNameController.text.trim().isNotEmpty
                            ? customNameController.text.trim()
                            : selectedCaller;
                        Navigator.pop(bottomSheetContext);
                        provider.triggerFakeCallWithName(callerName: name, delaySeconds: delaySeconds);
                      },
                      icon: const Icon(Icons.phone_callback_rounded),
                      label: const Text('START FAKE CALL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSafetyTimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.darkBgSecondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.timer_outlined, color: AppColors.safetyTimerTeal),
              SizedBox(width: 10),
              Text('Walk Home Safe Timer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Set a safety countdown when walking alone at night. If unconfirmed before time expires, SafeHer automatically initiates full SOS.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ListTile(
                tileColor: AppColors.glassCard,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: const Text('5 Minutes', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Quick walk nearby', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.lavender, size: 16),
                onTap: () {
                  Provider.of<AppProvider>(context, listen: false).startSafetyTimer(5);
                  Navigator.pop(dialogContext);
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: AppColors.glassCard,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: const Text('15 Minutes', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Standard transit home', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.lavender, size: 16),
                onTap: () {
                  Provider.of<AppProvider>(context, listen: false).startSafetyTimer(15);
                  Navigator.pop(dialogContext);
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: AppColors.glassCard,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: const Text('30 Minutes', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Longer commute', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.lavender, size: 16),
                onTap: () {
                  Provider.of<AppProvider>(context, listen: false).startSafetyTimer(30);
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNearbyHelpDialog(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.nearbyHelpCoralBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_hospital_outlined, color: AppColors.nearbyHelpCoral),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nearby Emergency Services', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Launch 1-tap Google Maps directions', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListTile(
                tileColor: AppColors.glassCard,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                leading: const Icon(Icons.local_police_rounded, color: Colors.blueAccent),
                title: const Text('Nearest Police Station', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Opens Google Maps directions', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                trailing: const Icon(Icons.open_in_new_rounded, color: AppColors.lavender),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  provider.launchNearbySearch('nearest police station');
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                tileColor: AppColors.glassCard,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                leading: const Icon(Icons.local_hospital_rounded, color: Colors.redAccent),
                title: const Text('Nearest Hospital', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Opens Google Maps directions', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                trailing: const Icon(Icons.open_in_new_rounded, color: AppColors.lavender),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  provider.launchNearbySearch('nearest hospital emergency');
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                tileColor: AppColors.glassCard,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                leading: const Icon(Icons.phone_in_talk_rounded, color: AppColors.mintGreen),
                title: const Text('Call Women Helpline (112 / 1091)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Instant emergency call dialer', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                trailing: const Icon(Icons.call_rounded, color: AppColors.mintGreen),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  provider.launchHelpline('112');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSafeZonesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.darkBgSecondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.safeZonesBlue),
              SizedBox(width: 10),
              Text('Saved Safe Zones', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                tileColor: AppColors.glassCard,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.home_rounded, color: AppColors.safeZonesBlue),
                title: const Text('Home', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Primary Safe Haven', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: AppColors.glassCard,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.school_rounded, color: AppColors.safeZonesBlue),
                title: const Text('Campus / Work', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Verified Location', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: AppColors.lavender)),
            ),
          ],
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'GOOD MORNING';
    if (hour < 17) return 'GOOD AFTERNOON';
    return 'GOOD EVENING';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab View switcher using IndexedStack so bottom nav bar is ALWAYS visible
            IndexedStack(
              index: _currentTab,
              children: [
                _buildHomeDashboard(context, provider),
                const ContactsScreen(),
                const HistoryScreen(),
                const PrivacyScreen(),
                const SettingsScreen(),
              ],
            ),

            // Persistent Translucent Glass Bottom Navigation Bar across ALL tabs
            Positioned(
              bottom: 16,
              left: 20,
              right: 20,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.darkBgSecondary.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: AppColors.glassBorder),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavTabItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      isSelected: _currentTab == 0,
                      onTap: () => setState(() => _currentTab = 0),
                    ),
                    _NavTabItem(
                      icon: Icons.people_outline_rounded,
                      label: 'Trusted',
                      isSelected: _currentTab == 1,
                      onTap: () => setState(() => _currentTab = 1),
                    ),
                    _NavTabItem(
                      icon: Icons.history_rounded,
                      label: 'History',
                      isSelected: _currentTab == 2,
                      onTap: () => setState(() => _currentTab = 2),
                    ),
                    _NavTabItem(
                      icon: Icons.shield_outlined,
                      label: 'Privacy',
                      isSelected: _currentTab == 3,
                      onTap: () => setState(() => _currentTab = 3),
                    ),
                    _NavTabItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      isSelected: _currentTab == 4,
                      onTap: () => setState(() => _currentTab = 4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeDashboard(BuildContext context, AppProvider provider) {
    return Stack(
      children: [
        // Background Radial Glow
        Positioned(
          top: -50,
          left: MediaQuery.of(context).size.width / 2 - 150,
          child: Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkBgRadial,
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBgRadial,
                  blurRadius: 100,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),
        ),

        // Main Content Area (Scrollable)
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              // Top Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "You're protected.",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                      ),
                    ],
                  ),

                  // Bell Notification Icon Button
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.glassCard,
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: AppColors.emergencyRedStart,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Active Safety Timer Ticker (if running)
              if (provider.isSafetyTimerRunning) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.safetyTimerTealBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.safetyTimerTeal),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_rounded, color: AppColors.safetyTimerTeal),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Walk Home Safe Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(
                              'Auto-SOS in ${provider.safetyTimerSecondsRemaining ~/ 60}:${(provider.safetyTimerSecondsRemaining % 60).toString().padLeft(2, '0')}',
                              style: const TextStyle(color: AppColors.safetyTimerTeal, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => provider.cancelSafetyTimer(),
                        child: const Text('I\'M SAFE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],

              // Lovable Status Card with 3 Statistics Columns
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.glassCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Column(
                  children: [
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
                                color: AppColors.statusGreenDot,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Protection Active',
                              style: TextStyle(
                                color: AppColors.statusGreenDot,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Updated just now',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: AppColors.glassBorder, height: 1),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatColumn(
                          value: '${provider.contacts.length}',
                          label: 'Contacts',
                          sublabel: 'TRUSTED',
                        ),
                        Container(width: 1, height: 30, color: AppColors.glassBorder),
                        const _StatColumn(
                          value: '4/5',
                          label: 'Triggers',
                          sublabel: 'ENABLED',
                        ),
                        Container(width: 1, height: 30, color: AppColors.glassBorder),
                        const _StatColumn(
                          value: '2',
                          label: 'Zones',
                          sublabel: 'SAVED',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Central Lovable SOS Button
              GestureDetector(
                onTap: () {
                  provider.triggerSOSGracePeriod();
                },
                child: Column(
                  children: [
                    const Text(
                      'PRESS & HOLD FOR EMERGENCY',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer Glow Ring
                        Container(
                          width: 200,
                          height: 200,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.emergencyRedDark,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.emergencyRedGlow,
                                blurRadius: 50,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                        ),
                        // Inner Coral Red Gradient Circle
                        Container(
                          width: 155,
                          height: 155,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.emergencyRedStart, AppColors.emergencyRedEnd],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SOS',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'TAP TO ACTIVATE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick Actions Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'QUICK ACTIONS',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 2x2 Quick Actions Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.65,
                children: [
                  _QuickActionTile(
                    icon: Icons.phone_callback_rounded,
                    iconBg: AppColors.fakeCallPurpleBg,
                    iconColor: AppColors.fakeCallPurple,
                    title: 'Fake Call',
                    subtitle: 'Escape a situation',
                    onTap: () => _showFakeCallDialog(context),
                  ),
                  _QuickActionTile(
                    icon: Icons.timer_outlined,
                    iconBg: AppColors.safetyTimerTealBg,
                    iconColor: AppColors.safetyTimerTeal,
                    title: 'Safety Timer',
                    subtitle: provider.isSafetyTimerRunning ? 'Active Timer' : 'Auto SOS if late',
                    onTap: () => _showSafetyTimerDialog(context),
                  ),
                  _QuickActionTile(
                    icon: Icons.location_on_outlined,
                    iconBg: AppColors.safeZonesBlueBg,
                    iconColor: AppColors.safeZonesBlue,
                    title: 'Safe Zones',
                    subtitle: '2 saved',
                    onTap: () => _showSafeZonesDialog(context),
                  ),
                  _QuickActionTile(
                    icon: Icons.support_rounded,
                    iconBg: AppColors.nearbyHelpCoralBg,
                    iconColor: AppColors.nearbyHelpCoral,
                    title: 'Nearby Help',
                    subtitle: 'Police • Hospitals',
                    onTap: () => _showNearbyHelpDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 90), // Spacing for floating bottom bar
            ],
          ),
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final String sublabel;

  const _StatColumn({
    required this.value,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        Text(
          sublabel,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.glassCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.lavenderBg,
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.lavender : AppColors.textMuted,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.lavender : AppColors.textMuted,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
