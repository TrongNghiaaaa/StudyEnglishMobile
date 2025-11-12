// lib/app/routes/app_pages.dart
import 'package:flutter/material.dart';
import 'package:flutter_app_day1/pages/all_words_page.dart';
import 'package:flutter_app_day1/pages/control_page.dart';
import 'package:flutter_app_day1/pages/favorite_page.dart';
import 'package:flutter_app_day1/pages/home_page.dart';
import 'package:flutter_app_day1/pages/welcome_page.dart';
import 'app_routes.dart';

class AppPages {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.controlPage:
        return MaterialPageRoute(builder: (_) => const ControlPage());
      case AppRoutes.allWordsPage:
        return MaterialPageRoute(builder: (_) => const AllWordsPage(words: []));
      case AppRoutes.favoritePage:
        return MaterialPageRoute(
          builder: (_) => const FavoritePage(wordFavorite: []),
        );
      case AppRoutes.welcomePage:
        return MaterialPageRoute(builder: (_) => const WelComePage());
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
