import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/home/widget/recent_document_item.dart';
import 'package:scanner_pdf_docs/screens/convert/convert_controller.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text_field.dart';

class ConvertScreen extends GetView<ConvertController> {
  const ConvertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.backgroundColor,
        leading: IconButton(
          icon:Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Get.back(),
        ),
        title: CommonText(
          text: 'Convert',
          fontSize: AppFontSizes.font16,
          fontWeight: AppFontWeights.semiBold,
          color: AppColors.blackColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.backgroundColor,
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingMedium),
                child: CommonTextField(
                  hintText: 'Search files...',
                  fillColor: AppColors.infoBlue.withValues(alpha: 0.05),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.h),
                  prefixIcon: Icon(Icons.search, color: AppColors.grey400),
                  onChanged: controller.onSearchChanged,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: AppTexts.recentS,
                    fontSize: AppFontSizes.font14,
                    fontWeight: AppFontWeights.bold,
                    color: AppColors.blackColor,
                  ),
                  Spacing.height(AppDimensions.spacingXLarge),
                  Obx(() {
                    final filteredFiles = controller.getFilteredFiles();

                    if (filteredFiles.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppDimensions.paddingXLarge),
                          child: CommonText(
                            text: controller.searchQuery.value.isEmpty ? 'No files found' : 'No matching files',
                            color: AppColors.grey400,
                            fontSize: AppFontSizes.font14,
                          ),
                        ),
                      );
                    }

                    return RecentDocumentItemListView(
                      images: filteredFiles,
                      titleBuilder: (index) {
                        return 'File ${index + 1}';
                      },
                      sizeBuilder: (image) {
                        return AppConstants.getFileSize(image);
                      },
                      onTap: (image) {
                        return () {
                          Get.back();
                        };
                      },
                      onLongPress: (context, image, title) {},
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
