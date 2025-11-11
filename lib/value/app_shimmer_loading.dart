import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// =======================
/// 1) Shimmer Theme Global
/// =======================
class AppShimmerThemeData {
  final Color baseColor;
  final Color highlightColor;
  final Duration period;
  final bool enabled;
  const AppShimmerThemeData({
    required this.baseColor,
    required this.highlightColor,
    this.period = const Duration(milliseconds: 1400),
    this.enabled = true,
  });

  AppShimmerThemeData copyWith({
    Color? baseColor,
    Color? highlightColor,
    Duration? period,
    bool? enabled,
  }) {
    return AppShimmerThemeData(
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
      period: period ?? this.period,
      enabled: enabled ?? this.enabled,
    );
  }
}

class AppShimmerTheme extends InheritedWidget {
  final AppShimmerThemeData data;
  const AppShimmerTheme({super.key, required this.data, required super.child});

  static AppShimmerThemeData of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<AppShimmerTheme>();
    assert(w != null, 'Wrap MaterialApp with AppShimmerTheme');
    return w!.data;
  }

  @override
  bool updateShouldNotify(covariant AppShimmerTheme oldWidget) =>
      oldWidget.data != data;
}

/// =====================================
/// 2) Hạt nhân: AppShimmerBox (Common)
/// =====================================
class AppShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? radius;
  final EdgeInsets? margin;
  final Color? overrideColor;

  const AppShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.radius,
    this.margin,
    this.overrideColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppShimmerTheme.of(context);
    final child = Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: overrideColor ?? theme.baseColor,
        borderRadius: radius ?? BorderRadius.circular(10),
      ),
    );

    if (!theme.enabled) return child;

    return Shimmer.fromColors(
      baseColor: theme.baseColor,
      highlightColor: theme.highlightColor,
      period: theme.period,
      child: child,
    );
  }
}

/// ======================================
/// 3) Switcher: đổi shimmer <-> real UI
/// ======================================
class AppShimmerSwitch extends StatelessWidget {
  final bool isLoading;
  final Widget shimmer;
  final Widget child;
  const AppShimmerSwitch({
    super.key,
    required this.isLoading,
    required this.shimmer,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => isLoading ? shimmer : child;
}

/// ============================
/// 4) Skeletons tái sử dụng
/// ============================

class AppSkeletonText extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsets? margin;
  const AppSkeletonText({
    super.key,
    this.width = double.infinity,
    this.height = 14,
    this.margin,
  });
  @override
  Widget build(BuildContext context) {
    return AppShimmerBox(
      height: height,
      width: width,
      margin: margin ?? const EdgeInsets.only(bottom: 8),
    );
  }
}

class AppSkeletonAvatar extends StatelessWidget {
  final double size;
  const AppSkeletonAvatar({super.key, this.size = 48});
  @override
  Widget build(BuildContext context) {
    return AppShimmerBox(
      height: size,
      width: size,
      radius: BorderRadius.circular(size),
    );
  }
}

class AppSkeletonCard extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;
  const AppSkeletonCard({
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSkeletonAvatar(size: 64),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AppSkeletonText(height: 16, width: 180),
                AppSkeletonText(height: 14, width: 140),
                AppSkeletonText(height: 14, width: 220),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppSkeletonList extends StatelessWidget {
  final int itemCount;
  final ScrollPhysics? physics;
  const AppSkeletonList({super.key, this.itemCount = 6, this.physics});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: physics ?? const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (_, __) => const AppSkeletonCard(),
    );
  }
}

/// ===================================================
/// 5) Overlay toàn màn hình (tuỳ chọn dùng khi fetch)
/// ===================================================
class AppShimmerOverlay extends StatelessWidget {
  final bool visible;
  final Widget overlay; // thường là Container mờ + progress/shimmer
  final Widget child;
  const AppShimmerOverlay({
    super.key,
    required this.visible,
    required this.overlay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [child, if (visible) Positioned.fill(child: overlay)],
    );
  }
}
