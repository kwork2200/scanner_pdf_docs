import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/account/account_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class PremiumCardWidget extends GetView<AccountController> {
  const PremiumCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withOpacity(0.8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommonText(
                text: AppTexts.pdfScannerApp,
                fontSize: AppFontSizes.font16,
                fontWeight: AppFontWeights.bold,
                color: AppColors.blackColor,
              ),
              Spacing.width(AppDimensions.spacingMedium),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall - 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.infoBlue,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 14.sp, color: AppColors.whiteColor),
                    Spacing.width(2.w),
                    CommonText(
                      text: AppTexts.pro,
                      fontSize: AppFontSizes.fontNeNoSmall,
                      fontWeight: AppFontWeights.semiBold,
                      color: AppColors.whiteColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.height(AppDimensions.spacingLarge),
          ...List.generate(controller.premiumFeatures.length, (index) {
            final feature = controller.premiumFeatures[index];
            return Column(
              children: [
                _buildFeatureItem(feature.title, feature.onTap),
                if (index < controller.premiumFeatures.length - 1)
                  Spacing.height(AppDimensions.spacingSmall),
              ],
            );
          }),
          Spacing.height(AppDimensions.spacingMedium),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  size: AppDimensions.iconSmall,
                  color: AppColors.infoBlue,
                ),
                Spacing.width(AppDimensions.spacingMedium),
                CommonText(
                  text: AppTexts.moreAboutPremium,
                  fontSize: AppFontSizes.fontSmall,
                  fontWeight: AppFontWeights.extraBold,
                  color: AppColors.infoBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: AppDimensions.iconSmall,
            color: AppColors.infoBlue,
          ),
          Spacing.width(AppDimensions.spacingMedium),
          CommonText(
            text: text,
            fontSize: AppFontSizes.fontSmall,
            fontWeight: AppFontWeights.medium,
            color: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}
