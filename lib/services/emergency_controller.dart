import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'ai_service.dart';
import 'location_service.dart';
import '../screens/emergency_alert_screen.dart';
import 'sms_service.dart';
import 'whatsapp_service.dart';
import 'call_service.dart';

class EmergencyController {
  static String? aiMessage;
  static String? lastLocation;

  static Future<void> triggerEmergency(BuildContext context) async {
    print("🔥 TRIGGER EMERGENCY CALLED");

    try {
      aiMessage = "🚨 Stay calm...\nProcessing emergency...";

      if (!context.mounted) return;

      // ✅ SAFE NAVIGATION FIRST
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const EmergencyAlertScreen(),
        ),
      );

      // ❌ WEB SAFETY CHECK
      if (kIsWeb) {
        aiMessage = "🚨 Demo mode active (web)\nSome features disabled";
        print("Web mode: skipping emergency services");
        return;
      }

      // 🔥 RUN MOBILE TASKS ONLY
      await _runEmergencyTasks();

    } catch (e) {
      print("ERROR: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Emergency failed")),
        );
      }
    }
  }

  // 🔥 MOBILE ONLY TASKS
  static Future<void> _runEmergencyTasks() async {
    try {
      final location = await LocationService.getLocationLink();
      lastLocation = location;

      final aiResponse = await AIService.getHelpResponse(
        "User is in danger. Give short emergency steps.",
      );

      aiMessage = aiResponse.isNotEmpty
          ? aiResponse
          : "🚨 Alert sent\n📍 Location shared";

      String message = "🚨 HELP! I am in danger.\nLocation: $location";

      // 📩 SMS (mobile only)
      await SmsService.sendSMS(message, "9451353833");

      // 💬 WhatsApp
      await WhatsAppService.sendWhatsApp(message, "9451353833");

      // 📞 Call
      await CallService.makeCall("9451353833");

      print("✅ Emergency actions completed");

    } catch (e) {
      print("❌ Background error: $e");
    }
  }
}