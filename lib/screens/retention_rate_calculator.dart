
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class RetentionRateCalculator extends StatefulWidget {
  @override
  _RetentionRateCalculatorState createState() => _RetentionRateCalculatorState();
}

class _RetentionRateCalculatorState extends State<RetentionRateCalculator> {
  final _end_controller = TextEditingController();
  final _new_controller = TextEditingController();
  final _starting_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final end = double.tryParse(_end_controller.text) ?? 0.0;
    final newUsers = double.tryParse(_new_controller.text) ?? 0.0;
    final starting = double.tryParse(_starting_controller.text) ?? 0.0;
    double result = 0.0;
    if (starting != 0) result = ((end - new) / starting) * 100;
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('RetentionRateCalculator', {
      'end': end,
      'new': new,
      'starting': starting,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have a Retention Rate of {{result}}%. Provide evaluation and 2 tips to improve retention.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
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
      appBar: AppBar(title: Text('RetentionRate Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Retention Rate = ((End Customers - New Customers) / Starting Customers) * 100.'),
            SizedBox(height: 12),
            TextField(controller: _end_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'End Customers')),
            TextField(controller: _new_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'New Customers')),
            TextField(controller: _starting_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Starting Customers')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('RetentionRateCalculator', {
                    'End Customers': _end_controller.text,
                    'New Customers': _new_controller.text,
                    'Starting Customers': _starting_controller.text,
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
