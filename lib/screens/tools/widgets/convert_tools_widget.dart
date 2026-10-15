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

class ConvertToolsWidget extends GetView<ToolsController> {
  const ConvertToolsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      itemCount: _getItemCount(),
      itemBuilder: (context, index) {
        return _buildItem(index);
      },
    );
  }

  int _getItemCount() {
    int toolCount = controller.convertTools.length;
    int adCount = toolCount ~/ 2; // Add ad after every 2 items
    return toolCount + adCount;
  }

  Widget _buildItem(int index) {
    // Calculate if this is an ad position
    int adsBefore = index ~/ 3; // Every 3rd position is an ad (2 tools + 1 ad)
    int toolIndex = index - adsBefore;

    // Check if this position should show an ad
    bool isAdPosition = (index + 1) % 3 == 0;

    if (isAdPosition && toolIndex < controller.convertTools.length) {
      return Column(
        children: [
          // Spacing.height(AppDimensions.spacingMedium),
          HybridNativeAdWidget(
            height: 100,
            smallHeight: 80,
            adKey: 'convert_tools_ad_${adsBefore + 1}',
            margin: EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall),
          ),
          Spacing.height(AppDimensions.spacingMedium),
        ],
      );
    }

    // Show tool item
    if (toolIndex < controller.convertTools.length) {
      final tool = controller.convertTools[toolIndex];
      return Column(
        children: [
          _buildConvertItem(tool),
          if (index < _getItemCount() - 1)
            Spacing.height(AppDimensions.spacingMedium),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildConvertItem(ConvertToolModel tool) {
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
