
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class GrossMarginCalculator extends StatefulWidget {
  @override
  _GrossMarginCalculatorState createState() => _GrossMarginCalculatorState();
}

class _GrossMarginCalculatorState extends State<GrossMarginCalculator> {
  final _revenue_controller = TextEditingController();
  final _cost_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final revenue = double.tryParse(_revenue_controller.text) ?? 0.0;
    final cost = double.tryParse(_cost_controller.text) ?? 0.0;
    double result = 0.0;
    if (revenue != 0) result = ((revenue - cost) / revenue) * 100;
    final result = result;
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('GrossMarginCalculator', {
      'revenue': revenue,
      'cost': cost,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have a Gross Margin of {{result}}%. Provide evaluation and 2 tips to improve margin.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
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
      appBar: AppBar(title: Text('GrossMargin Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gross Margin (%) = ((Revenue - Cost) / Revenue) * 100.'),
            SizedBox(height: 12),
            TextField(controller: _revenue_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Revenue')),
            TextField(controller: _cost_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Cost')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('GrossMarginCalculator', {
                    'Revenue': _revenue_controller.text,
                    'Cost': _cost_controller.text,
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
