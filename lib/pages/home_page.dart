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
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // -------------------------------
  // State (đổi tên tường minh)
  // -------------------------------
  int _currentPageIndex = 0;
  bool _isReloading = false;

  late final PageController _pageController;

  /// Danh sách word đã nhồi kèm quote/author (tránh dùng 2 list song song).
  List<EnglishToday> _wordCards = [];

  /// Set các từ đã yêu thích (lưu theo chính noun để không lệch index khi reload).
  final Set<String> _favoriteWordSet = {};

  /// Câu quote ngẫu nhiên cho header.
  QuoteModel? _randomHeaderQuote;

  /// Local cache prefs
  late SharedPreferences _prefs;

  // -------------------------------
  // Lifecycle
  // -------------------------------
  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);

    // Load SharedPreferences & favorites trước, rồi mới load dữ liệu
    SharedPreferences.getInstance().then((p) {
      _prefs = p;
      _favoriteWordSet
        ..clear()
        ..addAll(_prefs.getStringList(ShareKeys.favoriteWords) ?? []);
      _loadRandomWordCards(); // sau khi có favorites trong bộ nhớ
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // -------------------------------
  // Helpers: Random & Persist
  // -------------------------------
  List<int> _uniqueRandomIndexes({
    required int length,
    int min = 0,
    required int max,
  }) {
    if (min > max) {
      throw ArgumentError('min phải <= max');
    }
    final range = max - min + 1;
    if (length < 0 || length > range) {
      throw ArgumentError('length phải trong [0..$range] (không trùng)');
    }
    final rnd = Random();
    final set = <int>{};
    while (set.length < length) {
      set.add(min + rnd.nextInt(range));
    }
    return set.toList();
  }

  Future<void> _saveFavorites() async {
    await _prefs.setStringList(
      ShareKeys.favoriteWords,
      _favoriteWordSet.toList(),
    );
  }

  // -------------------------------
  // Loading dữ liệu chính
  // -------------------------------
  Future<void> _loadRandomWordCards() async {
    if (!mounted) return;
    setState(() => _isReloading = true);

    // giả lập chờ API
    await Future.delayed(const Duration(milliseconds: 500));

    final wordCount = _prefs.getInt(ShareKeys.numberOfWords) ?? 5;
    final indexes = _uniqueRandomIndexes(
      length: wordCount,
      min: 0,
      max: nouns.length - 1,
    );
    final selectedNouns = indexes.map((i) => nouns[i]).toList();

    // Nhồi quote/author vào EnglishToday (tránh 2 list song song)
    final composed = <EnglishToday>[];
    for (final w in selectedNouns) {
      final q = Quotes().getByWord(w);
      composed.add(
        EnglishToday(
          noun: w,
          quote: (q.content ?? q.quote) ?? '',
          author: q.author ?? '',
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      _wordCards = composed;
      _randomHeaderQuote = Quotes().getRandom();
      _isReloading = false;
    });
  }

  // -------------------------------
  // Favorite logic (theo noun)
  // -------------------------------
  bool _isFavoriteByIndex(int index) {
    if (index < 0 || index >= _wordCards.length) return false;
    final noun = _wordCards[index].noun ?? '';
    return noun.isNotEmpty && _favoriteWordSet.contains(noun);
  }

  void _toggleFavoriteByIndex(int index) {
    if (index < 0 || index >= _wordCards.length) return;
    final noun = _wordCards[index].noun ?? '';
    if (noun.isEmpty) return;

    setState(() {
      if (_favoriteWordSet.contains(noun)) {
        _favoriteWordSet.remove(noun);
      } else {
        _favoriteWordSet.add(noun);
      }
    });
    _saveFavorites();
  }

  // -------------------------------
  // Shimmer widgets (theo theme dark)
  // -------------------------------
  Widget _buildQuoteShimmer(Size size) {
    final base = Colors.grey.shade800;
    final hi = Colors.grey.shade600;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: hi,
      child: Container(
        width: double.infinity,
        height: size.height * 0.1,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildCardShimmer() {
    final base = Colors.grey.shade800;
    final hi = Colors.grey.shade600;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: hi,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            Container(height: 14, color: Colors.white24),
            const SizedBox(height: 8),
            Container(height: 14, width: 220, color: Colors.white24),
            const SizedBox(height: 8),
            Container(height: 12, width: 100, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _buildPageViewShimmer(Size size) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder:
            (_, __) =>
                SizedBox(width: size.width * 0.9, child: _buildCardShimmer()),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: 3,
      ),
    );
  }

  Widget _buildIndicatorShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.indicatorBaseColor,
      highlightColor: AppColors.indicatorHighlightColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
          (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
            width: i == 0 ? 16 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.indicatorBaseColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------
  // Build
  // -------------------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerQuote = _randomHeaderQuote;
    final isLoading = _isReloading || _wordCards.isEmpty;

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
      drawer: DrawerWidget(
        wordFavorite:
            _wordCards
                .where(
                  (w) => w.noun != null && _favoriteWordSet.contains(w.noun!),
                )
                .map((w) {
                  // đã có quote/author trong EnglishToday rồi, nhưng nếu muốn sync lại:
                  final q = Quotes().getByWord(w.noun!);
                  return EnglishToday(
                    noun: w.noun,
                    quote: (q.content ?? q.quote) ?? w.quote ?? '',
                    author: q.author ?? w.author ?? '',
                  );
                })
                .toList(),
      ),
      floatingActionButton: FloatingActionButtonWidget(
        onReload: _loadRandomWordCards,
        isReloading: _isReloading,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            isLoading
                ? Column(
                  children: [
                    _buildQuoteShimmer(size),
                    const SizedBox(height: 8),
                    RepaintBoundary(child: _buildPageViewShimmer(size)),
                    _buildIndicatorShimmer(),
                  ],
                )
                : Column(
                  children: [
                    // Header quote
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.1,
                      child: Text(
                        '"${headerQuote?.content ?? 'No quotes available yet.'}"',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColors.textColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // PageView word cards
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.5,
                      child: PageView.builder(
                        controller: _pageController,
                        padEnds: true,
                        itemCount: _wordCards.length,
                        onPageChanged: (i) {
                          if (!mounted) return;
                          setState(() => _currentPageIndex = i);
                        },
                        itemBuilder: (context, index) {
                          final word = _wordCards[index];
                          final noun = word.noun ?? '';
                          final firstLetter = noun.isNotEmpty ? noun[0] : '';
                          final leftLetters =
                              noun.length > 1 ? noun.substring(1) : '';
                          final quoteText = word.quote ?? '';
                          final author = word.author ?? '';

                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Material(
                              color: AppColors.cardContainerColor,
                              elevation: 4,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => _toggleFavoriteByIndex(index),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Like button (góc phải)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: LikeButton(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          size: 42,
                                          isLiked: _isFavoriteByIndex(index),
                                          onTap: (isLiked) async {
                                            _toggleFavoriteByIndex(index);
                                            return !isLiked;
                                          },
                                          circleColor: const CircleColor(
                                            start: AppColors.likeCircleStart,
                                            end: AppColors.likeCircleEnd,
                                          ),
                                          bubblesColor: const BubblesColor(
                                            dotPrimaryColor:
                                                AppColors.likeDotPrimary,
                                            dotSecondaryColor:
                                                AppColors.likeDotSecondary,
                                          ),
                                          likeBuilder:
                                              (bool isLiked) => Icon(
                                                Icons.favorite,
                                                color:
                                                    isLiked
                                                        ? AppColors
                                                            .likeCircleEnd
                                                        : AppColors.whiteColor,
                                                size: 42,
                                              ),
                                        ),
                                      ),

                                      // Word (đầu to + phần còn lại)
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            text: firstLetter,
                                            style: AppTextStyle.display
                                                .copyWith(
                                                  color: AppColors.whiteColor,
                                                  fontSize: 79,
                                                  shadows: const [
                                                    Shadow(
                                                      color:
                                                          AppColors.shadowColor,
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
                                                      color:
                                                          AppColors.whiteColor,
                                                      fontSize: 56,
                                                      shadows: const [
                                                        Shadow(
                                                          color:
                                                              AppColors
                                                                  .shadowColor,
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

                                      // Quote
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
                                                color: AppColors.whiteColor
                                                    .withOpacity(0.7),
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

                    // Indicator / Show more
                    _currentPageIndex >= 5
                        ? _buildShowMoreButton(context, _wordCards)
                        : Center(
                          child: TikTokSlidingWindowIndicator(
                            totalCount: _wordCards.length,
                            currentIndex: _currentPageIndex,
                            visibleCount: 5,
                            activeColor: AppColors.secondaryColor,
                            inactiveColor: Colors.grey[500]!,
                          ),
                        ),
                  ],
                ),
      ),
    );
  }

  // Nút "Show more"
  Widget _buildShowMoreButton(BuildContext context, List<EnglishToday> words) {
    return Material(
      color: AppColors.cardContainerColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        splashColor: Colors.black38,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AllWordsPage(words: words)),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text('Show more', style: AppTextStyle.label),
        ),
      ),
    );
  }
}
