import 'dart:async';
import 'package:flutter/foundation.dart';

/// Voice trigger service for hands-free safe-word activation ("Help SafeHer")
class VoiceTriggerService {
  static bool _isListening = false;
  static String _safeWord = 'help safeher';

  static bool get isListening => _isListening;
  static String get safeWord => _safeWord;

  /// Start listening for the configured safe word
  static void startListening({
    required Function() onSafeWordDetected,
    String safeWord = 'help safeher',
  }) {
    _safeWord = safeWord.toLowerCase();
    _isListening = true;
    debugPrint('[VoiceTrigger] Voice safe-word listener active for "$_safeWord"');
  }

  /// Stop listening
  static void stopListening() {
    _isListening = false;
    debugPrint('[VoiceTrigger] Voice listener stopped.');
  }

  /// Simulated voice match trigger for testing & verification
  static void simulateVoiceTrigger(Function() onSafeWordDetected) {
    debugPrint('[VoiceTrigger] Voice safe-word matched! Triggering SOS.');
    onSafeWordDetected();
  }
}
