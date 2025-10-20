import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = "AIzaSyBWFfDBzBSvWHfwDpc2yaqyehySHrWksOc"; // keep your key here

  static const String baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=";

  static Future<String> query(String prompt) async {
    final url = Uri.parse("$baseUrl$apiKey");

    final body = json.encode({
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
      final data = json.decode(res.body);
      final text =
          data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "";
      return text.trim();
    } else {
      throw Exception("Gemini API failed: ${res.statusCode}");
    }
  }
}
