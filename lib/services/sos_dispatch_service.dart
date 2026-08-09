import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/emergency_contact.dart';

/// Service for dispatching emergency SOS alerts via SMS and WhatsApp.
/// Constructs messages with live Google Maps link and sends to all
/// trusted contacts. Zero-server, fully on-device.
class SOSDispatchService {
  /// Build the emergency message body with live Google Maps link.
  static String buildSOSMessage({Position? position}) {
    final timestamp = DateTime.now().toLocal().toString().substring(0, 19);
    String locationInfo;

    if (position != null) {
      final lat = position.latitude.toStringAsFixed(6);
      final lng = position.longitude.toStringAsFixed(6);
      final mapsLink = 'https://www.google.com/maps?q=$lat,$lng';
      locationInfo = '📍 Live Location: $mapsLink\nGPS: $lat, $lng';
    } else {
      locationInfo = '📍 Location: GPS unavailable, attempting again...';
    }

    return '🆘 SOS ALERT — SafeHer Emergency 🆘\n\n'
        'I need immediate help! This is an automated emergency alert '
        'sent from the SafeHer app.\n\n'
        '$locationInfo\n\n'
        '⏱ Triggered at: $timestamp\n'
        '🎙️ Audio evidence is being recorded locally.\n'
        '📡 Continuous GPS tracking is active.\n\n'
        'Please call me or send help to the location above. '
        'If I don\'t respond, call emergency services (112).';
  }

  /// Send SMS to a single phone number using device native SMS intent.
  static Future<bool> sendSMS({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      final encoded = Uri.encodeComponent(message);
      final Uri smsUri = Uri.parse('sms:$phoneNumber?body=$encoded');
      
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('[SOSDispatch] SMS send failed for $phoneNumber: $e');
      return false;
    }
  }

  /// Send WhatsApp message to a single phone number.
  static Future<bool> sendWhatsApp({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      // Clean the phone number (remove spaces, dashes, leading 0s)
      String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
      if (cleanNumber.startsWith('0')) {
        cleanNumber = '+91${cleanNumber.substring(1)}'; // Default to India (+91)
      }
      if (!cleanNumber.startsWith('+')) {
        cleanNumber = '+91$cleanNumber';
      }

      final encoded = Uri.encodeComponent(message);
      final Uri waUri = Uri.parse('https://wa.me/$cleanNumber?text=$encoded');

      if (await canLaunchUrl(waUri)) {
        await launchUrl(waUri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('[SOSDispatch] WhatsApp send failed for $phoneNumber: $e');
      return false;
    }
  }

  /// Dispatch SOS to ALL trusted contacts via SMS and WhatsApp.
  /// Returns count of successfully initiated dispatches.
  static Future<int> dispatchToAllContacts({
    required List<EmergencyContact> contacts,
    Position? position,
  }) async {
    if (contacts.isEmpty) {
      debugPrint('[SOSDispatch] No contacts to dispatch to.');
      return 0;
    }

    final message = buildSOSMessage(position: position);
    int successCount = 0;

    for (final contact in contacts) {
      // Try SMS first
      final smsSent = await sendSMS(
        phoneNumber: contact.phoneNumber,
        message: message,
      );
      if (smsSent) successCount++;

      // Also attempt WhatsApp
      await sendWhatsApp(
        phoneNumber: contact.phoneNumber,
        message: message,
      );
    }

    debugPrint('[SOSDispatch] Dispatched to $successCount/${contacts.length} contacts.');
    return successCount;
  }
}
