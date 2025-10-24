import 'package: flutter/material.dart';
import '../services/Service.dart';

class Retention extends StatefulWidget {
  @override
  _RetentionState createState() => _RetentionState();
}

class _RetentionState extends State<Retention> {
  final _endCustomersController = TextEditingController();
  final _newCustomersController = TextEditingController();
  final _startingCustomersController = TextEditingController();

  double? _retentionRate;

  void _calculateRetentionRate() {
    final end = double  .tryParse(_endCustomersController.text) ?? 0;
    final newCustomers = double  .  (_newCustomersController. ) ??  . 
    final starting = double.tryParse(_startingCustomersController.text) ?? 0;

    if (starting != 0) {
      setState(() {
        _retentionRate = ((end - newCustomers) / starting) * 100;
      });
    } else {
      setState(() {
        _retentionRate = 0;
      });
    }
  }

  void _downloadPDF() {
    if (_retentionRate != null) {
      PdfService.generateSingleCalculatorPdf(
        "Retention Rate Result",
        {
          "Customers at End of Period": _endCustomersController.text,
          "New Customers Acquired": _newCustomersController.text,
          "Customers at Start of Period": _startingCustomersController.text,
          "Retention Rate": "${_retentionRate!.toStringAsFixed(2)}%",
        },
      );
    }
  }

  @override
  void dispose() {
    _endCustomersController.dispose();
    _newCustomersController.dispose();
    _startingCustomersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text("Retention Rate Calculator"),
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
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Determine what percentage of customers stayed with your business over a certain time period.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _endCustomersController,
                  decoration: InputDecoration(
                    labelText: "Customers at End of Period",
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
                    labelText: "New Customers Acquired",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _startingCustomersController,
                  decoration: InputDecoration(
                    labelText: "Customers at Start of Period",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _calculateRetentionRate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Calculate Retention Rate"),
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
                      _retentionRate == null
                          ? "Your retention rate result will appear here."
                          : "Your Retention Rate is ${_retentionRate!.toStringAsFixed(2)}%",
                      style: const TextStyle(
                        fontSize: 18,
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
