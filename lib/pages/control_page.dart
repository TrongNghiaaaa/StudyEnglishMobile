import 'package:flutter/material.dart';
import 'package:flutter_app_day1/pages/common/common_appbar.dart';
import 'package:flutter_app_day1/pages/home_page.dart';
import 'package:flutter_app_day1/value/app_colors.dart';
import 'package:flutter_app_day1/value/app_text_style.dart';
import 'package:flutter_app_day1/value/share_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  int _numberOfWords = 5;
  double _sliderValue = 5.0;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    initDefaultValue();
  }

  initDefaultValue() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _numberOfWords = prefs.getInt(ShareKeys.numberOfWords) ?? 5;
      _sliderValue = (prefs.getInt(ShareKeys.numberOfWords) ?? 5).toDouble();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        elevation: 0,
        title: Text(
          'Your control',
          style: AppTextStyle.display.copyWith(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        leading: InkWell(
          onTap: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setInt(ShareKeys.numberOfWords, _numberOfWords);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const HomePage();
                },
              ),
            );
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'How many words at once?',
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium.copyWith(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: size.height * 0.02),

            Text(
              _numberOfWords.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyle.body.copyWith(
                fontSize: 130,
                fontWeight: FontWeight.bold,
                color: AppColors.cardContainerColor,
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              subtitle: Slider(
                activeColor: AppColors.cardContainerColor,
                value: _sliderValue.toInt().toDouble(),
                min: 5,
                max: 100,
                divisions: 95,
                label: _sliderValue.toString(),
                onChanged: (double v) {
                  setState(() {
                    _numberOfWords = v.toInt();
                    _sliderValue = v;
                  });
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'slide to set',
                  style: AppTextStyle.body.copyWith(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
