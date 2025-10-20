
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class CPLCalculator extends StatefulWidget {
  @override
  _CPLCalculatorState createState() => _CPLCalculatorState();
}

class _CPLCalculatorState extends State<CPLCalculator> {
  final _cost_controller = TextEditingController();
  final _leads_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final cost = double.tryParse(_cost_controller.text) ?? 0.0;
    final leads = double.tryParse(_leads_controller.text) ?? 0.0;
    double result = 0.0;
    if (leads != 0) result = cost / leads;
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('CPLCalculator', {
      'cost': cost,
      'leads': leads,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have a CPL of ${{result}}. Provide evaluation and 2 tips to reduce CPL.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
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
      appBar: AppBar(title: Text('CPL Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cost Per Lead = Cost / Leads.'),
            SizedBox(height: 12),
            TextField(controller: _cost_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Cost')),
            TextField(controller: _leads_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Leads')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('CPLCalculator', {
                    'Cost': _cost_controller.text,
                    'Leads': _leads_controller.text,
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
