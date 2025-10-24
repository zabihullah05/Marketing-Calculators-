import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class EmailOpenRateCalculator extends StatefulWidget {
  @override
  _EmailOpenRateCalculatorState createState() => _EmailOpenRateCalculatorState();
}

class _EmailOpenRateCalculatorState extends State<EmailOpenRateCalculator> {
  final _emailsOpenedController = TextEditingController();
  final _emailsSentController = TextEditingController();
  double? _openRate;

  void _calculateOpenRate() {
    final opened = double.tryParse(_emailsOpenedController.text) ?? 0;
    final sent = double.tryParse(_emailsSentController.text) ?? 0;

    if (sent != 0) {
      setState(() {
        _openRate = (opened / sent) * 100;
      });
    } else {
      setState(() {
        _openRate = 0;
      });
    }
  }

  void _downloadPDF() {
    if (_openRate != null) {
      PdfService().generateAndDownload(
        title: "Email Open Rate Calculator Result",
        content: "Email Open Rate: ${_openRate!.toStringAsFixed(2)}%",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text("Email Open Rate Calculator"),
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
                  "Measure how many recipients opened your emails by dividing total opened emails by total sent emails.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailsOpenedController,
                  decoration: InputDecoration(
                    labelText: "Emails Opened",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailsSentController,
                  decoration: InputDecoration(
                    labelText: "Emails Sent",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateOpenRate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate Open Rate"),
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
                      _openRate == null
                          ? "Your Email Open Rate result will appear here."
                          : "Your Email Open Rate is ${_openRate!.toStringAsFixed(2)}%",
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
