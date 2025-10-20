
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class CTRCalculator extends StatefulWidget {
  @override
  _CTRCalculatorState createState() => _CTRCalculatorState();
}

class _CTRCalculatorState extends State<CTRCalculator> {
  final _clicks_controller = TextEditingController();
  final _impressions_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final clicks = double.tryParse(_clicks_controller.text) ?? 0.0;
    final impressions = double.tryParse(_impressions_controller.text) ?? 0.0;
    double result = 0.0;
    if (impressions != 0) result = (clicks / impressions) * 100;
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('CTRCalculator', {
      'clicks': clicks,
      'impressions': impressions,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have a CTR of {{result}}%. Provide an evaluation and 2 quick tips to improve CTR.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
    try {
      final resp = await GeminiService.query(prompt);
      setState(() { _recommendation = resp; });
    } catch (e) {
      setState(() { _recommendation = 'AI recommendation unavailable.'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CTR Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Click Through Rate (CTR) = (Clicks / Impressions) * 100.'),
            SizedBox(height: 12),
            TextField(controller: _clicks_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Clicks')),
            TextField(controller: _impressions_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Impressions')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('CTRCalculator', {
                    'Clicks': _clicks_controller.text,
                    'Impressions': _impressions_controller.text,
                    'Result': _result!.toStringAsFixed(2),
                  });
                },
                icon: Icon(Icons.picture_as_pdf),
                label: Text('Download Result as PDF'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Color(0xFF1A237E)),
              ),
              SizedBox(height: 8),
              Text('AI Recommendation:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(_recommendation),
            ])))
          ],
        ),
        ),
      ),
    );
  }
}
