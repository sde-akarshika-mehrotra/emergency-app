import 'package:url_launcher/url_launcher.dart';

class CallService {
  static Future<void> makeCall(String number) async {
    final Uri callUri = Uri.parse("tel:$number");

    try {
      if (!await launchUrl(
        callUri,
        mode: LaunchMode.externalApplication, // 🔥 IMPORTANT FIX
      )) {
        print("❌ Could not launch dialer");
      }
    } catch (e) {
      print("❌ Call error: $e");
    }
  }
}