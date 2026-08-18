import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/tools/models/tool_model.dart';
import 'package:scanner_pdf_docs/screens/tools/tools_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class ScanToolsWidget extends GetView<ToolsController> {
  const ScanToolsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.paddingSmall),
      itemCount: controller.scanTools.length,
      itemBuilder: (context, index) {
        final tool = controller.scanTools[index];
        return Column(
          children: [
            _buildToolItem(tool),
            if (index < controller.scanTools.length - 1)
              Spacing.height(AppDimensions.spacingMedium),
          ],
        );
      },
    );
  }

  Widget _buildToolItem(ToolModel tool) {
    return GestureDetector(
      onTap: () {
        if (tool.route != null) {
          Get.toNamed(tool.route!);
        }
      },
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.6),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingSmall),
              decoration: BoxDecoration(
                color: AppColors.infoBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Icon(
                tool.icon,
                size: AppDimensions.iconLarge + 8.sp,
                color: AppColors.infoBlue,
              ),
            ),
            Spacing.width(AppDimensions.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: tool.title,
                    fontSize: AppFontSizes.font14 + 1.sp,
                    fontWeight: AppFontWeights.semiBold,
                    color: AppColors.blackColor,
                  ),
                  CommonText(
                    text: tool.subtitle,
                    fontSize: AppFontSizes.font14,
                    fontWeight: AppFontWeights.semiBold,
                    color: AppColors.grey,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: AppDimensions.iconSmall,
              color: AppColors.infoBlue,
            ),
          ],
        ),
      ),
    );
  }
}
