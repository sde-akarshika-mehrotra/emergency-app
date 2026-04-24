import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> sendWhatsApp(String message, String number) async {

    // ✅ format number
    if (!number.startsWith("91")) {
      number = "91$number";
    }

    // 👉 Method 1 (direct WhatsApp app)
    final Uri appUri = Uri.parse(
      "whatsapp://send?phone=$number&text=${Uri.encodeComponent(message)}",
    );

    // 👉 Method 2 (browser fallback)
    final Uri webUri = Uri.parse(
      "https://wa.me/$number?text=${Uri.encodeComponent(message)}",
    );

    try {
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
      } else {
        // 🔥 fallback (THIS WILL WORK)
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print("❌ WhatsApp error: $e");
    }
  }
}