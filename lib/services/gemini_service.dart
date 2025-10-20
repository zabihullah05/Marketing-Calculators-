import 'dart:convert' as json;
import 'package:http/http.dart' as http;

class GeminiService {
  // Gemini API base URL
  static const String baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

  // ⚠️ Replace with your actual Gemini API key
  static const String apiKey =AIzaSyBWFfDBzBSvWHfwDpc2yaqyehySHrWksOc;

  static Future<String> generateContent(String prompt) async {
    try {
      final url = Uri.parse("$baseUrl?key=$apiKey");

      final body = json.jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      });

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (res.statusCode == 200) {
        final js = json.jsonDecode(res.body);
        final text = js["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
            "No response from Gemini";
        return text;
      } else {
        return "Error: ${res.statusCode} - ${res.reasonPhrase}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
