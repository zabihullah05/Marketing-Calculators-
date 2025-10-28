import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import 'screens_index.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ask_ai_formula_screen.dart';
class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> calculators = [
    {'name': 'ROI Calculator', 'route': 'ROICalculator'},
    {'name': 'CTR Calculator', 'route': 'CTRCalculator'},
    {'name': 'CPC Calculator', 'route': 'CPCCalculator'},
    {'name': 'CPM Calculator', 'route': 'CPMCalculator'},
    {'name': 'Conversion Rate Calculator', 'route': 'ConversionRateCalculator'},
    {'name': 'Bounce Rate Calculator', 'route': 'BounceRateCalculator'},
    {'name': 'CLV Calculator', 'route': 'CLVCalculator'},
    {'name': 'CAC Calculator', 'route': 'CACCalculator'},
    {'name': 'ROAS Calculator', 'route': 'ROASCalculator'},
    {'name': 'Gross Margin Calculator', 'route': 'GrossMarginCalculator'},
    {'name': 'Engagement Rate Calculator', 'route': 'EngagementRateCalculator'},
    {'name': 'Email Open Rate Calculator', 'route': 'EmailOpenRateCalculator'},
    {'name': 'Email Click Rate Calculator', 'route': 'EmailClickRateCalculator'},
    {'name': 'CPL Calculator', 'route': 'CPLCalculator'},
    {'name': 'Video CPM Calculator', 'route': 'VideoCPMCalculator'},
    {'name': 'Share of Voice Calculator', 'route': 'ShareOfVoiceCalculator'},
    {'name': 'Churn Rate Calculator', 'route': 'ChurnRateCalculator'},
    {'name': 'Retention Rate Calculator', 'route': 'RetentionRateCalculator'},
    {'name': 'AOV Calculator', 'route': 'AOVCalculator'},
    {'name': 'NPS Calculator', 'route': 'NPSCalculator'},
  ];

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Marketing Calculators',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        elevation: 4,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
              ),
            ),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await PdfService.mergeAllToPdfAndShare();
                },
                icon: const Icon(Icons.download),
                label: const Text('Download All Results as PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          // Ask AI Formula Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
  if (apiKey.isEmpty) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('API Key Missing'),
        content: const Text(
            'Please add your GEMINI_API_KEY in the .env file located in your project root to enable AI formulas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AskAIFormulaScreen()),
    );
  }
},
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF3949AB).withOpacity(0.9),
                      const Color(0xFF1A237E).withOpacity(0.9),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.smart_toy, size: 34, color: Colors.white),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ask AI Formula',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Need a custom calculation?\nAsk Gemini AI to help!',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Calculators Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.15,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: calculators.length,
                itemBuilder: (context, index) {
                  final item = calculators[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScreensIndex.getScreen(item['route']!),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 8)
                        ],
                      ),
                      child: Center(
                        child: Text(
                          item['name']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
