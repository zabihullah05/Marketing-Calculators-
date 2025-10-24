import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  static Future<String> query(String prompt) async {
    if (apiKey.isEmpty) {
      return "API key not found. Please add your Gemini API key.";
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
        return data['candidates'][0]['content']['parts'][0]['text'] ??
            "No response received from Gemini AI.";
      } else {
        return "Gemini API error: ${response.statusCode} ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error contacting Gemini API: $e";
    }
  }
}
