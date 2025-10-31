
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await StorageService.init();
  runApp(MarketingCalculatorsApp());
}

class MarketingCalculatorsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FormulaAI',
      theme: ThemeData(
        primaryColor: Color(0xFF1A237E),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
