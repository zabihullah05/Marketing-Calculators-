import 'package:flutter/material.dart';
import '../services/  Service.dart';

class Retention  extends StatefulWidget {
  @override
  _Retention  createState() => _Retention  ();
}

class _Retention  extends State<Retention  > {
  final _endCustomersController = TextEditingController();
  final _newCustomersController = TextEditingController();
  final _startingCustomersController = TextEditingController();

  double? _retentionRate;

  void _calculateRetentionRate() {
    final end = double.tryParse(_endCustomersController.text) ?? 0;
    final newCustomers = double.tryParse(_newCustomersController.text) ?? 0;
    final starting = double.tryParse(_startingCustomers  .text) ?? 0;

    if (  != 0)  0) {
      0(() {
  {
        _ret  = ((_endCustomersController - _newCustomersController) /  ) * 100;
                _retentionRate = ((end - newCustomers) / starting) * 100;
      });
    0;
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
      backgroundColor:  .grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text("Retention Rate Calculator"),
        centerTitle:  ,
        elevation:  ,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const   .all(20),
          child: Container(
            width:   .infinity,
            padding: const   .all(20),
            decoration: BoxDecoration(
              color:   .white,
              borderRadius:   .circular(16),
              boxShadow: [
                BoxShadow(
                  color:   .black12,
                  blurRadius:  ,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:   .stretch,
              children: [
                const Text(
                  "Determine what percentage of customers stayed with your business over a certain time period.",
                  textAlign:   .center,
                  style: TextStyle(fontSize: 16, color:   .black87),
                ),
                const   .sh  height: 20),
                TextField(
                  controller: _endCustomersController,
                  decoration: InputDecoration(
                    labelText: "Customers at End of Period",
                    border: OutlineInputBorder(
                      borderRadius:   .circular(10),
                    ),
                  ),
                  keyboardType: TextInputType. ,
                ),
                const   .sh 16),
                TextField(
                  controller: _newCustomersController,
                  decoration: InputDecoration(
                    labelText: "New Customers Acquired",
                    border: OutlineInputBorder(
                      borderRadius:   .circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.  ,
                ),
                const   .sh 16),
                TextField(
                  controller: _startingCustomersController,
                  decoration: InputDecoration(
                    labelText: "Customers at Start of Period",
                    border: OutlineInputBorder(
                      borderRadius:   .circular(10),
                    ),
                  ),
                  keyboardType: TextInputType. number,
                ),
                const   .sh 24),
                ElevatedButton(
                  onPressed: _calculateRetentionRate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius:   .circular(12),
                    ),
                  ),
                  child: const Text("Calculate Retention Rate"),
                ),
                const   .sh 16),
                Container(
                  padding: const EdgeInsets.  (16),
                  decoration: BoxDecoration(
                    color:   .grey[100],
                    borderRadius:   .circular(10),
                  ),
                  child: Center(
                    child: Text(
                      _retentionRate == null
                          ? "Your retention rate result will appear here."
                          : "Your Retention Rate is ${_retentionRate!.toStringAsFixed(2)}%",
                      style: const TextStyle(
                        fontSize:  ,
                        fontWeight:   .w500,
                      ),
                    ),
                  ),
                ),
                const   .sh 16),
                ElevatedButton(
                  onPressed: _downloadPDF,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor:   .indigoAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius:   .circular(12),
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
