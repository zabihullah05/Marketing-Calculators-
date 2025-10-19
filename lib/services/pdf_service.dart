
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'storage_service.dart';

class PdfService {
  static Future<void> generateSingleCalculatorPdf(String title, Map<String, String> fields) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(build: (pw.Context context) => pw.Column(children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 12),
        ...fields.entries.map((e) => pw.Row(children: [pw.Text('${e.key}: '), pw.Text('${e.value}')])).toList(),
      ])),
    );
    final bytes = await pdf.save();
    await Printing.sharePdf(bytes: bytes, filename: '$title.pdf');
  }

  static Future<void> mergeAllToPdfAndShare() async {
    final all = await StorageService.getAllSavedCalculations();
    final pdf = pw.Document();
    for (final entry in all) {
      pdf.addPage(pw.Page(build: (pw.Context context) => pw.Column(children: [
        pw.Text(entry['title'] ?? 'Calculator', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        ...((entry['data'] as Map<String, dynamic>).entries.map((e) => pw.Text('${e.key}: ${e.value}')).toList()),
        pw.SizedBox(height: 12),
      ])));
    }
    final bytes = await pdf.save();
    await Printing.sharePdf(bytes: bytes, filename: 'All_Calculators_${DateTime.now().toIso8601String()}.pdf');
  }
}
