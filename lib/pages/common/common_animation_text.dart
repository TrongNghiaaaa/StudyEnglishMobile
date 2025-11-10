import 'dart:math' as math;
import 'package:flutter/material.dart';

class BouncyPerLetterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration totalDuration; // tổng thời gian 1 vòng animation
  final double amplitude; // biên độ nhảy (px)
  final Duration perCharDelay; // độ trễ giữa các ký tự

  const BouncyPerLetterText({
    super.key,
    required this.text,
    this.style,
    this.totalDuration = const Duration(seconds: 2),
    this.amplitude = 14,
    this.perCharDelay = const Duration(milliseconds: 90),
  });

  @override
  State<BouncyPerLetterText> createState() => _BouncyPerLetterTextState();
}

class _BouncyPerLetterTextState extends State<BouncyPerLetterText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant BouncyPerLetterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalDuration != widget.totalDuration) {
      _controller
        ..duration = widget.totalDuration
        ..reset()
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _offsetYForChar(int i, double tNorm) {
    // tNorm: 0..1 theo thời gian controller
    // Tạo "pha" lệch cho từng ký tự để chạy tuần tự
    final delay =
        i *
        widget.perCharDelay.inMilliseconds /
        widget.totalDuration.inMilliseconds;
    // wrap về [0,1)
    final phase = (tNorm - delay) % 1.0;
    // Hàm chuyển động dạng "bật lên rồi rơi xuống"
    // Dùng sin với window (0..0.5 là đi lên-xuống, còn lại = 0)
    // Bạn có thể thay bằng curve tùy thích.
    if (phase < 0 || phase > 0.5) return 0.0;

    // Map 0..0.5 to 0..pi
    final x = (phase / 0.5) * math.pi;
    final dy = math.sin(x) * widget.amplitude; // lên xuống
    return -dy; // âm là đi lên
  }

  @override
  Widget build(BuildContext context) {
    final chars = widget.text.characters.toList(); // handle unicode properly
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value; // 0..1
        return Wrap(
          alignment: WrapAlignment.start,
          children: [
            for (int i = 0; i < chars.length; i++)
              Transform.translate(
                offset: Offset(0, _offsetYForChar(i, t)),
                child: Text(chars[i], style: widget.style),
              ),
          ],
        );
      },
    );
  }
}
