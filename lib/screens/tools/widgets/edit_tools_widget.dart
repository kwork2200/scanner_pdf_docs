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

class EditToolsWidget extends GetView<ToolsController> {
  const EditToolsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(AppDimensions.paddingSmall),
      mainAxisSpacing: AppDimensions.spacingMedium,
      crossAxisSpacing: AppDimensions.spacingXLarge + 0.h,
      childAspectRatio: 1.2,
      children: controller.editTools.map((tool) => _buildGridToolItem(tool)).toList(),
    );
  }

  Widget _buildGridToolItem(EditToolModel tool) {
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
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey400.withOpacity(0.4),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tool.icon,
              size: AppDimensions.iconLarge,
              color: AppColors.infoBlue,
            ),
            Spacing.height(AppDimensions.spacingMedium),
            CommonText(
              text: tool.title,
              fontSize: AppFontSizes.font14,
              fontWeight: AppFontWeights.semiBold,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
