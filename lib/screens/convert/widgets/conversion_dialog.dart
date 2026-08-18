import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_images.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class ConversionDialog {
  static void show({
    required BuildContext context,
    required VoidCallback onContinue,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          backgroundColor: AppColors.whiteColor,
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  AppImages.pdfLottie,
                  width: 170.w,
                  height: 170.h,
                  fit: BoxFit.contain,
                ),
                CommonText(
                  text: 'Conversion Started',
                  fontSize: AppFontSizes.font16,
                  fontWeight: AppFontWeights.originalBold,
                  color: AppColors.black87,
                  textAlign: TextAlign.center,
                ),
                Spacing.height(AppDimensions.spacingSmall),
                CommonText(
                  text: 'The operation will continue in the background, and we\'ll inform you once it\'s complete.',
                  fontSize: AppFontSizes.fontSmall,
                  fontWeight: AppFontWeights.normal,
                  color: AppColors.grey600,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  softWrap: true,
                ),
                Spacing.height(AppDimensions.spacingXLarge),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onContinue();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.infoBlue,
                      foregroundColor: AppColors.whiteColor,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                      ),
                      elevation: 0,
                    ),
                    child: CommonText(
                      text: 'Continue',
                      fontSize: AppFontSizes.font16,
                      fontWeight: AppFontWeights.semiBold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
                Spacing.height(AppDimensions.spacingMedium),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                      if (onCancel != null) {
                        onCancel();
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.grey100,
                      foregroundColor: AppColors.blackColor,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusCircle)),
                    ),
                    child: CommonText(
                      text: 'Cancel',
                      fontSize: AppFontSizes.font16,
                      fontWeight: AppFontWeights.semiBold,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
