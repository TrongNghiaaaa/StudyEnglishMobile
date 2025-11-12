import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_day1/pakage/quote/quote.dart';
import 'package:flutter_app_day1/value/app_colors.dart';
import 'package:flutter_app_day1/value/app_page.dart';
import 'package:flutter_app_day1/value/app_routes.dart';
import 'package:flutter_app_day1/value/app_shimmer_loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Quotes().getAll();
  runApp(
    DevicePreview(
      enabled: true,
      tools: const [...DevicePreview.defaultTools],
      builder:
          (context) => AppShimmerTheme(
            data: AppShimmerThemeData(
              baseColor: AppColors.baseColor,
              highlightColor: AppColors.highlightColor,
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
      initialRoute: AppRoutes.welcomePage,
      onGenerateRoute: AppPages.onGenerateRoute,
      theme: ThemeData(primaryColor: Colors.lightBlue[300]),
      debugShowCheckedModeBanner: false,
    );
  }
}
