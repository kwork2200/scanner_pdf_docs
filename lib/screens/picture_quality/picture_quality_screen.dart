import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/picture_quality/picture_quality_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_app_bar.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class PictureQualityScreen extends GetView<PictureQualityController> {
  const PictureQualityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CommonAppBar(
        title: AppTexts.pictureQuality,
        showProBadge :false,
        backgroundColor: AppColors.backgroundColor,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.infoBlue,
            size: 20.sp,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        itemCount: controller.qualityOptions.length,
        itemBuilder: (context, index) {
          final option = controller.qualityOptions[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index < controller.qualityOptions.length - 1 ? AppDimensions.spacingSmall : 0),
            child: _buildQualityOption(
              title: option['title'] as String,
              quality: option['quality'] as PictureQuality,
            ),
          );
        },
      ),
    );
  }

  Widget _buildQualityOption({
    required String title,
    required PictureQuality quality,
  }) {
    return GestureDetector(
      onTap: () => controller.selectQuality(quality),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingSmall + 4.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusMedium,
          ),
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
            Obx(() {
              final isSelected = controller.selectedQuality.value == quality;

              return Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? AppColors.infoBlue : AppColors.grey, width: 1.w,),
                ),
                child: isSelected
                    ? Center(
                  child: Container(
                    width: 12.w, height: 12.w,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.infoBlue),
                  ),
                ) : null,
              );
            }),
            Spacing.width(AppDimensions.spacingMedium),
            Expanded(
              child: CommonText(
                text: title,
                fontSize: AppFontSizes.font14,
                fontWeight: AppFontWeights.normal,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
