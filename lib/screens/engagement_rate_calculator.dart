import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class EngagementRateCalculator extends StatefulWidget {
  @override
  _EngagementRateCalculatorState createState() =>
      _EngagementRateCalculatorState();
}

class _EngagementRateCalculatorState extends State<EngagementRateCalculator> {
  final _engagementsController = TextEditingController();
  final _followersController = TextEditingController();
  double? _engagementRate;

  void _calculateEngagementRate() {
    final engagements = double.tryParse(_engagementsController.text) ?? 0;
    final followers = double.tryParse(_followersController.text) ?? 0;

    if (followers != 0) {
      setState(() {
        _engagementRate = (engagements / followers) * 100;
      });
    } else {
      setState(() {
        _engagementRate = 0;
      });
    }
  }

  void _downloadPDF() {
    if (_engagementRate != null) {
      PdfService.generateSingleCalculatorPdf(
        "Engagement Rate Result",
        {
          "Engagements": _engagementsController.text,
          "Followers": _followersController.text,
          "Engagement Rate": "${_engagementRate!.toStringAsFixed(2)}%",
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
        title: const Text("Engagement Rate Calculator"),
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
                  "Calculate how engaged your audience is by dividing total engagements (likes, comments, shares) by total followers.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _engagementsController,
                  decoration: InputDecoration(
                    labelText: "Total Engagements",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _followersController,
                  decoration: InputDecoration(
                    labelText: "Total Followers",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateEngagementRate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate Engagement Rate"),
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
                      _engagementRate == null
                          ? "Your Engagement Rate result will appear here."
                          : "Your Engagement Rate is ${_engagementRate!.toStringAsFixed(2)}%",
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
