import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'gemini_service.dart';

class AIFormulaService {
  static Future<String> getFormulaHelp(String question) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      return "Error: Gemini API key missing. Please add it to your .env file.";
    }

    final prompt = """
You are an intelligent assistant specialized in solving and explaining formulas from any field — marketing, finance, physics, statistics, etc.
User asked: "$question"

Please:
1. Identify the correct formula(s) that apply.
2. Explain how to use them step-by-step.
3. If relevant, give a short example.

Keep your explanation clear and easy to follow.
""";

    return await GeminiService.query(prompt);
  }
}
