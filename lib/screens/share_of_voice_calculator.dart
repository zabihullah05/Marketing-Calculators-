
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';

class ShareOfVoiceCalculator extends StatefulWidget {
  @override
  _ShareOfVoiceCalculatorState createState() => _ShareOfVoiceCalculatorState();
}

class _ShareOfVoiceCalculatorState extends State<ShareOfVoiceCalculator> {
  final _brand_controller = TextEditingController();
  final _total_controller = TextEditingController();
  double? _result;
  String _recommendation = '';

  void _calculate() async {
    final brand = double.tryParse(_brand_controller.text) ?? 0.0;
    final total = double.tryParse(_total_controller.text) ?? 0.0;
    double result = 0.0;
    if (total != 0) result = (brand / total) * 100;
    setState(() { _result = result; _recommendation = 'Generating...'; });

    await StorageService.saveCalculatorResult('ShareOfVoiceCalculator', {
      'brand': brand,
      'total': total,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final prompt = 'I have a Share of Voice of {{result}}%. Provide evaluation and 2 tips to grow SOV.'.replaceAll('{result}', _result?.toStringAsFixed(2) ?? '0');
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
      appBar: AppBar(title: Text('ShareOfVoice Calculator'), backgroundColor: Color(0xFF1A237E)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Share of Voice = (Brand Mentions / Total Mentions) * 100.'),
            SizedBox(height: 12),
            TextField(controller: _brand_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Brand Mentions')),
            TextField(controller: _total_controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Total Mentions')),
            SizedBox(height: 18),
            ElevatedButton(onPressed: _calculate, child: Text('Calculate'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3949AB))),
            SizedBox(height: 18),
            if (_result != null) Card(child: Padding(padding: EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Result: ' + (_result is double ? _result!.toStringAsFixed(2) : _result.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.generateSingleCalculatorPdf('ShareOfVoiceCalculator', {
                    'Brand Mentions': _brand_controller.text,
                    'Total Mentions': _total_controller.text,
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
