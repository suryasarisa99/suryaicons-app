import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suryaicons_app/screens/home.dart';
import 'package:suryaicons_app/utils/search.dart';

late final SharedPreferences? prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SearchManager();
  prefs = await SharedPreferences.getInstance();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: HomeScreen()),
    );
  }
}
