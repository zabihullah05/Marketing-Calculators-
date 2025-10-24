import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class ShareOfVoiceCalculator extends StatefulWidget {
  @override
  _ShareOfVoiceCalculatorState createState() => _ShareOfVoiceCalculatorState();
}

class _ShareOfVoiceCalculatorState extends State<ShareOfVoiceCalculator> {
  final _brandSpendController = TextEditingController();
  final _totalMarketSpendController = TextEditingController();
  double? _sov;

  void _calculateSOV() {
    final brandSpend = double.tryParse(_brandSpendController.text) ?? 0;
    final totalSpend = double.tryParse(_totalMarketSpendController.text) ?? 0;

    if (totalSpend > 0) {
      setState(() {
        _sov = (brandSpend / totalSpend) * 100;
      });
    } else {
      setState(() {
        _sov = 0;
      });
    }
  }

  void _downloadPDF() {
    if (_sov != null) {
      PdfService.generateSingleCalculatorPdf(
        "Share of Voice Result",
        {
          "Brand Advertising Spend": _brandSpendController.text,
          "Total Market Advertising Spend": _totalMarketSpendController.text,
          "Share of Voice": "${_sov!.toStringAsFixed(2)}%",
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
        title: const Text("Share of Voice Calculator"),
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
                  "Calculate your brand’s Share of Voice (SOV) — your advertising share compared to competitors in the market.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _brandSpendController,
                  decoration: InputDecoration(
                    labelText: "Your Brand’s Advertising Spend (\$)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _totalMarketSpendController,
                  decoration: InputDecoration(
                    labelText: "Total Market Advertising Spend (\$)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateSOV,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate Share of Voice"),
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
                      _sov == null
                          ? "Your Share of Voice result will appear here."
                          : "Your Share of Voice is ${_sov!.toStringAsFixed(2)}%",
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
