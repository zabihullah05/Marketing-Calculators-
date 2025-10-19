
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class ROASCalculator extends StatefulWidget {
  @override
  _ROASCalculatorState createState() => _ROASCalculatorState();
}

class _ROASCalculatorState extends State<ROASCalculator> {
  final _revenue_controller = TextEditingController();
  final _ad_spend_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final revenue = double.tryParse(_revenue_controller.text) ?? 0.0;
    final ad_spend = double.tryParse(_ad_spend_controller.text) ?? 0.0;
    double result = 0.0;
    if (ad_spend != 0) result = revenue / ad_spend;
    final result = result;
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('ROASCalculator', {
      'revenue': revenue,
      'ad_spend': ad_spend,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have a ROAS of {{result}}. Provide evaluation and 2 tips to improve ROAS.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
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
      appBar: AppBar(title: Text('ROAS Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Return On Ad Spend = Revenue / Ad Spend.'),
            SizedBox(height: 12),
            TextField(controller: _revenue_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Revenue')),
            TextField(controller: _ad_spend_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Ad Spend')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('ROASCalculator', {
                    'Revenue': _revenue_controller.text,
                    'Ad Spend': _ad_spend_controller.text,
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
