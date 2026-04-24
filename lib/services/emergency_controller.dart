import 'package:flutter/material.dart';
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
      // 🔥 STEP 1: INSTANT UI
      aiMessage = "🚨 Stay calm...\nSending alert & sharing location...";

      if (!context.mounted) return;

      // ✅ WAIT for screen open (IMPORTANT FIX)
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const EmergencyAlertScreen(),
        ),
      );

      // 🔥 STEP 2: BACKGROUND WORK
      _runEmergencyTasks();

    } catch (e) {
      print("ERROR: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Emergency failed")),
        );
      }
    }
  }

  // 🔥 BACKGROUND TASKS (SEPARATE FUNCTION)
  static Future<void> _runEmergencyTasks() async {
    try {
      // 📍 LOCATION
      final location = await LocationService.getLocationLink();
      lastLocation = location;

      // 🤖 AI RESPONSE
      final aiResponse = await AIService.getHelpResponse(
        "User is in danger. Give short emergency steps.",
      );

      aiMessage = aiResponse.isNotEmpty
          ? aiResponse
          : "🚨 Alert sent successfully\n📍 Location shared\n🆘 Help is on the way";

      String message = "🚨 HELP! I am in danger.\nLocation: $location";

      // 📩 SMS
      for (String number in ["9451353833", "9936320468"]) {
        await SmsService.sendSMS(message, number);
      }

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