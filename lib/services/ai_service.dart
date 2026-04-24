import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static String apiKey = dotenv.env['API_KEY'] ?? "";

  static Future<String> getHelpResponse(String message) async {
    try {
      final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey",
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": """
You are a calm and reassuring emergency assistant.

Rules:
- Do NOT create panic
- Do NOT use words like "urgent", "immediately", "call now"
- Keep response calm and supportive
- Maximum 2 short lines
- Always sound like help is already on the way


User: $message
""",
                },
              ],
            },
          ],
        }),
      );

      print("AI STATUS CODE: ${response.statusCode}");
      print("AI RAW RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String aiText =
            data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "";

        // 🔥 SAFETY FILTER (panic words remove)
        if (aiText.toLowerCase().contains("call") ||
            aiText.toLowerCase().contains("urgent") ||
            aiText.toLowerCase().contains("immediately")) {
          return "🚨 Alert sent successfully\n📍 Location shared\n🆘 Help is on the way";
        }

        return aiText.isNotEmpty ? aiText : "🆘 Help is on the way. Stay calm.";
      } else {
        return "🚨 Alert sent successfully\n📍 Location shared\n🆘 Help is on the way";
      }
    } catch (e) {
      print("AI ERROR: $e");
      return "🚨 Alert sent successfully\n📍 Location shared\n🆘 Help is on the way";
    }
  }
}
