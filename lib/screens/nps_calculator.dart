
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class NPSCalculator extends StatefulWidget {
  @override
  _NPSCalculatorState createState() => _NPSCalculatorState();
}

class _NPSCalculatorState extends State<NPSCalculator> {
  final _promoters_controller = TextEditingController();
  final _detractors_controller = TextEditingController();
  final _total_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final promoters = double.tryParse(_promoters_controller.text) ?? 0.0;
    final detractors = double.tryParse(_detractors_controller.text) ?? 0.0;
    final total = double.tryParse(_total_controller.text) ?? 0.0;
    double result = 0.0;
    if (total != 0) result = ((promoters / total) * 100) - ((detractors / total) * 100);
    final result = result;
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('NPSCalculator', {
      'promoters': promoters,
      'detractors': detractors,
      'total': total,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have an NPS of {{result}}. Provide evaluation and 2 tips to improve NPS.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
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
      appBar: AppBar(title: Text('NPS Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Net Promoter Score = %Promoters - %Detractors.'),
            SizedBox(height: 12),
            TextField(controller: _promoters_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Promoters')),
            TextField(controller: _detractors_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Detractors')),
            TextField(controller: _total_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Total Responses')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('NPSCalculator', {
                    'Promoters': _promoters_controller.text,
                    'Detractors': _detractors_controller.text,
                    'Total Responses': _total_controller.text,
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
