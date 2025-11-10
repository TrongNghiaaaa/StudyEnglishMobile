import 'package:flutter/material.dart';
import 'package:flutter_app_day1/value/app_colors.dart';

class FloatingActionButtonWidget extends StatefulWidget {
  final VoidCallback onReload;
  final bool isReloading;

  const FloatingActionButtonWidget({
    super.key,
    required this.onReload,
    required this.isReloading,
  });

  @override
  State<FloatingActionButtonWidget> createState() =>
      _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState extends State<FloatingActionButtonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Tạo animation xoay vô hạn (2s/1 vòng)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void didUpdateWidget(FloatingActionButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Khi đang reload → bắt đầu xoay, ngược lại dừng
    if (widget.isReloading) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.floatingActionButton,
      onPressed: widget.isReloading ? null : widget.onReload, // chặn spam
      child: RotationTransition(
        turns: _controller,
        child: const Icon(Icons.replay_outlined, size: 30, color: Colors.white),
      ),
    );
  }
}
