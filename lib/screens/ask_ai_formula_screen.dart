import 'package:flutter/material.dart';
import '../services/ai_formula_service.dart';

class AskAIFormulaScreen extends StatefulWidget {
  @override
  _AskAIFormulaScreenState createState() => _AskAIFormulaScreenState();
}

class _AskAIFormulaScreenState extends State<AskAIFormulaScreen> {
  final _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _askAI() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _loading = true;
      _response = null;
    });

    final answer = await AIFormulaService.getFormulaHelp(question);

    setState(() {
      _loading = false;
      _response = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ask AI Formula"),
        backgroundColor: const Color(0xFF1A237E),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Type your question or formula query",
                hintText: "e.g., How to calculate ROI from revenue and cost?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _askAI,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Ask AI"),
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (_response != null && !_loading)
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _response!,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
