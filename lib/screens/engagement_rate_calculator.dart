
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class EngagementRateCalculator extends StatefulWidget {
  @override
  _EngagementRateCalculatorState createState() => _EngagementRateCalculatorState();
}

class _EngagementRateCalculatorState extends State<EngagementRateCalculator> {
  final _engagements_controller = TextEditingController();
  final _reach_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final engagements = double.tryParse(_engagements_controller.text) ?? 0.0;
    final reach = double.tryParse(_reach_controller.text) ?? 0.0;
    double result = 0.0;
    if (reach != 0) result = (engagements / reach) * 100;
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('EngagementRateCalculator', {
      'engagements': engagements,
      'reach': reach,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have an Engagement Rate of {{result}}%. Provide evaluation and 2 tips to increase engagement.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
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
      appBar: AppBar(title: Text('EngagementRate Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Engagement Rate = (Engagements / Reach) * 100.'),
            SizedBox(height: 12),
            TextField(controller: _engagements_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Engagements')),
            TextField(controller: _reach_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Reach')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('EngagementRateCalculator', {
                    'Engagements': _engagements_controller.text,
                    'Reach': _reach_controller.text,
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
