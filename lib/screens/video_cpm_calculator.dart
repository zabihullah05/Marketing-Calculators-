import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class VideoCPMCalculator extends StatefulWidget {
  @override
  _VideoCPMCalculatorState createState() => _VideoCPMCalculatorState();
}

class _VideoCPMCalculatorState extends State<VideoCPMCalculator> {
  final _costController = TextEditingController();
  final _viewsController = TextEditingController();
  double? _videoCPM;

  void _calculateVideoCPM() {
    final cost = double.tryParse(_costController.text) ?? 0;
    final views = double.tryParse(_viewsController.text) ?? 0;

    if (views != 0) {
      setState(() {
        _videoCPM = (cost / views) * 1000;
      });
    } else {
      setState(() {
        _videoCPM = 0;
      });
    }
  }

  void _downloadPDF() {
    if (_videoCPM != null) {
      PDFService.generateAndDownload(
        title: "Video CPM Calculator Result",
        content:
            "Your Video CPM is ${_videoCPM!.toStringAsFixed(2)}.\n\nVideo CPM measures the cost per 1,000 video impressions — ideal for analyzing video ad campaign efficiency.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text("Video CPM Calculator"),
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
                  "Calculate the cost per 1,000 video impressions (Video CPM) for your video ad campaigns.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _costController,
                  decoration: InputDecoration(
                    labelText: "Total Campaign Cost (\$)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _viewsController,
                  decoration: InputDecoration(
                    labelText: "Total Video Views",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateVideoCPM,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate Video CPM"),
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
                      _videoCPM == null
                          ? "Your Video CPM result will appear here."
                          : "Your Video CPM is \$${_videoCPM!.toStringAsFixed(2)}",
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
