import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class WhatsAppService {
  static Future<void> sendWhatsApp(String message, String number) async {
    
    // ✅ format number
    if (!number.startsWith("91")) {
      number = "91$number";
    }

    final String encodedMessage = Uri.encodeComponent(message);

    // 🔹 Web URL (works everywhere)
    final Uri webUri = Uri.parse(
      "https://wa.me/$number?text=$encodedMessage",
    );

    // 🔹 App URL (mobile only)
    final Uri appUri = Uri.parse(
      "whatsapp://send?phone=$number&text=$encodedMessage",
    );

    try {
      if (kIsWeb) {
        // ✅ On web → always use browser
        await launchUrl(webUri, mode: LaunchMode.platformDefault);
      } else {
        // ✅ On mobile → try app first
        if (await canLaunchUrl(appUri)) {
          await launchUrl(appUri, mode: LaunchMode.externalApplication);
        } else {
          // fallback to browser
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      print("❌ WhatsApp error: $e");
    }
  }
}