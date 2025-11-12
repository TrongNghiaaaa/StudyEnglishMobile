import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_app_day1/pakage/quote/quote_model.dart';
import 'package:flutter_app_day1/value/app_ui_path.dart';

class Quotes {
  static final Quotes _instance = Quotes._internal();
  static List<QuoteModel> datas = [];
  final String pathDataQuote = AppUI.quotesData;

  factory Quotes() => _instance;
  Quotes._internal();

  Future<void> getAll() async {
    final String response = await rootBundle.loadString(pathDataQuote);
    final List<dynamic> jsonData = jsonDecode(response);

    datas = jsonData.map((e) => QuoteModel.fromJson(e)).toList();
  }

  QuoteModel getByWord(String word) {
    final keyword = word.toLowerCase();
    final matches =
        datas.where((q) {
          final content = (q.content ?? '').toLowerCase();
          final quote = (q.quote ?? '').toLowerCase();
          return content.contains(keyword) || quote.contains(keyword);
        }).toList();

    final random = Random();
    if (matches.isNotEmpty) {
      return matches[random.nextInt(matches.length)];
    }
    if (datas.isNotEmpty) {
      return datas[random.nextInt(datas.length)];
    }
    return QuoteModel(content: 'No quotes found.', author: 'Unknown');
  }

  /// 🌟 Lấy ngẫu nhiên 1 quote (hoặc content)
  QuoteModel getRandom() {
    final random = Random();

    if (datas.isNotEmpty) {
      return datas[random.nextInt(datas.length)];
    }

    // nếu chưa load dữ liệu
    return QuoteModel(content: 'No quotes available yet.', author: 'Unknown');
  }
}
