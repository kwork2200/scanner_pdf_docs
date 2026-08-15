import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/editor/camera_scan_screen.dart';
import 'package:scanner_pdf_docs/screens/editor/image_editor_screen.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ScanBottomSheet extends StatelessWidget {
  const ScanBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ScanController scanController = Get.find<ScanController>();
    
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radiusLarge),
            topRight: Radius.circular(AppDimensions.radiusLarge),
          ),
        ),
        padding: EdgeInsets.only(
          left: AppDimensions.paddingLarge,
          right: AppDimensions.paddingLarge,
          top: AppDimensions.paddingLarge,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.paddingLarge,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonText(
                text: AppTexts.scan,
                fontSize: AppFontSizes.font16,
                fontWeight: AppFontWeights.bold,
                color: AppColors.blackColor,
              ),
              Spacing.height(AppDimensions.paddingSmall),
              _buildOption(
                icon: Icons.camera_alt,
                title: AppTexts.scanWithCamera,
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.cameraScan);
                },
              ),
              _buildOption(
                icon: Icons.photo,
                title: AppTexts.scanFromPhotos,
                onTap: () async {
                  Get.back();
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  
                  if (image != null) {
                    await scanController.processPickedImage(image.path);
                    if (scanController.currentImage.value != null) {
                      Get.toNamed(AppRoutes.imageEditor, arguments: {
                        'imageFile': scanController.currentImage.value!,
                      });
                    }
                  }
                },
              ),
              _buildOption(
                icon: Icons.folder,
                title: AppTexts.scanFromFiles,
                onTap: () async {
                  Get.back();
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  
                  if (image != null) {
                    await scanController.processPickedImage(image.path);
                    // Navigate to image editor
                    if (scanController.currentImage.value != null) {
                      Get.toNamed(AppRoutes.imageEditor, arguments: {
                        'imageFile': scanController.currentImage.value!,
                      });
                    }
                  }
                },
              ),
              Spacing.height(AppDimensions.paddingSmall),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: CommonText(
                    text: AppTexts.cancel,
                    fontSize: AppFontSizes.font14,
                    color: AppColors.black87,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical:AppDimensions.paddingSmall),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingSmall - 3),
              decoration: BoxDecoration(
                color: AppColors.infoBlue,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Icon(icon, color: AppColors.backgroundColor, size: AppDimensions.iconMedium),
            ),
            Spacing.width(AppDimensions.paddingSmall),
            Expanded(
              child: CommonText(
                text: title,
                fontSize: AppFontSizes.font14,
                fontWeight: AppFontWeights.semiBold,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
