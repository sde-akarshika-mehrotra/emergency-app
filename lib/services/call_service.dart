import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class CallService {
  static Future<void> makeCall(String number) async {
    final Uri callUri = Uri.parse("tel:$number");

    try {
      if (kIsWeb) {
        // ❌ Web does not support direct calling
        print("Call feature not supported on web");
        return;
      }

      // ✅ Mobile
      if (!await launchUrl(
        callUri,
        mode: LaunchMode.externalApplication,
      )) {
        print("❌ Could not launch dialer");
      }
    } catch (e) {
      print("❌ Call error: $e");
    }
  }
}