import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/app_pin/app_pin/app_pin_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_app_bar.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class AppPinScreen extends GetView<AppPinController> {
  const AppPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar:  CommonAppBar(
        title: AppTexts.appPin,
        backgroundColor: AppColors.backgroundColor,
        showProBadge :false,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.infoBlue,
            size: 20.sp,
          ),
        ),
      ),
      body: Obx(() => ListView(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey300.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: AppColors.infoBlue.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall - 2.r),
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: AppDimensions.iconSmall,
                    color: AppColors.descriptionColor,
                  ),
                ),
                Spacing.width(AppDimensions.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: AppTexts.appPin,
                        fontSize: AppFontSizes.font14,
                        fontWeight: AppFontWeights.semiBold,
                        color: AppColors.blackColor,
                      ),
                      Spacing.height(4.h),
                      CommonText(
                        text: AppTexts.pinProtection,
                        fontSize: AppFontSizes.fontSmall,
                        fontWeight: AppFontWeights.normal,
                        color: AppColors.grey,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: controller.isPinEnabled.value,
                  onChanged: controller.togglePin,
                  activeColor: AppColors.infoBlue,
                ),
              ],
            ),
          ),

          if (controller.isPinEnabled.value) ...[
            Spacing.height(AppDimensions.spacingSmall),
            GestureDetector(
              onTap: controller.openEnterPin,
              child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingSmall),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey300.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: AppColors.infoBlue.withValues(alpha: 0.09),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall - 2.r),
                      ),
                      child: Icon(
                        Icons.dialpad,
                        size: AppDimensions.iconSmall,
                        color: AppColors.descriptionColor,
                      ),
                    ),
                    Spacing.width(AppDimensions.spacingMedium),
                    Expanded(
                      child: CommonText(
                        text: AppTexts.enterPin,
                        fontSize: AppFontSizes.font14,
                        fontWeight: AppFontWeights.normal,
                        color: AppColors.blackColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: AppDimensions.iconSmall,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      )),
    );
  }
}
