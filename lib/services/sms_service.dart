import 'package:url_launcher/url_launcher.dart';

class SmsService {

  static Future<void> sendSMS(String message, String number) async {

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: number,
      queryParameters: {
        'body': message,
      },
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      print("Could not launch SMS");
    }
  }
}
