import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class EmailClickRateCalculator extends StatefulWidget {
  @override
  _EmailClickRateCalculatorState createState() => _EmailClickRateCalculatorState();
}

class _EmailClickRateCalculatorState extends State<EmailClickRateCalculator> {
  final _clicksController = TextEditingController();
  final _emailsDeliveredController = TextEditingController();
  double? _clickRate;

  void _calculateClickRate() {
    final clicks = double.tryParse(_clicksController.text) ?? 0;
    final delivered = double.tryParse(_emailsDeliveredController.text) ?? 0;

    if (delivered != 0) {
      setState(() {
        _clickRate = (clicks / delivered) * 100;
      });
    } else {
      setState(() {
        _clickRate = 0;
      });
    }
  }

  void _downloadPDF() {
    if (_clickRate != null) {
      PDFService.generateAndDownload(
        title: "Email Click Rate Calculator Result",
        content: "Email Click Rate: ${_clickRate!.toStringAsFixed(2)}%",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text("Email Click Rate Calculator"),
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
                  "Measure how many people clicked links in your email campaign by dividing total clicks by delivered emails.",
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
                  controller: _emailsDeliveredController,
                  decoration: InputDecoration(
                    labelText: "Emails Delivered",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateClickRate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate Click Rate"),
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
                      _clickRate == null
                          ? "Your Email Click Rate result will appear here."
                          : "Your Email Click Rate is ${_clickRate!.toStringAsFixed(2)}%",
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
