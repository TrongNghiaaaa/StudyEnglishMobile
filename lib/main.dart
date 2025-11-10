import 'package:flutter/material.dart';
import 'package:flutter_app_day1/pages/landing_page.dart';
import 'package:flutter_app_day1/pakage/quote/quote.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Quotes().getAll(); // phải load dữ liệu trước
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
      theme: ThemeData(primaryColor: Colors.lightBlue[300]),
      debugShowCheckedModeBanner: false,
    );
  }
}
