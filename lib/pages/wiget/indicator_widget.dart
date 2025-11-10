import 'package:flutter/material.dart';

class TikTokSlidingWindowIndicator extends StatefulWidget {
  final int totalCount; // tổng số page
  final int currentIndex; // index hiện tại từ PageView
  final int visibleCount; // số chấm hiển thị tối đa (mặc định 5)
  final Color activeColor;
  final Color inactiveColor;

  // Kích thước mỗi chấm
  final double dotHeight;
  final double inactiveWidth;
  final double activeWidth;
  final double spacing; // khoảng cách giữa các chấm
  final Duration duration;
  final Curve curve;

  const TikTokSlidingWindowIndicator({
    super.key,
    required this.totalCount,
    required this.currentIndex,
    this.visibleCount = 5,
    this.activeColor = const Color(0xFF00E5FF),
    this.inactiveColor = const Color(0xFF9E9E9E),
    this.dotHeight = 8,
    this.inactiveWidth = 8,
    this.activeWidth = 24,
    this.spacing = 8,
    this.duration = const Duration(milliseconds: 260),
    this.curve = Curves.easeOut,
  });

  @override
  State<TikTokSlidingWindowIndicator> createState() =>
      _TikTokSlidingWindowIndicatorState();
}

class _TikTokSlidingWindowIndicatorState
    extends State<TikTokSlidingWindowIndicator> {
  late final ScrollController _scroll;
  int _windowStart = 0; // vị trí bắt đầu cửa sổ đang hiển thị

  // Chiều rộng “một item” dùng để cuộn (xấp xỉ theo width nhỏ nhất)
  double get _itemExtent => widget.inactiveWidth + widget.spacing;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
    _windowStart = _computeWindowStart(widget.currentIndex);
  }

  @override
  void didUpdateWidget(covariant TikTokSlidingWindowIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newStart = _computeWindowStart(widget.currentIndex);
    if (newStart != _windowStart) {
      _windowStart = newStart;
      // cuộn dải chấm đến vị trí cửa sổ mới
      final target = _windowStart * _itemExtent;
      _scroll.animateTo(target, duration: widget.duration, curve: widget.curve);
    }
  }

  int _computeWindowStart(int current) {
    // Nếu tổng ≤ visibleCount: không cần cửa sổ
    if (widget.totalCount <= widget.visibleCount) return 0;

    final half = widget.visibleCount ~/ 2; // với 5 → half = 2
    // Giữ current ở vị trí giữa (index 2) khi có thể:
    final rawStart = current - half;

    // Clamp vào phạm vi hợp lệ: [0 .. total - visible]
    return rawStart.clamp(0, widget.totalCount - widget.visibleCount);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.totalCount == 0) return const SizedBox.shrink();

    // Nếu ít hơn/ bằng visibleCount: hiển thị đủ, canh giữa bằng Row
    if (widget.totalCount <= widget.visibleCount) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.totalCount, (i) {
          final isActive = i == widget.currentIndex;
          return _buildDot(isActive);
        }),
      );
    }

    // Nhiều hơn visibleCount: ListView ngang cuộn bằng ScrollController
    return SizedBox(
      height: widget.dotHeight,
      // Chiều rộng ~ 5 item (để nó giống “chỉ có 5 chấm”)
      width:
          widget.visibleCount * _itemExtent +
          (widget.activeWidth - widget.inactiveWidth),
      child: ListView.builder(
        controller: _scroll,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.totalCount,
        itemBuilder: (context, i) {
          final isActive = i == widget.currentIndex;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
            child: AnimatedContainer(
              duration: widget.duration,
              curve: widget.curve,
              width: isActive ? widget.activeWidth : widget.inactiveWidth,
              height: widget.dotHeight,
              decoration: BoxDecoration(
                color:
                    isActive
                        ? widget.activeColor
                        : widget.inactiveColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(widget.dotHeight),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
      child: AnimatedContainer(
        duration: widget.duration,
        curve: widget.curve,
        width: isActive ? widget.activeWidth : widget.inactiveWidth,
        height: widget.dotHeight,
        decoration: BoxDecoration(
          color:
              isActive
                  ? widget.activeColor
                  : widget.inactiveColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(widget.dotHeight),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }
}
