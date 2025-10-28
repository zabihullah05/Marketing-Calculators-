import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static final String baseUrl = dotenv.env['GEMINI_BASE_URL'] ??
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  static Future<String> query(String prompt) async {
    if (apiKey.isEmpty) {
      return "⚠️ Gemini API key not found in .env file.";
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {"parts": [{"text": prompt}]}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['candidates'] != null &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'][0]['text'] != null) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          return "⚠️ Unexpected response format from Gemini API.";
        }
      } else {
        return "Gemini API error: ${response.statusCode} ${response.reasonPhrase}";
      }
    } catch (e) {
      return "❌ Error contacting Gemini API: $e";
    }
  }
}
