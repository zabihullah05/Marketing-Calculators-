
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import 'screens_index.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String,String>> calculators = [
    {'name':'ROI Calculator','route':'ROICalculator'},
    {'name':'CTR Calculator','route':'CTRCalculator'},
    {'name':'CPC Calculator','route':'CPCCalculator'},
    {'name':'CPM Calculator','route':'CPMCalculator'},
    {'name':'Conversion Rate Calculator','route':'ConversionRateCalculator'},
    {'name':'Bounce Rate Calculator','route':'BounceRateCalculator'},
    {'name':'CLV Calculator','route':'CLVCalculator'},
    {'name':'CAC Calculator','route':'CACCalculator'},
    {'name':'ROAS Calculator','route':'ROASCalculator'},
    {'name':'Gross Margin Calculator','route':'GrossMarginCalculator'},
    {'name':'Engagement Rate Calculator','route':'EngagementRateCalculator'},
    {'name':'Email Open Rate Calculator','route':'EmailOpenRateCalculator'},
    {'name':'Email Click Rate Calculator','route':'EmailClickRateCalculator'},
    {'name':'CPL Calculator','route':'CPLCalculator'},
    {'name':'Video CPM Calculator','route':'VideoCPMCalculator'},
    {'name':'Share of Voice Calculator','route':'ShareOfVoiceCalculator'},
    {'name':'Churn Rate Calculator','route':'ChurnRateCalculator'},
    {'name':'Retention Rate Calculator','route':'RetentionRateCalculator'},
    {'name':'AOV Calculator','route':'AOVCalculator'},
    {'name':'NPS Calculator','route':'NPSCalculator'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketing Calculators', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
        centerTitle: true,
        backgroundColor: Color(0xFF1A237E),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF3949AB)]),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await PdfService.mergeAllToPdfAndShare();
                  },
                  icon: Icon(Icons.download),
                  label: Text('Download All Results as PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                showDialog(context: context, builder: (_) => AlertDialog(
                  title: Text('Ask AI Formula'),
                  content: Text('This will call Gemini API (placeholder). Add your API key in .env and implement gemini_service.'),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
                ));
              },
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(colors: [Color(0xFF3949AB).withOpacity(0.9), Color(0xFF1A237E).withOpacity(0.9)]),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.smart_toy, size: 36, color: Colors.white),
                    SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ask AI Formula', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Need a custom calculation? Tell the AI what you want.', style: TextStyle(color: Colors.white70)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: calculators.length,
                itemBuilder: (context, index) {
                  final item = calculators[index];
                  final name = item['name']!;
                  final route = item['route']!;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ScreensIndex.getScreen(route)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                      ),
                      child: Center(child: Text(name, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)))),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
