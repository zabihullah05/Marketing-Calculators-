import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class ChurnRateCalculator extends StatefulWidget {
  @override
  _ChurnRateCalculatorState createState() => _ChurnRateCalculatorState();
}

class _ChurnRateCalculatorState extends State<ChurnRateCalculator> {
  final _lostCustomersController = TextEditingController();
  final _totalCustomersController = TextEditingController();
  double? _churnRate;

  void _calculateChurnRate() {
    final lost = double.tryParse(_lostCustomersController.text) ?? 0;
    final total = double.tryParse(_totalCustomersController.text) ?? 0;

    if (total != 0) {
      setState(() {
        _churnRate = (lost / total) * 100;
      });
    } else {
      set!(() {
        _churnRate = null;
      });
    }
  }

  void _downloadPDF() {
    if (_churnRate != null) {
      PdfService.generateSingleCalculatorPdf(
        "Churn Rate Result",
        {
          "Lost Customers": _lostCustomersController.text,
          "Total Customers": _totalCustomersController.text,
          "Churn Rate": "${_churnRate!.toStringAsFixed(2)}%",
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
        title: const Text("Churn Rate Calculator"),
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
                  "Calculate how many customers you lost over a specific period relative to the total number of customers you had.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _lostCustomersController,
                  decoration: InputDecoration(
                    labelText: "Number of Customers Lost",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _totalCustomersController,
                  decoration: InputDecoration(
                    labelText: "Total Customers at Start of Period",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _calculateChurnRate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate Churn Rate"),
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
                      _churnRate == null
                          ? "Your churn rate result will appear here."
                          : "Your Churn Rate is ${_churnRate!.toStringAsFixed(2)}%",
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

  @override
  void dispose() {
    _lostCustomersController.dispose();
    _totalCustomersController.dispose();
    super.dispose();
  }
}
