import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final double? height;
  final double? width;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  const CommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
    this.height,
    this.width,
    this.fontSize,
    this.fontWeight,
    this.leftIcon,
    this.rightIcon,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 50.h,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : () => {},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? (isEnabled ? AppColors.primaryColor : AppColors.blackColor),
          disabledBackgroundColor: AppColors.blackColor,
          side: borderColor != null ? BorderSide(
            color: borderColor!,
            width: 1.0,
          ) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon != null) ...[
              leftIcon!,
              SizedBox(width: 8.w),
            ],
            CommonText(
              text: text,
              fontSize: fontSize ?? AppFontSizes.font14,
              fontWeight: fontWeight ?? AppFontWeights.bold,
              color: textColor ?? AppColors.whiteColor,
            ),
            if (rightIcon != null) ...[
              SizedBox(width: 8.w),
              rightIcon!,
            ],
          ],
        ),
      ),
    );
  }
}