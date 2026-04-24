import 'dart:async';
import 'package:flutter/material.dart';
import '../services/emergency_controller.dart';

class EmergencyAlertScreen extends StatefulWidget {
  const EmergencyAlertScreen({super.key});

  @override
  State<EmergencyAlertScreen> createState() => _EmergencyAlertScreenState();
}

class _EmergencyAlertScreenState extends State<EmergencyAlertScreen> {
  bool visible = true;
  Timer? flashTimer;
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();

    // 🔴 FLASH EFFECT
    flashTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) {
        setState(() {
          visible = !visible;
        });
      }
    });

    // 🔁 AUTO REFRESH AI MESSAGE (IMPORTANT FIX)
    refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    flashTimer?.cancel();
    refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message =
        EmergencyController.aiMessage ??
        "🚨 Stay calm...\nSending alert...";

    return Scaffold(
      backgroundColor: visible ? Colors.red : Colors.black,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 120,
              color: Colors.white,
            ),

            const SizedBox(height: 20),

            const Text(
              "🚨 EMERGENCY ACTIVE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔙 EXIT BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "I'm Safe",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}