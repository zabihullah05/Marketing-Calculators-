import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class CPCCalculator extends StatefulWidget {
  @override
  _CPCCalculatorState createState() => _CPCCalculatorState();
}

class _CPCCalculatorState extends State<CPCCalculator> {
  final _costController = TextEditingController();
  final _clicksController = TextEditingController();
  double? _cpc;

  void _calculateCPC() {
    final double cost = double.tryParse(_costController.text) ?? 0;
    final double clicks = double.tryParse(_clicksController.text) ?? 0;

    if (clicks > 0) {
      setState(() => _cpc = cost / clicks);
    } else {
      setState(() => _cpc = null);
    }
  }

  void _downloadPDF() {
    if (_cpc != null) {
      PdfService.generateSingleCalculatorPdf(
        "CPC Calculator Result",
        {
          "Total Cost": _costController.text,
          "Total Clicks": _clicksController.text,
          "CPC": _cpc!.toStringAsFixed(2),
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
        title: const Text("CPC Calculator"),
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
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Calculate your Cost Per Click by entering total cost and total clicks below.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _costController,
                  decoration: InputDecoration(
                    labelText: "Total Cost (\$)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateCPC,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate CPC"),
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
                      _cpc == null
                          ? "Your CPC will appear here."
                          : "Your CPC is \$${_cpc!.toStringAsFixed(2)}",
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
  _costController.dispose();
  _clicksController.dispose();
  super.dispose();
}
}
