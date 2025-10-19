
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class CLVCalculator extends StatefulWidget {
  @override
  _CLVCalculatorState createState() => _CLVCalculatorState();
}

class _CLVCalculatorState extends State<CLVCalculator> {
  final _avg_controller = TextEditingController();
  final _frequency_controller = TextEditingController();
  final _lifespan_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final avg = double.tryParse(_avg_controller.text) ?? 0.0;
    final frequency = double.tryParse(_frequency_controller.text) ?? 0.0;
    final lifespan = double.tryParse(_lifespan_controller.text) ?? 0.0;
    double result = avg * frequency * lifespan;
    final result = result;
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('CLVCalculator', {
      'avg': avg,
      'frequency': frequency,
      'lifespan': lifespan,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have a CLV of ${{result}}. Provide evaluation and 2 tips to increase CLV.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
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
      appBar: AppBar(title: Text('CLV Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Lifetime Value = Avg Purchase Value * Purchase Frequency * Customer Lifespan.'),
            SizedBox(height: 12),
            TextField(controller: _avg_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Avg Purchase Value')),
            TextField(controller: _frequency_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Purchase Frequency')),
            TextField(controller: _lifespan_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Customer Lifespan (years)')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('CLVCalculator', {
                    'Avg Purchase Value': _avg_controller.text,
                    'Purchase Frequency': _frequency_controller.text,
                    'Customer Lifespan (years)': _lifespan_controller.text,
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
