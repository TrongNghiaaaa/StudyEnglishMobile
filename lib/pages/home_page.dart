import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_day1/model/englist_today.dart';
import 'package:flutter_app_day1/pages/all_words_page.dart';
import 'package:flutter_app_day1/pages/common/common_appbar.dart';
import 'package:flutter_app_day1/pages/wiget/drawer_widget.dart';
import 'package:flutter_app_day1/pages/wiget/floating_action_button_widget.dart';
import 'package:flutter_app_day1/pages/wiget/indicator_widget.dart';
import 'package:flutter_app_day1/pakage/quote/quote.dart';
import 'package:flutter_app_day1/pakage/quote/quote_model.dart';
import 'package:flutter_app_day1/value/app_colors.dart';
import 'package:flutter_app_day1/value/app_text_style.dart';
import 'package:flutter_app_day1/value/share_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

// ADD: import nguồn quotes (repo/singleton bạn đã viết)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  bool isFavorite = false;
  QuoteModel? randomQuote; // ✅

  late final PageController _pageController;

  List<EnglishToday> words = [];
  // ADD: giữ danh sách quote tương ứng với từng word (cùng index)
  List<QuoteModel> wordQuotes = []; // <-- mỗi phần tử khớp với words[i]
  final Set<int> _favoriteIndexes = {}; // mỗi trang 1 index
  QuoteModel? randomQuotes;

  bool isFav(int index) {
    return _favoriteIndexes.contains(index);
  }

  void toggleFav(int index) {
    setState(() {
      if (isFav(index)) {
        _favoriteIndexes.remove(index);
      } else {
        _favoriteIndexes.add(index);
      }
    });
  }

  Widget _quoteShimmer(BuildContext context, Size size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        width: double.infinity,
        height: size.height * 0.1,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _cardShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // tim
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white24,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // chữ to (word)
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // quote 2-3 dòng
            Container(height: 14, color: Colors.white24),
            const SizedBox(height: 8),
            Container(height: 14, width: 220, color: Colors.white24),
            const SizedBox(height: 8),
            Container(height: 12, width: 100, color: Colors.white24), // author
          ],
        ),
      ),
    );
  }

  Widget _pageViewShimmer(BuildContext context, Size size) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder:
            (_, __) =>
                SizedBox(width: size.width * 0.9, child: _cardShimmer(context)),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: 3,
      ),
    );
  }

  Widget _indicatorShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
          (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
            width: i == 0 ? 16 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  List<int> fixedListRandom({int len = 1, int min = 0, int max = 100}) {
    if (min > max) {
      throw ArgumentError('min phải <= max'); // FIX
    }
    final range = max - min + 1; // FIX
    if (len < 0 || len > range) {
      throw ArgumentError('len phải trong 0..$range (không trùng)'); // FIX
    }
    final rnd = Random();
    final set = <int>{};
    while (set.length < len) {
      final val = min + rnd.nextInt(range); // FIX: [min, max]
      set.add(val); // đảm bảo không trùng
    }
    return set.toList();
  }

  // FIX: Lấy noun theo index hợp lệ rồi map sang EnglishToday

  bool isReloading = false;

  Future<void> getEnglishToday() async {
    setState(() => isReloading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int lenYourControlKey =
        prefs.getInt(ShareKeys.numberOfWords) ?? 5; // FIX: lấy số từ đã lưu

    final rans = fixedListRandom(
      len: lenYourControlKey,
      min: 0,
      max: nouns.length - 1,
    );
    final selected = rans.map((i) => nouns[i]).toList();

    final qts = <QuoteModel>[];
    for (final w in selected) {
      qts.add(Quotes().getByWord(w));
    }

    setState(() {
      words = selected.map((e) => EnglishToday(noun: e)).toList();
      wordQuotes = qts;
      randomQuote = Quotes().getRandom(); // ✅
      isReloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.9, // FIX: tạo khe 2 bên
    );
    getEnglishToday(); // FIX: gọi để có data trước khi build
  }

  @override
  void dispose() {
    _pageController.dispose(); // FIX

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rq = randomQuote;
    final size = MediaQuery.of(context).size;

    final isLoading =
        words.isEmpty ||
        wordQuotes.length != words.length; // ADD: chờ đủ cả 2 list

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
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, size: 32),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            isLoading
                ? Column(
                  children: [
                    _quoteShimmer(context, size),
                    const SizedBox(height: 8),
                    _pageViewShimmer(context, size),
                    _indicatorShimmer(),
                  ],
                )
                : Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.1,
                      child: Text(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        '"${rq?.content ?? 'No quotes available yet.'}"',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColors.textColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.5,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged:
                            (index) => setState(() {
                              _currentPage = index;
                            }),
                        itemCount: words.length, // FIX
                        padEnds: true,
                        itemBuilder: (context, index) {
                          // FIX: cắt chữ an toàn
                          final noun = words[index].noun ?? '';
                          final firstLetter = noun.isNotEmpty ? noun[0] : '';
                          final leftLetters =
                              noun.length > 1 ? noun.substring(1) : '';

                          // ADD: lấy quote tương ứng (đã chuẩn bị sẵn)
                          final quote = wordQuotes[index];
                          final quoteText =
                              (quote.content ??
                                  quote.quote ??
                                  ''); // ưu tiên content
                          final author = quote.author ?? '';

                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Material(
                              color: AppColors.cardContainerColor,
                              elevation: 4,
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              child: InkWell(
                                splashColor: Colors.black12,

                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                onTap: () async {
                                  toggleFav(index);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            toggleFav(index);
                                          },
                                          child: Icon(
                                            Icons.favorite,
                                            color:
                                                isFav(index)
                                                    ? Colors.red
                                                    : Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                            text: firstLetter,
                                            style: AppTextStyle.display
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 79,
                                                  shadows: const [
                                                    Shadow(
                                                      color: Colors.black38,
                                                      offset: Offset(3, 6),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                            children: [
                                              TextSpan(
                                                text: leftLetters,
                                                style: AppTextStyle.display
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 56,
                                                      shadows: const [
                                                        Shadow(
                                                          color: Colors.black38,
                                                          offset: Offset(3, 6),
                                                          blurRadius: 6,
                                                        ),
                                                      ],
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // ADD: hiển thị quote theo word
                                      Text(
                                        '"$quoteText"',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          letterSpacing: 0.5,
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      if (author.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          '— $author',
                                          textAlign: TextAlign.right,
                                          style: AppTextStyle.bodyMedium
                                              .copyWith(
                                                color: Colors.white70,
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                              ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Sau PageView.builder
                    _currentPage >= 5
                        ? showMoreButton(context, words)
                        : Center(
                          child: TikTokSlidingWindowIndicator(
                            totalCount: words.length, // tổng số trang
                            currentIndex:
                                _currentPage, // index hiện tại (onPageChanged cập nhật)
                            visibleCount: 5, // luôn chỉ 5 chấm hiển thị
                            activeColor: AppColors.secondaryColor,
                            inactiveColor: Colors.grey[500]!,
                          ),
                        ),
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButtonWidget(
        onReload: () async {
          await getEnglishToday();
        },
        isReloading: isReloading,
      ),
      drawer: DrawerWidget(
        wordFavorite:
            _favoriteIndexes.map((i) {
              final w = words[i];
              final q = wordQuotes[i];
              return EnglishToday(
                noun: w.noun,
                quote: (q.content ?? q.quote) ?? '',
                author: q.author ?? '',
              );
            }).toList(),
      ),
    );
  }
}

Widget showMoreButton(BuildContext context, List<EnglishToday> words) {
  return Material(
    color: AppColors.cardContainerColor,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: InkWell(
      borderRadius: BorderRadius.all(Radius.circular(24)),
      splashColor: Colors.black38,

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AllWordsPage(words: words); // truyền danh sách từ
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

        child: Text('Show more', style: AppTextStyle.label),
      ),
    ),
  );
}
