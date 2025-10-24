import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class RetentionRateCalculator extends StatefulWidget {
  @override
  _RetentionRateCalculatorState createState() => _RetentionRateCalculatorState();
}

class _RetentionRateCalculatorState extends State<RetentionRateCalculator> {
  final _endCustomersController = TextEditingController();
  final _newCustomersController = TextEditingController();
  final _startingCustomersController = TextEditingController();
  double? _retentionRate;

  void _calculateRetentionRate() {
    final end = double.tryParse(_endCustomersController.text) ?? 0;
    final newCustomers = double.tryParse(_newCustomersController.text) ?? 0;
    final starting = double.tryParse(_startingCustomersController.text) ?? 0;

    if (starting != 0) {
      setState(() {
        _retentionRate = ((end - newCustomers) / starting) * 100;
      });
    } else {
      setState(() {
        _retentionRate = 0;
      });
    }
  }

  void _downloadPDF() {
    if (_retentionRate != null) {
      PdfService.generateAndDownload(
        title: "Retention Rate Calculator Result",
        content:
            "Your Customer Retention Rate is ${_retentionRate!.toStringAsFixed(2)}%. This measures how many customers remained with your business during the period.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text("Retention Rate Calculator"),
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
                  "Determine what percentage of customers stayed with your business over a certain time period.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _endCustomersController,
                  decoration: InputDecoration(
                    labelText: "Customers at End of Period",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _newCustomersController,
                  decoration: InputDecoration(
                    labelText: "New Customers Acquired",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _startingCustomersController,
                  decoration: InputDecoration(
                    labelText: "Customers at Start of Period",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateRetentionRate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate Retention Rate"),
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
                      _retentionRate == null
                          ? "Your retention rate result will appear here."
                          : "Your Retention Rate is ${_retentionRate!.toStringAsFixed(2)}%",
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
