import 'package:app/config/Config.dart';
import 'package:app/view/Home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getTemperatureConfig();
  runApp(MyApp());
}

void getTemperatureConfig() async {
  final prefs = await SharedPreferences.getInstance();

  Config.UPPER_LIMIT = prefs.getDouble('UPPER_LIMIT') ?? 20;
  Config.LOWER_LIMIT = prefs.getDouble('LOWER_LIMIT') ?? 0;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}
