
import 'dart:convert' as json;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static final _base = dotenv.env['GEMINI_API_BASE_URL'] ?? 'https://api.example-gemini.com/v1';
  static final _key = dotenv.env['GEMINI_API_KEY'] ?? '';

  static Future<String> query(String prompt) async {
    if (_key.isEmpty) throw Exception('GEMINI_API_KEY not set in .env');

    final url = Uri.parse('$_base/generate'); // placeholder path
    final body = json.encode({
      'prompt': prompt,
      'max_tokens': 120,
    });

    final res = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_key',
    }, body: body);

    if (res.statusCode == 200) {
      final js = json.decode(res.body);
      return js['text'] ?? js['result'] ?? 'No response body';
    } else {
      throw Exception('Gemini request failed with ${res.statusCode}');
    }
  }
}
