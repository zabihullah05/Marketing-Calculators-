import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class CPLCalculator extends StatefulWidget {
  @override
  _CPLCalculatorState createState() => _CPLCalculatorState();
}

class _CPLCalculatorState extends State<CPLCalculator> {
  final _totalCostController = TextEditingController();
  final _totalLeadsController = TextEditingController();
  double? _cpl;

  void _calculateCPL() {
    final totalCost = double.tryParse(_totalCostController.text) ?? 0;
    final totalLeads = double.tryParse(_totalLeadsController.text) ?? 0;

    if (totalLeads != 0) {
      setState(() {
        _cpl = totalCost / totalLeads;
      });
    } else {
      setState(() {
        _cpl = 0;
      });
    }
  }

  void _downloadPDF() {
    if (_cpl != null) {
      pdfService.generateAndDownload(
        title: "Cost Per Lead Calculator Result",
        content: "Your CPL is \$${_cpl!.toStringAsFixed(2)}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text("Cost Per Lead Calculator"),
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
                  "Calculate the average cost to acquire a lead by dividing your total marketing cost by total number of leads generated.",
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
                  controller: _totalLeadsController,
                  decoration: InputDecoration(
                    labelText: "Total Leads Generated",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateCPL,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate CPL"),
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
                      _cpl == null
                          ? "Your CPL result will appear here."
                          : "Your Cost Per Lead (CPL) is \$${_cpl!.toStringAsFixed(2)}",
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
