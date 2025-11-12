import 'package:flutter/material.dart';
import 'package:flutter_app_day1/model/englist_today.dart';
import 'package:flutter_app_day1/pages/common/common_animation_text.dart';
import 'package:flutter_app_day1/pages/common/common_appbar.dart';
import 'package:flutter_app_day1/pages/home_page.dart';
import 'package:flutter_app_day1/value/app_colors.dart';
import 'package:flutter_app_day1/value/app_text_style.dart';
import 'package:flutter_app_day1/value/app_ui_path.dart';
import 'package:lottie/lottie.dart';

class FavoritePage extends StatefulWidget {
  final List<EnglishToday> wordFavorite;
  const FavoritePage({super.key, required this.wordFavorite});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const HomePage();
                },
              ),
            );
          },
        ),
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,

        title: Text(
          'Favorite Page',
          style: AppTextStyle.display.copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body:
          widget.wordFavorite.isNotEmpty
              ? Container(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: widget.wordFavorite.length,
                  itemBuilder: (context, index) {
                    final word = widget.wordFavorite[index];
                    final quote = word.quote ?? 'No quote available.';
                    final Color? cardColor;

                    if (index % 2 == 0) {
                      cardColor = AppColors.primaryColor;
                    } else {
                      cardColor = AppColors.cardContainerColor;
                    }
                    return Card(
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          word.noun ?? 'No word available.',
                          style: AppTextStyle.title.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          quote,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                        leading: const Icon(
                          Icons.favorite,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    );
                  },
                ),
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(AppUI.lottieLego, width: 200, height: 200),
                    const SizedBox(height: 20),
                    BouncyPerLetterText(
                      totalDuration: Duration(seconds: 2),
                      amplitude: 14,
                      perCharDelay: Duration(milliseconds: 50),
                      style: AppTextStyle.bodyMedium.copyWith(fontSize: 20),
                      text: 'You don\'t have favorite words.',
                    ),
                  ],
                ),
              ),
    );
  }
}
