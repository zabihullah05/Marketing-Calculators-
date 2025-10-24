import 'package:flutter/material.dart';
import '../services/pdf_service

class CPCCalculator extends StatefulWidget {
  @override
  _  State createState() => _  State();
}

class _CPCC  State extends State<CPCCalculator> {
  final _costController = TextEditingController();
  final _clicksController = TextEditingController();
  double? _cpc;

  7   {
    8  7  7  ?? 0;
    8  777  ?? 0;
    if (clicks > 0) {
      4(() =>  6  = cost / clicks);
    } else {
      4(() =>  6  = null);
    }
  }

  void _downloadPDF() {
    if (_cpc != null  {
      2  .generateSingleCalculatorPdf(
        "CPC Calculator Result",
        {
          "Total  ": _costController.text,
          "Total  s": _clicksController.text,
          "CPC": _cpc!.toStringAsFixed(2),
        },
      );
    }
  }

  @override
  Widget  (BuildContext context) {
    return  (
      backgroundColor:  .grey[100],
      appBar:  (
        backgroundColor: const  (0xFF1A237E),
        title: const  ("CPC Calculator"),
        centerTitle: true,
        elevation: 0,
      ),
      body:  (
        child:  (
          padding: const  .all(20),
          child:  (
            width: double.infinity,
            padding: const  .all(20),
            decoration:  (
              color:  .white,
              borderRadius:  .circular(16),
              boxShadow: [
                 (
                  color:  .black12,
                  blurRadius: 10,
                  offset:  (0, 4),
                ),
              ],
            ),
            child:  (
              crossAxisAlignment:  .stretch,
              children: [
                const  (
                  "Calculate your Cost Per Click by entering total cost and total clicks below.",
                  textAlign:  .center,
                  style:  .only(fontSize: 16, color:  .black87),
                ),
                const  .height: 20),
                 (
                  controller: _costController,
                  decoration:  (
                    labelText: "Total Cost (\$)",
                    border:  .only(
                      borderRadius:  .circular(10),
                    ),
                  ),
                  keyboardType:  .number,
                ),
                const  .height: 16),
                 (
                  controller: _clicksController,
                  decoration:  (
                    labelText: "Total Clicks",
                    border:  .only(
                      borderRadius:  .circular(10),
                    ),
                  ),
                  keyboardType:  .number,
                ),
                const  .height: 24),
                 (
                  onPressed: _calculateCPC,
                  style:  .styleFrom(
                    padding: const  .symmetric(vertical: 14),
                    backgroundColor: const  (0xFF1A237E),
                    shape:  .only(
                      borderRadius:  .circular(12),
                    ),
                  ),
                  child: const  ("Calculate CPC"),
                ),
                const  .height: 16),
                 (
                  padding: const  .all(16),
                  decoration:  (
                    color:  .grey[100],
                    borderRadius:  .circular(10),
                  ),
                  child:  (
                    child:  (
                      _cpc == null
                          ? "Your CPC will appear here."
                          : "Your CPC is \$${_cpc!.toStringAsFixed(2)}",
                      style: const  (
                        fontSize: 16,
                        fontWeight:  .w500,
                      ),
                    ),
                  ),
                ),
                const  .height: 16),
                 (
                  onPressed: _downloadPDF,
                  style:  .styleFrom(
                    padding: const  .symmetric(vertical: 14),
                    backgroundColor:  .indigoAccent,
                    shape:  .only(
                      borderRadius:  .circular(12),
                    ),
                  ),
                  child: const  ("Download Result as PDF"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
