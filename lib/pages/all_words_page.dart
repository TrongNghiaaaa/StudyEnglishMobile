import 'package:flutter/material.dart';
import 'package:flutter_app_day1/model/englist_today.dart';
import 'package:flutter_app_day1/pages/common/common_appbar.dart';
import 'package:flutter_app_day1/value/app_colors.dart';
import 'package:flutter_app_day1/value/app_text_style.dart';

class AllWordsPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllWordsPage({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,

        title: Text(
          'English Today',
          style: AppTextStyle.display.copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),

        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 3 / 2,
          children:
              words
                  .map(
                    (e) => Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(3, 2),
                          ),
                        ],
                        color: AppColors.cardContainerColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.noun ?? '',
                            style: AppTextStyle.title.copyWith(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
