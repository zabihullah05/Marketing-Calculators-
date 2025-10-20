
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class EmailOpenRateCalculator extends StatefulWidget {
  @override
  _EmailOpenRateCalculatorState createState() => _EmailOpenRateCalculatorState();
}

class _EmailOpenRateCalculatorState extends State<EmailOpenRateCalculator> {
  final _opens_controller = TextEditingController();
  final _sent_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final opens = double.tryParse(_opens_controller.text) ?? 0.0;
    final sent = double.tryParse(_sent_controller.text) ?? 0.0;
    double result = 0.0;
    if (sent != 0) result = (opens / sent) * 100;
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('EmailOpenRateCalculator', {
      'opens': opens,
      'sent': sent,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have an Email Open Rate of {{result}}%. Provide evaluation and 2 tips to improve open rates.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
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
      appBar: AppBar(title: Text('EmailOpenRate Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email Open Rate = (Opens / Emails Sent) * 100.'),
            SizedBox(height: 12),
            TextField(controller: _opens_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Opens')),
            TextField(controller: _sent_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Emails Sent')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('EmailOpenRateCalculator', {
                    'Opens': _opens_controller.text,
                    'Emails Sent': _sent_controller.text,
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
