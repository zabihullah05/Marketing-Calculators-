import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class BounceRateCalculator extends StatefulWidget {
  @override
  _BounceRateCalculatorState createState() => _BounceRateCalculatorState();
}

class _BounceRateCalculatorState extends State<BounceRateCalculator> {
  final _singlePageVisitsController = TextEditingController();
  final _totalEntriesController = TextEditingController();
  double? _bounceRate;

  void _calculateBounceRate() {
    final singlePageVisits =
        double.tryParse(_singlePageVisitsController.text) ?? 0;
    final totalEntries = double.tryParse(_totalEntriesController.text) ?? 0;

    if (totalEntries > 0) {
      setState(() {
        _bounceRate = (singlePageVisits / totalEntries) * 100;
      });
    } else {
      setState(() {
        _bounceRate = null;
      });
    }
  }

  void _downloadPDF() {
    if (_bounceRate != null) {
      PdfService.generateSingleCalculatorPdf(
        "Bounce Rate Result",
        {
          "Single Page Visits": _singlePageVisitsController.text,
          "Total Entries": _totalEntriesController.text,
          "Bounce Rate": "${_bounceRate!.toStringAsFixed(2)}%",
        },
      );
    }
  }

  @override
  void dispose() {
    _singlePageVisitsController.dispose();
    _totalEntriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text("Bounce Rate Calculator"),
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
                  "Calculate the percentage of single-page sessions (bounces) on your website.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _singlePageVisitsController,
                  decoration: InputDecoration(
                    labelText: "Single Page Visits",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _totalEntriesController,
                  decoration: InputDecoration(
                    labelText: "Total Entries",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateBounceRate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate Bounce Rate"),
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
                      _bounceRate == null
                          ? "Your Bounce Rate result will appear here."
                          : "Your Bounce Rate is ${_bounceRate!.toStringAsFixed(2)}%",
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
