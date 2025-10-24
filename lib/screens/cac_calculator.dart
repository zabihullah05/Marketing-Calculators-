import 'package/ flutter/material. dart  ';
import '../services/pdf_ service.  dart';

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

    if (newCustomers > 0) {
      setState(() {
        _cac = cost / newCustomers;
      });
    } else {
      setState(() {
        _cac = null;
      });
    }
  }

  void _downloadPDF() {
    if (_cac != null) {
      PdfService.generateSingleCalculatorPdf(
        "CAC Calculator Result",
        {
          "Total Marketing Spend": _totalCostController.text,
          // ✅ Fixed this line (was incorrect `_customersController`)
          "New Customers": _newCustomersController.text,
          "CAC": _cac!.toStringAsFixed(2),
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

                // Input - Total Cost
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

                // Input - New Customers
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

                // Calculate Button
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

                // Result Display
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

                // Download PDF Button
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
    _totalCostController.dispose();
    _newCustomersController.dispose();
    super.dispose();
  }
}
