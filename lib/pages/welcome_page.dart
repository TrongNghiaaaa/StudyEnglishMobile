import 'package:flutter/material.dart';
import 'package:flutter_app_day1/pages/home_page.dart';
import 'package:flutter_app_day1/value/app_colors.dart';
import 'package:flutter_app_day1/value/app_text_style.dart';

class WelComePage extends StatelessWidget {
  const WelComePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome to',
                  style: AppTextStyle.display.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 48,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'English',
                  style: AppTextStyle.display.copyWith(
                    color: AppColors.textColorGrey500,
                    fontSize: 60,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  'Quote"',
                  style: AppTextStyle.headline.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 64),
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  fillColor: AppColors.whiteColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ),
                    );
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    size: 100,
                    color: AppColors.textColorGrey500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
