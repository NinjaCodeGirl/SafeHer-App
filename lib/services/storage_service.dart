import 'package:hive_flutter/hive_flutter.dart';
import '../models/emergency_contact.dart';

class StorageService {
  static const String contactsBoxName = 'safeher_contacts';
  static const String settingsBoxName = 'safeher_settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(contactsBoxName);
    await Hive.openBox(settingsBoxName);
  }

  // --- Emergency Contacts Operations ---
  static Box<String> get _contactsBox => Hive.box<String>(contactsBoxName);

  static List<EmergencyContact> getContacts() {
    final contacts = <EmergencyContact>[];
    for (var i = 0; i < _contactsBox.length; i++) {
      final jsonStr = _contactsBox.getAt(i);
      if (jsonStr != null) {
        try {
          contacts.add(EmergencyContact.fromJson(jsonStr));
        } catch (_) {}
      }
    }
    return contacts;
  }

  static Future<void> saveContact(EmergencyContact contact) async {
    final contacts = getContacts();
    final index = contacts.indexWhere((c) => c.id == contact.id);
    if (index >= 0) {
      await _contactsBox.putAt(index, contact.toJson());
    } else {
      await _contactsBox.add(contact.toJson());
    }
  }

  static Future<void> deleteContact(String id) async {
    final contacts = getContacts();
    final index = contacts.indexWhere((c) => c.id == id);
    if (index >= 0) {
      await _contactsBox.deleteAt(index);
    }
  }

  static Future<void> saveInitialDefaultContactsIfEmpty() async {
    if (_contactsBox.isEmpty) {
      final defaults = [
        EmergencyContact(
          id: '1',
          name: 'Mom',
          phoneNumber: '+919876543210',
          relationship: 'Parent',
          isPrimary: true,
        ),
        EmergencyContact(
          id: '2',
          name: 'Dad',
          phoneNumber: '+919876543211',
          relationship: 'Parent',
          isPrimary: false,
        ),
        EmergencyContact(
          id: '3',
          name: 'Best Friend',
          phoneNumber: '+919876543212',
          relationship: 'Friend',
          isPrimary: false,
        ),
      ];
      for (final c in defaults) {
        await saveContact(c);
      }
    }
  }

  // --- Settings Operations ---
  static Box get _settingsBox => Hive.box(settingsBoxName);

  static bool getBiometricEnabled() {
    return _settingsBox.get('biometric_enabled', defaultValue: false);
  }

  static Future<void> setBiometricEnabled(bool enabled) async {
    await _settingsBox.put('biometric_enabled', enabled);
  }

  static double getShakeSensitivity() {
    return _settingsBox.get('shake_sensitivity', defaultValue: 2.7); // G-force threshold
  }

  static Future<void> setShakeSensitivity(double sensitivity) async {
    await _settingsBox.put('shake_sensitivity', sensitivity);
  }

  static bool getShakeTriggerEnabled() {
    return _settingsBox.get('shake_trigger_enabled', defaultValue: true);
  }

  static Future<void> setShakeTriggerEnabled(bool enabled) async {
    await _settingsBox.put('shake_trigger_enabled', enabled);
  }
}
