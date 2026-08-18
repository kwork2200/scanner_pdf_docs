import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/home/widget/recent_document_item.dart';
import 'package:scanner_pdf_docs/screens/signature/signature_controller.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text_field.dart';

class SignatureScreen extends GetView<SignatureController> {
  const SignatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Get.back(),
        ),
        title: CommonText(
          text: 'Signature',
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
                  hintText: 'Search signatures...',
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
            // Spacing.height(AppDimensions.paddingSmall),
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spacing.height(AppDimensions.paddingSmall),
                  CommonText(
                    text: 'Add Signature',
                    fontSize: AppFontSizes.font14,
                    fontWeight: AppFontWeights.bold,
                    color: AppColors.blackColor,
                  ),
                  Spacing.height(AppDimensions.spacingLarge),
                  Row(
                    children: [
                      // Expanded(
                      //   child:
                        _buildAddOption(
                          icon: Icons.photo_library,
                          label: 'From Gallery',
                          color: AppColors.infoBlue,
                          onTap: controller.pickSignatureFromGallery,
                        ),
                      // ),
                      // Spacing.width(AppDimensions.paddingMedium),
                      // Expanded(
                      //   child: _buildAddOption(
                      //     icon: Icons.camera_alt,
                      //     label: 'Capture',
                      //     color: AppColors.infoBlue,
                      //     onTap: controller.captureSignature,
                      //   ),
                      // ),
                    ],
                  ),
                  Spacing.height(AppDimensions.spacingXLarge),
                  CommonText(
                    text: AppTexts.recentS,
                    fontSize: AppFontSizes.font14,
                    fontWeight: AppFontWeights.bold,
                    color: AppColors.blackColor,
                  ),
                  Spacing.height(AppDimensions.spacingXLarge),
                  Obx(() {
                    final filteredSignatures = controller.getFilteredSignatures();

                    if (filteredSignatures.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppDimensions.paddingXLarge),
                          child: CommonText(
                            text: controller.searchQuery.value.isEmpty ? 'No signatures found' : 'No matching signatures',
                            color: AppColors.grey400,
                            fontSize: AppFontSizes.font16,
                          ),
                        ),
                      );
                    }

                    return RecentDocumentItemListView(
                      images: filteredSignatures,
                      titleBuilder: (index) {
                        return 'Signature ${index + 1}';
                      },
                      sizeBuilder: (image) {
                        return AppConstants.getFileSize(image);
                      },
                      onTap: (image) {
                        return () {
                          Get.back();
                        };
                      },
                      onLongPress: (context, image, title) {
                        _showContextMenu(context, image, title);
                      },
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

  Widget _buildAddOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
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
    );
  }

  void _showContextMenu(BuildContext context, dynamic imageFile, String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.share_outlined,
                color: AppColors.black87,
              ),
              title: CommonText(
                text: AppTexts.share,
                fontSize: AppFontSizes.font16,
              ),
              onTap: () {
                Get.back();
                AppConstants.showCommonSnackBar(message: 'Share feature coming soon');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: AppColors.redColor,
              ),
              title: CommonText(
                text: AppTexts.delete,
                fontSize: AppFontSizes.font16,
                color: AppColors.redColor,
              ),
              onTap: () {
                Get.back();
                AppConstants.showCommonSnackBar(
                  message: 'Delete feature coming soon',
                  isError: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
