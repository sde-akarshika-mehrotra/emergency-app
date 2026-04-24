import 'package:flutter/material.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final TextEditingController contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 📞 INPUT FIELD
            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: "Emergency Contact",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 20),

            // 💾 SAVE BUTTON
            ElevatedButton(
              onPressed: () async {
                String number = contactController.text.trim();

                if (number.isNotEmpty) {
                  await DatabaseService.saveContact(number);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("✅ Contact Saved to Database")),
                  );

                  contactController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("❌ Please enter a number")),
                  );
                }
              },
              child: const Text("Save"),
            ),

            const SizedBox(height: 20),

            // 🔥 TITLE
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Saved Contacts",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 📋 CONTACT LIST (IMPORTANT FIX)
            Expanded(
              child: StreamBuilder(
                stream: DatabaseService.getContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No contacts added yet"),
                    );
                  }

                  var docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading:
                              const Icon(Icons.phone, color: Colors.red),
                          title: Text(docs[index]['number']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}