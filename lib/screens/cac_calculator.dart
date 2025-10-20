
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class CACCalculator extends StatefulWidget {
  @override
  _CACCalculatorState createState() => _CACCalculatorState();
}

class _CACCalculatorState extends State<CACCalculator> {
  final _cost_controller = TextEditingController();
  final _new_customers_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final cost = double.tryParse(_cost_controller.text) ?? 0.0;
    final new_customers = double.tryParse(_new_customers_controller.text) ?? 0.0;
    double result = 0.0;
    if (new_customers != 0) result = cost / new_customers
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('CACCalculator', {
      'cost': cost,
      'new_customers': new_customers,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have a CAC of ${{result}}. Provide evaluation and 2 tips to lower CAC.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
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
      appBar: AppBar(title: Text('CAC Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Acquisition Cost = Cost / New Customers.'),
            SizedBox(height: 12),
            TextField(controller: _cost_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Cost')),
            TextField(controller: _new_customers_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'New Customers')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('CACCalculator', {
                    'Cost': _cost_controller.text,
                    'New Customers': _new_customers_controller.text,
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
