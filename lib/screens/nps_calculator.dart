import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class NPSCalculator extends StatefulWidget {
  @override
  _NPSCalculatorState createState() => _NPSCalculatorState();
}

class _NPSCalculatorState extends State<NPSCalculator> {
  final _promotersController = TextEditingController();
  final _detractorsController = TextEditingController();
  final _totalResponsesController = TextEditingController();

  double? _npsScore;

  void _calculateNPS() {
    final promoters = double.tryParse(_promotersController.text) ?? 0;
    final detractors = double.tryParse(_detractorsController.text) ?? 0;
    final total = double.tryParse(_totalResponsesController.text) ?? 0;

    setState(() {
      if (total > 0) {
        _npsScore = ((promoters - detractors) / total) * 100;
      } else {
        _npsScore = 0;
      }
    });
  }

  void _downloadPDF() {
    if (_npsScore != null) {
      PdfService.generateSingleCalculatorPdf(
        "NPS Calculator Result",
        {
          "Promoters": _promotersController.text,
          "Detractors": _detractorsController.text,
          "Total Responses": _totalResponsesController.text,
          "NPS Score": "${_npsScore!.toStringAsFixed(2)}",
        },
      );
    }
  }

  @override
  void dispose() {
    _promotersController.dispose();
    _detractorsController.dispose();
    _totalResponsesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text("NPS Calculator"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Calculate your Net Promoter Score (NPS) to measure customer satisfaction and loyalty.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _promotersController,
                  decoration: InputDecoration(
                    labelText: "Number of Promoters (Score 9-10)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _detractorsController,
                  decoration: InputDecoration(
                    labelText: "Number of Detractors (Score 0-6)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _totalResponsesController,
                  decoration: InputDecoration(
                    labelText: "Total Responses",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateNPS,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate NPS"),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      _npsScore == null
                          ? "Your NPS result will appear here."
                          : "Your NPS is ${_npsScore!.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _downloadPDF,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.indigoAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Download Result as PDF"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
