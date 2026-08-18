import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/extract_text/extract_text_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text_field.dart';

class ExtractTextScreen extends GetView<ExtractTextController> {
  const ExtractTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Get.back(),
        ),
        title: CommonText(
          text: 'Extract Text',
          fontSize: AppFontSizes.font16,
          fontWeight: AppFontWeights.semiBold,
          color: AppColors.blackColor,
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Selection Section
            Container(
              width: double.infinity,
              color: AppColors.backgroundColor,
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: 'Select Image',
                      fontSize: AppFontSizes.font14,
                      fontWeight: AppFontWeights.bold,
                      color: AppColors.blackColor,
                    ),
                    Spacing.height(AppDimensions.spacingLarge),
                    Row(
                      children: [
                        _buildAddOption(
                          icon: Icons.photo_library,
                          label: 'From Gallery',
                          color: AppColors.infoBlue,
                          onTap: controller.pickFromGallery,
                        ),
                        Spacing.width(AppDimensions.paddingMedium),
                        _buildAddOption(
                          icon: Icons.camera_alt,
                          label: 'From Camera',
                          color: AppColors.infoBlue,
                          onTap: controller.pickFromCamera,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Selected Image Preview
            Obx(() {
              if (controller.selectedImage.value != null) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(AppDimensions.paddingMedium),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    child: Image.file(
                      controller.selectedImage.value!,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            
            // Extracted Text Section
            Obx(() {
              if (controller.isProcessing.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingXLarge),
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.infoBlue,
                        ),
                        Spacing.height(AppDimensions.paddingMedium),
                        CommonText(
                          text: 'Extracting text...',
                          color: AppColors.grey,
                          fontSize: AppFontSizes.font14,
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              if (controller.extractedText.value.isNotEmpty) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(AppDimensions.paddingMedium),
                  padding: EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    border: Border.all(
                      color: AppColors.grey300,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: 'Extracted Text',
                            fontSize: AppFontSizes.font14,
                            fontWeight: AppFontWeights.bold,
                            color: AppColors.blackColor,
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: AppColors.infoBlue),
                            onPressed: controller.copyText,
                          ),
                        ],
                      ),
                      Spacing.height(AppDimensions.spacingMedium),
                      CommonText(
                        text: controller.extractedText.value,
                        fontSize: AppFontSizes.font14,
                        color: AppColors.blackColor,
                        maxLines: null,
                      ),
                    ],
                  ),
                );
              }
              
              if (controller.selectedImage.value != null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingXLarge),
                    child: Column(
                      children: [
                        CommonText(
                          text: 'Tap the button below to extract text',
                          color: AppColors.grey,
                          fontSize: AppFontSizes.font14,
                          textAlign: TextAlign.center,
                        ),
                        Spacing.height(AppDimensions.paddingMedium),
                        ElevatedButton.icon(
                          onPressed: controller.isProcessing.value ? null : controller.copyText,
                          icon: controller.isProcessing.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.whiteColor,
                                  ),
                                )
                              : const Icon(Icons.text_fields),
                          label: CommonText(
                            text: 'Extract Text',
                            color: AppColors.whiteColor,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.infoBlue,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingXLarge,
                              vertical: AppDimensions.paddingMedium,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingXLarge),
                  child: CommonText(
                    text: 'Select an image to extract text',
                    color: AppColors.grey,
                    fontSize: AppFontSizes.font16,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        child: Container(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 32.sp,
              ),
              Spacing.height(AppDimensions.paddingSmall),
              CommonText(
                text: label,
                fontSize: AppFontSizes.fontSmall,
                fontWeight: AppFontWeights.medium,
                color: AppColors.blackColor,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
