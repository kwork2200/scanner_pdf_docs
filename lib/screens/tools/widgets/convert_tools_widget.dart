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

class ConvertToolsWidget extends GetView<ToolsController> {
  const ConvertToolsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      itemCount: controller.convertTools.length,
      itemBuilder: (context, index) {
        final tool = controller.convertTools[index];
        return Column(
          children: [
            _buildConvertItem(tool),
            if (index < controller.convertTools.length - 1)
              Spacing.height(AppDimensions.spacingMedium),
          ],
        );
      },
    );
  }

  Widget _buildConvertItem(ConvertToolModel tool) {
    return GestureDetector(
      onTap: () {
        if (tool.route != null) {
          Get.toNamed(tool.route!);
        }
      },
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingXMedium),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withOpacity(0.7),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              tool.icon,
              size: AppDimensions.iconLarge + 15.sp,
              color: tool.iconColor,
            ),
            Spacing.width(AppDimensions.spacingLarge - 2.h),
            Expanded(
              child: CommonText(
                text: tool.title,
                fontSize: AppFontSizes.font14,
                fontWeight: AppFontWeights.medium,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
