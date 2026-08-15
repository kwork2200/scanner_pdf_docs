import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/screens/tools/tools_controller.dart';
import 'package:scanner_pdf_docs/screens/tools/widgets/convert_tools_widget.dart';
import 'package:scanner_pdf_docs/screens/tools/widgets/edit_tools_widget.dart';
import 'package:scanner_pdf_docs/screens/tools/widgets/scan_tools_widget.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_app_bar.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class ToolsScreen extends GetView<ToolsController> {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.infoBlue.withValues(alpha: 0.01),
      appBar: CommonAppBar(
        title: AppTexts.tools,
        backgroundColor: AppColors.whiteColor,
        showProBadge: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.backgroundColor,
            child: Container(
              margin: EdgeInsets.all(AppDimensions.paddingMedium - 4.w),
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
              ),
              child: Obx(() => Row(
                children: [
                  _buildTab('Scan', 0),
                  _buildTab('Edit', 1),
                  _buildTab('Convert', 2),
                ],
              )),
            ),
          ),
          Expanded(child: Obx(() => _buildContent())),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = controller.selectedTabIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall - 3),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.whiteColor : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            ),
            child: Center(
              child: CommonText(
                text: title,
                fontSize: AppFontSizes.font14,
                fontWeight: isSelected ? AppFontWeights.bold : AppFontWeights.bold,
                color: isSelected ? AppColors.blackColor : AppColors.grey400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (controller.selectedTabIndex.value) {
      case 0:
        return const ScanToolsWidget().paddingOnly(bottom: AppDimensions.paddingXLarge40);
      case 1:
        return const EditToolsWidget();
      case 2:
        return const ConvertToolsWidget();
      default:
        return const ScanToolsWidget();
    }
  }
}
