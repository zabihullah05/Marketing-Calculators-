import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class CACCalculator extends StatefulWidget {
  @override
  _CACCalculatorState createState() => _CACCalculatorState();
}

class _CACCalculatorState extends State<CACCalculator> {
  final _totalCostController = TextEditingController();
  final _newCustomersController = TextEditingController();
  double? _cac;

  void _calculateCAC() {
    final cost = double.tryParse(_totalCostController.text) ?? 0;
    final newCustomers = double.tryParse(_newCustomersController.text) ?? 0;

    if (newCustomers != 0) {
      setState(() {
        _cac = cost / newCustomers;
      });
    } else {
      setState(() {
        _cac = 0;
      });
    }
  }

  void _downloadPDF() {
    if (_cac != null) {
      PdfService.generateAndDownload(
        title: "CAC Calculator Result",
        content:
            "Customer Acquisition Cost (CAC): \$${_cac!.toStringAsFixed(2)}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text("CAC Calculator"),
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
                  "Calculate your Customer Acquisition Cost by dividing your total marketing cost by the number of new customers acquired.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _totalCostController,
                  decoration: InputDecoration(
                    labelText: "Total Marketing Cost (\$)",
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
                    labelText: "Number of New Customers",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateCAC,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate CAC"),
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
                      _cac == null
                          ? "Your CAC result will appear here."
                          : "Your Customer Acquisition Cost is \$${_cac!.toStringAsFixed(2)}",
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
