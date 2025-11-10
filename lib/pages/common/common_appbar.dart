import 'package:flutter/material.dart';

/// CommonAppBar linh hoạt, có thể truyền widget tùy ý
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTitle;
  final double elevation;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;
  final VoidCallback? onBack;
  final double? scrolledUnderElevation;

  const CommonAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation = 0,
    this.bottom,
    this.automaticallyImplyLeading = true,
    this.onBack,
    this.scrolledUnderElevation,
  });

  @override
  Widget build(BuildContext context) {
    Widget? resolvedLeading = leading;
    if (resolvedLeading == null && onBack != null) {
      resolvedLeading = IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: onBack,
      );
    }

    return AppBar(
      scrolledUnderElevation: scrolledUnderElevation ?? 0,
      title: title,
      centerTitle: centerTitle,
      actions: actions,
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: resolvedLeading,
      bottom: bottom,
      automaticallyImplyLeading:
          automaticallyImplyLeading && leading == null && onBack == null,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
