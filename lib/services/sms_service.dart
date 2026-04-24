import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class SmsService {

  static Future<void> sendSMS(String message, String number) async {

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: number,
      queryParameters: {
        'body': message,
      },
    );

    try {
      if (kIsWeb) {
        // ❌ SMS not supported on web
        print("SMS feature not supported on web");
        return;
      }

      // ✅ Mobile
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(
          smsUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        print("❌ Could not launch SMS");
      }

    } catch (e) {
      print("❌ SMS error: $e");
    }
  }
}