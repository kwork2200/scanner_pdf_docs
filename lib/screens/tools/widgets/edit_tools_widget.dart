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
import 'package:scanner_pdf_docs/widgets/components/ads/hybrid_native_ad_widget.dart';
import 'package:scanner_pdf_docs/utils/functions.dart';

class EditToolsWidget extends GetView<ToolsController> {
  const EditToolsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppDimensions.paddingSmall),
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: AppDimensions.spacingMedium,
          crossAxisSpacing: AppDimensions.spacingXLarge + 0.h,
          childAspectRatio: 1.2,
          children: controller.editTools.map((tool) => _buildGridToolItem(tool)).toList(),
        ),
        Spacing.height(AppDimensions.spacingMedium),
        HybridNativeAdWidget(
          height: 80,
          smallHeight: 100,
          adKey: 'edit_tools_ad_1',
          margin: EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall),
        ),
        // Add bottom padding for better spacing
        SizedBox(height: 80.h),
      ],
    );
  }

  Widget _buildGridToolItem(EditToolModel tool) {
    return GestureDetector(
      onTap: () async {
        if (tool.route != null) {
          // Show interstitial ad before navigation
          final context = Get.context;
          if (context != null) {
            await showManagedInterstitialAd(context);
          }
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
              color: AppColors.grey.withOpacity(0.4),
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
