import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/emergency_contact.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  void _showAddContactDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final relationshipController = TextEditingController(text: 'Mother');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.darkBgSecondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add Trusted Contact', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBorder)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lavender)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBorder)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lavender)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: relationshipController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Relationship (e.g., Mother, Friend)',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBorder)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lavender)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lavenderBg,
                foregroundColor: AppColors.lavender,
                side: const BorderSide(color: AppColors.lavenderBorder),
              ),
              onPressed: () {
                if (nameController.text.trim().isNotEmpty && phoneController.text.trim().isNotEmpty) {
                  final newContact = EmergencyContact(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    phoneNumber: phoneController.text.trim(),
                    relationship: relationshipController.text.trim(),
                  );
                  Provider.of<AppProvider>(context, listen: false).addContact(newContact);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Contact', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trusted Contacts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('${provider.contacts.length} of 5 • Stored only on this device', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact List
              Expanded(
                child: provider.contacts.isEmpty
                    ? const Center(
                        child: Text(
                          'No trusted contacts added.\nTap + Add trusted contact below.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.contacts.length,
                        itemBuilder: (context, index) {
                          final contact = provider.contacts[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.glassCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                const SizedBox(width: 14),
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.lavenderBg,
                                  ),
                                  child: Center(
                                    child: Text(
                                      contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                                      style: const TextStyle(
                                        color: AppColors.lavender,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        contact.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${contact.relationship} • ${contact.phoneNumber}',
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.emergencyRedStart, size: 20),
                                  onPressed: () {
                                    provider.deleteContact(contact.id);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // Add Contact Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.lavenderBorder, width: 1.2),
                    backgroundColor: AppColors.lavenderBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => _showAddContactDialog(context),
                  icon: const Icon(Icons.add_rounded, color: AppColors.lavender),
                  label: const Text(
                    'Add trusted contact',
                    style: TextStyle(
                      color: AppColors.lavender,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Private by Design Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.glassCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline_rounded, color: AppColors.mintGreen, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Private by design', style: TextStyle(color: AppColors.mintGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                          SizedBox(height: 2),
                          Text('Your contacts never leave this device. No accounts, no cloud sync.', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
