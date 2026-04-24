import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/location_service.dart';
import '../services/sms_service.dart';
import '../services/call_service.dart';
import '../services/whatsapp_service.dart';
import '../services/database_service.dart';

class PanicButton extends StatefulWidget {
  const PanicButton({super.key});

  @override
  State<PanicButton> createState() => _PanicButtonState();
}

class _PanicButtonState extends State<PanicButton> {
  bool isLoading = false;

  final List<String> contacts = [
    "9451353833",
    "9936320468",
    "8468068213",
    "9867597544",
    "6745799339",
    "9764870099",
    "9845793736",
  ];

  Future<void> handleSOS() async {
    if (!mounted || isLoading) return;

    setState(() => isLoading = true);

    // 📳 HAPTIC FEEDBACK
    HapticFeedback.heavyImpact();

    try {
      // 📍 GET LOCATION
      final locationLink = await LocationService.getLocationLink();

      // ❌ LOCATION ERROR
      if (locationLink.contains("disabled") ||
          locationLink.contains("denied")) {
        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Location issue: $locationLink")),
        );
        return;
      }

      final message =
          "🚨 HELP! I am in danger.\nLocation: $locationLink";

      setState(() => isLoading = false);

      if (!mounted) return;

      // 🔥 ACTION SHEET
      showModalBottomSheet(
        context: context,
        builder: (bottomContext) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "🚨 Emergency Actions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // 📩 SMS
                ListTile(
                  leading: const Icon(Icons.sms, color: Colors.blue),
                  title: const Text("Send SMS to All Contacts"),
                  onTap: () async {
                    Navigator.pop(bottomContext);

                    for (String number in contacts) {
                      await SmsService.sendSMS(message, number);
                    }

                    // 🔥 SAVE ALERT (SMS)
                    await DatabaseService.saveAlert(
                      "$locationLink | SMS",
                    );

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("✅ SMS sent")),
                    );
                  },
                ),

                // 📞 CALL
                ListTile(
                  leading: const Icon(Icons.call, color: Colors.green),
                  title: const Text("Call First Contact"),
                  onTap: () async {
                    Navigator.pop(bottomContext);

                    await CallService.makeCall(contacts[0]);

                    // 🔥 SAVE ALERT (CALL)
                    await DatabaseService.saveAlert(
                      "$locationLink | CALL",
                    );
                  },
                ),

                // 💬 WHATSAPP
                ListTile(
                  leading: const Icon(Icons.message, color: Colors.green),
                  title: const Text("Send WhatsApp"),
                  onTap: () async {
                    Navigator.pop(bottomContext);

                    await WhatsAppService.sendWhatsApp(
                      message,
                      contacts[0],
                    );

                    // 🔥 SAVE ALERT (WHATSAPP)
                    await DatabaseService.saveAlert(
                      "$locationLink | WHATSAPP",
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Something went wrong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : handleSOS,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.6),
              blurRadius: 25,
              spreadRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "SOS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
        ),
      ),
    );
  }
}