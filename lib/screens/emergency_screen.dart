import 'package:flutter/material.dart';
import '../services/call_service.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  void makeSafeCall(BuildContext context, String number) async {
    try {
      await CallService.makeCall(number);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Call failed ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Help"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [

          // 🚑 Ambulance
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_hospital, color: Colors.red),
              title: const Text("Call Ambulance"),
              subtitle: const Text("102"),
              onTap: () => makeSafeCall(context, "102"),
            ),
          ),

          // 👮 Police
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_police, color: Colors.blue),
              title: const Text("Call Police"),
              subtitle: const Text("100"),
              onTap: () => makeSafeCall(context, "100"),
            ),
          ),

          // 🔥 Fire
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_fire_department, color: Colors.orange),
              title: const Text("Call Fire Brigade"),
              subtitle: const Text("101"),
              onTap: () => makeSafeCall(context, "101"),
            ),
          ),

          const SizedBox(height: 20),

          // 🔙 Back Button (important UX)
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back"),
          )
        ],
      ),
    );
  }
}