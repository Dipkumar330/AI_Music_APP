// widgets/common_textfield.dart
import 'package:ai_music/utils/app_common/colors_cost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_common/fonts.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final Widget? prefixWidget;
  final bool isPassword;
  final bool obscureText;
  final bool? enabled;
  final VoidCallback? onToggleVisibility;
  final TextAlign? textAlign;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String s)? onSubmit;

  const CommonTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.prefixWidget,
    this.textAlign,
    this.contentPadding,
    this.enabled,
    this.textInputType,
    this.textInputAction,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: textAlign ?? TextAlign.start,
      obscureText: isPassword ? obscureText : false,
      enabled: enabled ?? true,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      onSubmitted: (v) => onSubmit == null ? null : onSubmit!(v),
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: contentPadding ?? EdgeInsets.only(left: 16.w),
        hintStyle: TextStyle(
          fontSize: 14,
          fontFamily: AppFonts.poppinsRegular,
          color: AppColors.veryLightFontColor,
        ),
        prefixIcon: prefixWidget ?? (icon != null ? Icon(icon) : null),
        prefixIconConstraints: BoxConstraints(),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.iconColor,
                  ),
                  onPressed: onToggleVisibility,
                )
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
