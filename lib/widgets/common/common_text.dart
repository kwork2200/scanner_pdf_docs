import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final bool videoScreenCheck;
  final bool softWrap;
  final Color? decorationColor;
  final double? decorationThickness;
  final double? letterSpacing;
  final double? textHeight;
  final FontStyle? fontStyle;

  const CommonText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.white,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.videoScreenCheck = false,
    this.softWrap = false,
    this.decorationColor,
    this.decorationThickness,
    this.letterSpacing,
    this.textHeight,
    this.fontStyle,
  });

  double _responsiveFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1440) return fontSize;
    if (width >= 1024) return fontSize * 0.92;
    if (width >= 600) return fontSize;
    return fontSize;
  }

  @override
  Widget build(BuildContext context) {
    final double resolvedFontSize = _responsiveFontSize(context);
    final effectiveColor = videoScreenCheck ? AppColors.whiteColor : color;

    final TextStyle base =
        Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    final TextStyle style = base.copyWith(
      fontSize: resolvedFontSize.sp,
      fontWeight: fontWeight,
      color: effectiveColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
      letterSpacing: letterSpacing,
      height: textHeight,
      fontStyle: fontStyle,
    );

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: style,
    );
  }
}