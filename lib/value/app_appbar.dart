import 'package:flutter/material.dart';
import 'package:flutter_app_day1/value/app_colors.dart';
import 'package:flutter_app_day1/value/app_text_style.dart';

/// AppBar mặc định cho toàn ứng dụng
/// Dùng cho 80% các trang (Home, Detail, List...)
/// Style đồng nhất, không cần cấu hình nhiều
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double elevation;

  const AppAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.showBackButton = false,
    this.actions,
    this.backgroundColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyle.display.copyWith(fontSize: 22)),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.backgroundColor,
      elevation: elevation,
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                onPressed: () => Navigator.of(context).maybePop(),
              )
              : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
