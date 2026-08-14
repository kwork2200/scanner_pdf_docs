import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class RecentDocumentItem extends StatelessWidget {
  final File imageFile;
  final String title;
  final String date;
  final String size;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const RecentDocumentItem({
    super.key,
    required this.imageFile,
    required this.title,
    required this.date,
    required this.size,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.only(bottom: AppDimensions.spacingLarge),
        child: Row(
          children: [
            Container(
              width: AppDimensions.paddingXLarge40 + 5.w,
              height: AppDimensions.paddingXLarge40 + 5.h,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusSmall,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusSmall,
                ),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.infoBlue,
                      child: Icon(
                        Icons.document_scanner,
                        color: AppColors.whiteColor,
                        size: AppDimensions.iconLarge,
                      ),
                    );
                  },
                ),
              ),
            ),
            Spacing.width(AppDimensions.spacingLarge),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: title,
                    fontSize: AppFontSizes.font14,
                    fontWeight: AppFontWeights.medium,
                    color: AppColors.blackColor,
                  ),
                  CommonText(
                    text: '$date  $size',
                    fontSize: AppFontSizes.fontNeNoSmall,
                    color: AppColors.grey400,
                    fontWeight: AppFontWeights.medium,

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}