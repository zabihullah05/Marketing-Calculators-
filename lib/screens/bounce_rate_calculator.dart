
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class BounceRateCalculator extends StatefulWidget {
  @override
  _BounceRateCalculatorState createState() => _BounceRateCalculatorState();
}

class _BounceRateCalculatorState extends State<BounceRateCalculator> {
  final _single_controller = TextEditingController();
  final _total_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final single = double.tryParse(_single_controller.text) ?? 0.0;
    final total = double.tryParse(_total_controller.text) ?? 0.0;
    double result = 0.0;
    if (total != 0) result = (single / total) * 100;
    final result = result;
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('BounceRateCalculator', {
      'single': single,
      'total': total,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have a Bounce Rate of {{result}}%. Provide evaluation and 2 tips to reduce bounce rate.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
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
      appBar: AppBar(title: Text('BounceRate Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bounce Rate = (Single Page Sessions / Total Sessions) * 100.'),
            SizedBox(height: 12),
            TextField(controller: _single_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Single Page Sessions')),
            TextField(controller: _total_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Total Sessions')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('BounceRateCalculator', {
                    'Single Page Sessions': _single_controller.text,
                    'Total Sessions': _total_controller.text,
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
