import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class CLVCalculator extends StatefulWidget {
  @override
  _CLVCalculatorState createState() => _CLVCalculatorState();
}

class _CLVCalculatorState extends State<CLVCalculator> {
  final _avgPurchaseValueController = TextEditingController();
  final _purchaseFrequencyController = TextEditingController();
  final _customerLifespanController = TextEditingController();
  double? _clv;

  void _calculateCLV() {
    final avgPurchase = double.tryParse(_avgPurchaseValueController.text) ?? 0;
    final frequency = double.tryParse(_purchaseFrequencyController.text) ?? 0;
    final lifespan = double.tryParse(_customerLifespanController.text) ?? 0;

    setState(() {
      _clv = avgPurchase * frequency * lifespan;
    });
  }

  void _downloadPDF() {
    if (_clv != null) {
      pdfService.generateAndDownload(
        title: "CLV Calculator Result",
        content: "Customer Lifetime Value (CLV): \$${_clv!.toStringAsFixed(2)}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text("CLV Calculator"),
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
                  "Calculate the lifetime value of a customer by entering average purchase value, purchase frequency, and lifespan.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _avgPurchaseValueController,
                  decoration: InputDecoration(
                    labelText: "Average Purchase Value (\$)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _purchaseFrequencyController,
                  decoration: InputDecoration(
                    labelText: "Purchase Frequency (per year)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _customerLifespanController,
                  decoration: InputDecoration(
                    labelText: "Customer Lifespan (years)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateCLV,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate CLV"),
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
                      _clv == null
                          ? "Your CLV result will appear here."
                          : "Your Customer Lifetime Value is \$${_clv!.toStringAsFixed(2)}",
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
