import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_day1/pages/landing_page.dart';
import 'package:flutter_app_day1/pakage/quote/quote.dart';
import 'package:flutter_app_day1/value/app_shimmer_loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Quotes().getAll(); // phải load dữ liệu trước
  runApp(
    DevicePreview(
      enabled: true,
      tools: const [...DevicePreview.defaultTools],
      builder:
          (context) => AppShimmerTheme(
            data: AppShimmerThemeData(
              baseColor: const Color(0xFF2A2B2E),
              highlightColor: const Color(0xFF3B3D42),
              period: const Duration(milliseconds: 1200),
              enabled: true,
            ),
            child: const MyApp(),
          ),
    ),
  );
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
