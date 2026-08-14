import 'package:flutter/material.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';

class CommonLoader extends StatelessWidget {
  final Color? color;
  final double strokeWidth;
  final double size;

  const CommonLoader(
      {super.key, this.color, this.strokeWidth = 3.0, this.size = 30.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(color: color ?? AppColors.primaryColor, strokeWidth: strokeWidth),
      ),
    );
  }
}
