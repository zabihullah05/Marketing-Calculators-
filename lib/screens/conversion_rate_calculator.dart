
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class ConversionRateCalculator extends StatefulWidget {
  @override
  _ConversionRateCalculatorState createState() => _ConversionRateCalculatorState();
}

class _ConversionRateCalculatorState extends State<ConversionRateCalculator> {
  final _conversions_controller = TextEditingController();
  final _visitors_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final conversions = double.tryParse(_conversions_controller.text) ?? 0.0;
    final visitors = double.tryParse(_visitors_controller.text) ?? 0.0;
    double result = 0.0;
    if (visitors != 0) result = (conversions / visitors) * 100;
    final result = result;
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('ConversionRateCalculator', {
      'conversions': conversions,
      'visitors': visitors,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have a Conversion Rate of {{result}}%. Provide evaluation and 2 tips to improve conversions.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
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
      appBar: AppBar(title: Text('ConversionRate Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Conversion Rate = (Conversions / Visitors) * 100.'),
            SizedBox(height: 12),
            TextField(controller: _conversions_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Conversions')),
            TextField(controller: _visitors_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Visitors')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('ConversionRateCalculator', {
                    'Conversions': _conversions_controller.text,
                    'Visitors': _visitors_controller.text,
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
