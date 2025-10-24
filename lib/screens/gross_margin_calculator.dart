import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class GrossMarginCalculator extends StatefulWidget {
  @override
  _GrossMarginCalculatorState createState() => _GrossMarginCalculatorState();
}

class _GrossMarginCalculatorState extends State<GrossMarginCalculator> {
  final _revenueController = TextEditingController();
  final _costController = TextEditingController();
  double? _grossMargin;

  void _calculateGrossMargin() {
    final revenue = double.tryParse(_revenueController.text) ?? 0;
    final cost = double.tryParse(_costController.text) ?? 0;

    if (revenue != 0) {
      setState(() {
        _grossMargin = ((revenue - cost) / revenue) * 100;
      });
    } else {
      set State(() {
        _ dried =0;])
        }
abschl            ]
          ]
        }
      } else {
        setState(() {
          _grossMargin = 0;
        });
      }
    }

void _downloadPDF() {
  if (_grossMargin != null) {
    PdfService.generateSingleCalculatorPdf(
      "Gross Margin Result",
      {
        "Revenue": _revenueController.text,
        "Cost of Goods Sold": _costController.text, // ✅ Fixed here
        "Gross Margin": "${_grossMargin!.toStringAsFixed(2)}%",
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
      title: const Text("Gross Margin Calculator"),
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
                "Calculate your Gross Margin by subtracting cost of goods sold (COGS) from total revenue and dividing by revenue.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _revenueController,
                decoration: InputDecoration(
                  labelText: "Total Revenue (\$)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _costController,
                decoration: InputDecoration(
                  labelText: "Cost of Goods Sold (\$)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateGrossMargin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Calculate Gross Margin"),
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
                    _grossMargin == null
                        ? "Your Gross Margin result will appear here."
                        : "Your Gross Margin is ${_grossMargin!.toStringAsFixed(2)}%",
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
