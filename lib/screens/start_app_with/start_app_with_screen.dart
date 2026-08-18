import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/start_app_with/start_app_with_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_app_bar.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class StartAppWithScreen extends GetView<StartAppWithController> {
  const StartAppWithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CommonAppBar(
        title: AppTexts.startAppWith,
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
      body: Obx(() => ListView(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        children: [
          _buildOption(
            title: AppTexts.scannerCamera,
            startOption: StartOption.scanner,
          ),
          Spacing.height(AppDimensions.spacingSmall),
          _buildOption(
            title: AppTexts.documents,
            startOption: StartOption.documents,
          ),
        ],
      )),
    );
  }

  Widget _buildOption({required String title, required StartOption startOption}) {
    final isSelected = controller.selectedOption.value == startOption;
    
    return GestureDetector(
      onTap: () => controller.selectOption(startOption),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium, vertical: AppDimensions.paddingSmall + 4.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: [BoxShadow(color: AppColors.grey300.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? AppColors.infoBlue : AppColors.grey, width: 1.5.w),
                color: Colors.transparent,
              ),
              child: isSelected
                  ? Center(child: Container(width: 12.w, height: 12.w, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.infoBlue)))
                  : null,
            ),
            Spacing.width(AppDimensions.spacingMedium),
            Expanded(
              child: CommonText(
                text: title,
                fontSize: AppFontSizes.font14,
                fontWeight: isSelected ? AppFontWeights.bold : AppFontWeights.normal,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
