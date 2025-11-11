import 'package:flutter/material.dart';
import 'package:flutter_app_day1/model/englist_today.dart';
import 'package:flutter_app_day1/pages/control_page.dart';
import 'package:flutter_app_day1/pages/favorite_page.dart';
import 'package:flutter_app_day1/pages/wiget/app_button.dart';
import 'package:flutter_app_day1/value/app_colors.dart';

import '../../value/app_text_style.dart';

class DrawerWidget extends StatelessWidget {
  final List<EnglishToday> wordFavorite;

  final VoidCallbackAction? onTap;
  const DrawerWidget({super.key, required this.wordFavorite, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your mind",
              style: AppTextStyle.bodyMedium.copyWith(
                color: Colors.black,
                fontSize: 38,
              ),
            ),
            AppButton(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ControlPage();
                    },
                  ),
                  (route) => false,
                );
              },
              label: "your control",
            ),
            const SizedBox(height: 12),
            AppButton(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return FavoritePage(wordFavorite: wordFavorite);
                    },
                  ),
                  (route) => false,
                );
              },
              label: "your favorite",
            ),
          ],
        ),
      ),
    );
  }
}
