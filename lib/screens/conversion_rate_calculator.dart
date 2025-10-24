import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class ConversionRateCalculator extends StatefulWidget {
  @override
  _ConversionRateCalculatorState createState() => _ConversionRateCalculatorState();
}

class _ConversionRateCalculatorState extends State<ConversionRateCalculator> {
  final _conversionsController = TextEditingController();
  final _totalVisitorsController = TextEditingController();
  double? _conversionRate;

  void _calculateConversionRate() {
    final conversions = double.tryParse(_conversionsController.text) ?? 0;
    final totalVisitors = double.tryParse(_totalVisitorsController.text) ?? 0;

    if (totalVisitors > 0) {
      setState(() => _conversionRate = (conversions / totalVisitors) * 100);
    } else {
      setState(() => _conversionRate = null);
    }
  }

  void _downloadPDF() {
  if (_conversionRate != null) {
    PdfService.generateSingleCalculatorPdf(
      "Conversion Rate Result",
      {
        "Conversions": _conversionsController.text,
        "Visitors": _visitorsController.text,
        "Conversion Rate": "${_conversionRate!.toStringAsFixed(2)}%",
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
        title: const Text("Conversion Rate Calculator"),
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
                  "Determine your Conversion Rate by entering the number of conversions and total visitors.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _conversionsController,
                  decoration: InputDecoration(
                    labelText: "Conversions",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _totalVisitorsController,
                  decoration: InputDecoration(
                    labelText: "Total Visitors",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateConversionRate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate Conversion Rate"),
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
                      _conversionRate == null
                          ? "Your Conversion Rate will appear here."
                          : "Your Conversion Rate is ${_conversionRate!.toStringAsFixed(2)}%",
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
