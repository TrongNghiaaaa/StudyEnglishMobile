import 'package:flutter/material.dart';
import 'package:flutter_app_day1/value/app_text_style.dart';

class AppButton extends StatelessWidget {
  final String? label;
  final Color? colorText;
  final Color? backgroundColorContainer;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    this.label,
    this.colorText,
    this.backgroundColorContainer,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.black26,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColorContainer ?? Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            textAlign: TextAlign.start,
            label ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                textStyle ??
                AppTextStyle.body.copyWith(
                  color: colorText ?? Colors.black,
                  fontSize: 22,
                ),
          ),
        ),
      ),
    );
  }
}
