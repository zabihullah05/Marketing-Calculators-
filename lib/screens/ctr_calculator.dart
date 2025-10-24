import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class CTRCalculator extends StatefulWidget {
  @override
  _CTRCalculatorState createState() => _CTRCalculatorState();
}

class _CTRCalculatorState extends State<CTRCalculator> {
  final _clicksController = TextEditingController();
  final _impressionsController = TextEditingController();
  double? _ctr;

  void _calculateCTR() {
    final clicks = double.tryParse(_clicksController.text) ?? 0;
    final impressions = double.tryParse(_impressionsController.text) ?? 0;
    if (impressions > 0) {
      setState(() => _ctr = (clicks / impressions) * 100);
    } else {
      setState(() => _ctr = null);
    }
  }

  void _downloadPDF() {
    if (_ctr != null) {
      PdfService.generateSingleCalculatorPdf(
  'CTR Calculator',
  {
    'Clicks': clicksController.text,
    'Impressions': impressionsController.text,
    'CTR': ctrResult.toStringAsFixed(2) + '%',
  },
);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text("CTR Calculator"),
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
              boxShadow: [
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
                  "Calculate your Click-Through Rate by entering total clicks and total impressions below.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _clicksController,
                  decoration: InputDecoration(
                    labelText: "Total Clicks",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _impressionsController,
                  decoration: InputDecoration(
                    labelText: "Total Impressions",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateCTR,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate CTR"),
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
                      _ctr == null
                          ? "Your CTR will appear here."
                          : "Your CTR is ${_ctr!.toStringAsFixed(2)}%",
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
