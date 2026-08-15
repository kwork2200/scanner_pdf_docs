import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showProBadge;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showProBadge = true,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.backgroundColor,
      foregroundColor: foregroundColor ?? AppColors.backgroundColor,
      leading: leading,
      actions: actions,
      title: Row(
        children: [
          if (showProBadge) ...[
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: AppColors.infoBlue,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.backgroundColor,
                      size: 12.sp,
                    ),
                    CommonText(
                      text: ' PRO',
                      fontSize: AppFontSizes.fontNeNoSmall,
                      fontWeight: AppFontWeights.medium,
                      color: AppColors.backgroundColor,
                    ),
                  ],
                ),
              ),
            ),
            Spacing.width(30),
          ],
          CommonText(
            text: title,
            fontSize: AppFontSizes.font16,
            fontWeight: AppFontWeights.semiBold,
            color: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}
