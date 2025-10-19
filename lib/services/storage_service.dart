
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String boxName = 'calculators_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static Future<void> saveCalculatorResult(String key, Map<String, dynamic> data) async {
    final box = Hive.box(boxName);
    await box.put(key, data);
  }

  static Map<String, dynamic>? getCalculatorResult(String key) {
    final box = Hive.box(boxName);
    return box.get(key) as Map<String, dynamic>?;
  }

  static Future<List<Map<String, dynamic>>> getAllSavedCalculations() async {
    final box = Hive.box(boxName);
    final keys = box.keys;
    final res = <Map<String, dynamic>>[];
    for (final k in keys) {
      res.add({'title': k.toString(), 'data': box.get(k)});
    }
    return res;
  }

  static Future<void> clearAll() async {
    final box = Hive.box(boxName);
    await box.clear();
  }
}
