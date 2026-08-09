import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import '../models/emergency_contact.dart';
import '../services/storage_service.dart';
import '../services/shake_service.dart';
import '../services/audio_evidence_service.dart';
import '../services/sos_dispatch_service.dart';

enum AlertState { idle, gracePeriod, active, resolved }

class AppProvider extends ChangeNotifier {
  List<EmergencyContact> _contacts = [];
  bool _isProtectionActive = true;
  AlertState _alertState = AlertState.idle;
  int _graceCountdown = 5;
  Timer? _graceTimer;
  Position? _currentPosition;
  bool _isRecordingAudio = false;
  String? _lastRecordingPath;
  int _dispatchedCount = 0;

  // Shake Detection State
  bool _isShakeListening = false;
  double _shakeThreshold = 2.7;

  // Fake Call State
  bool _isFakeCallActive = false;
  String _fakeCallerName = 'Mom';

  // Stealth Mode State
  bool _isStealthMode = false;
  int _safetyTimerSecondsRemaining = 0;
  Timer? _safetyCountdownTimer;
  bool _isSafetyTimerRunning = false;

  // Getters
  List<EmergencyContact> get contacts => _contacts;
  bool get isProtectionActive => _isProtectionActive;
  AlertState get alertState => _alertState;
  int get graceCountdown => _graceCountdown;
  Position? get currentPosition => _currentPosition;
  bool get isRecordingAudio => _isRecordingAudio;
  bool get isFakeCallActive => _isFakeCallActive;
  String get fakeCallerName => _fakeCallerName;
  bool get isSafetyTimerRunning => _isSafetyTimerRunning;
  int get safetyTimerSecondsRemaining => _safetyTimerSecondsRemaining;
  bool get isShakeListening => _isShakeListening;
  String? get lastRecordingPath => _lastRecordingPath;
  int get dispatchedCount => _dispatchedCount;
  bool get isStealthMode => _isStealthMode;

  AppProvider() {
    _loadContacts();
    _initShakeListener();
  }

  void _loadContacts() {
    _contacts = StorageService.getContacts();
    notifyListeners();
  }

  void toggleStealthMode(bool active) {
    _isStealthMode = active;
    notifyListeners();
  }

  // --- Shake Detection Lifecycle ---
  void _initShakeListener() {
    final enabled = StorageService.getShakeTriggerEnabled();
    _shakeThreshold = StorageService.getShakeSensitivity();
    if (enabled) {
      startShakeDetection();
    }
  }

  void startShakeDetection() {
    if (_isShakeListening) return;
    _shakeThreshold = StorageService.getShakeSensitivity();

    ShakeService.startListening(
      onThreeShakeDetected: () {
        // Only trigger if not already in an alert state
        if (_alertState == AlertState.idle) {
          debugPrint('[ShakeService] 3-shake detected! Triggering SOS grace period.');
          triggerSOSGracePeriod();
        }
      },
      thresholdG: _shakeThreshold,
    );
    _isShakeListening = true;
    notifyListeners();
  }

  void stopShakeDetection() {
    ShakeService.stopListening();
    _isShakeListening = false;
    notifyListeners();
  }

  void updateShakeThreshold(double newThreshold) {
    _shakeThreshold = newThreshold;
    StorageService.setShakeSensitivity(newThreshold);
    if (_isShakeListening) {
      // Restart with new threshold
      stopShakeDetection();
      startShakeDetection();
    }
  }

  // --- Contact Management ---
  Future<void> addContact(EmergencyContact contact) async {
    await StorageService.saveContact(contact);
    _loadContacts();
  }

  Future<void> deleteContact(String id) async {
    await StorageService.deleteContact(id);
    _loadContacts();
  }

  void toggleProtection(bool active) {
    _isProtectionActive = active;
    if (active) {
      startShakeDetection();
    } else {
      stopShakeDetection();
    }
    notifyListeners();
  }

  // --- SOS Alert Flow ---
  void triggerSOSGracePeriod() {
    if (_alertState != AlertState.idle) return;
    _alertState = AlertState.gracePeriod;
    _graceCountdown = 5;
    notifyListeners();

    // Vibrate to acknowledge trigger (haptic feedback)
    _vibrateAlert();

    _graceTimer?.cancel();
    _graceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_graceCountdown > 1) {
        _graceCountdown--;
        notifyListeners();
      } else {
        timer.cancel();
        _activateFullSOS();
      }
    });
  }

  void cancelGracePeriod() {
    _graceTimer?.cancel();
    _alertState = AlertState.idle;
    _graceCountdown = 5;
    notifyListeners();
  }

  Future<void> _activateFullSOS() async {
    _alertState = AlertState.active;
    _dispatchedCount = 0;
    notifyListeners();

    // 1. Start audio evidence recording
    await _startAudioEvidence();

    // 2. Fetch GPS Location
    await _fetchGPSLocation();

    // 3. Dispatch SOS SMS/WhatsApp to all contacts
    await _dispatchEmergencyAlerts();

    // 4. Vibrate for attention
    _vibrateAlert();

    notifyListeners();
  }

  Future<void> _startAudioEvidence() async {
    final started = await AudioEvidenceService.startRecording();
    _isRecordingAudio = started;
    notifyListeners();
  }

  Future<void> _stopAudioEvidence() async {
    _lastRecordingPath = await AudioEvidenceService.stopRecording();
    _isRecordingAudio = false;
    notifyListeners();
  }

  Future<void> _dispatchEmergencyAlerts() async {
    _dispatchedCount = await SOSDispatchService.dispatchToAllContacts(
      contacts: _contacts,
      position: _currentPosition,
    );
    notifyListeners();
  }

  Future<void> _fetchGPSLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever) {
          _currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
        }
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> _vibrateAlert() async {
    try {
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (hasVibrator) {
        // SOS pattern: 3 long bursts
        Vibration.vibrate(pattern: [0, 500, 200, 500, 200, 500]);
      }
    } catch (_) {}
  }

  void resolveAlert() async {
    // Stop audio recording when emergency is resolved
    await _stopAudioEvidence();
    _alertState = AlertState.idle;
    notifyListeners();
  }

  // --- Fake Call Simulator ---
  void triggerFakeCall({int delaySeconds = 3}) {
    triggerFakeCallWithName(callerName: 'Mom', delaySeconds: delaySeconds);
  }

  void triggerFakeCallWithName({required String callerName, int delaySeconds = 1}) {
    _fakeCallerName = callerName;
    notifyListeners();
    Future.delayed(Duration(seconds: delaySeconds), () {
      _isFakeCallActive = true;
      _vibrateAlert(); // Vibrate for realistic incoming call feel
      notifyListeners();
    });
  }

  void dismissFakeCall() {
    _isFakeCallActive = false;
    notifyListeners();
  }

  // --- Safety Timer ---
  void startSafetyTimer(int durationMinutes) {
    _isSafetyTimerRunning = true;
    _safetyTimerSecondsRemaining = durationMinutes * 60;
    notifyListeners();

    _safetyCountdownTimer?.cancel();
    _safetyCountdownTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_safetyTimerSecondsRemaining > 1) {
        _safetyTimerSecondsRemaining--;
        notifyListeners();
      } else {
        timer.cancel();
        _isSafetyTimerRunning = false;
        _safetyTimerSecondsRemaining = 0;
        notifyListeners();
        // Auto-trigger SOS when safety timer expires unconfirmed
        triggerSOSGracePeriod();
      }
    });
  }

  void cancelSafetyTimer() {
    _safetyCountdownTimer?.cancel();
    _isSafetyTimerRunning = false;
    _safetyTimerSecondsRemaining = 0;
    notifyListeners();
  }

  // --- 1-Tap Nearby Help Maps Launchers ---
  Future<void> launchNearbySearch(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedQuery');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> launchHelpline(String phoneNumber) async {
    final Uri telUrl = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(telUrl)) {
      await launchUrl(telUrl);
    }
  }

  @override
  void dispose() {
    _graceTimer?.cancel();
    _safetyCountdownTimer?.cancel();
    ShakeService.stopListening();
    AudioEvidenceService.dispose();
    super.dispose();
  }
}
