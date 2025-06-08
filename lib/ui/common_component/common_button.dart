import 'package:ai_music/utils/app_common/colors_cost.dart';
import 'package:ai_music/utils/app_common/fonts.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const CommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 30.0,
    this.fontSize = 16.0,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.redD9494E,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
            padding: padding),
        onPressed: onPressed,
        child: Text(text,
            style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: fontSize,
                fontFamily: AppFonts.poppinsSemiBold)),
      ),
    );
  }
}
