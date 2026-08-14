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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              CommonText(
                text: AppTexts.scanDocument,
                fontSize: AppFontSizes.font22,
                fontWeight: AppFontWeights.bold,
              ),
              
              Spacing.height(AppDimensions.paddingLarge),
              
              // Options
              _buildOption(
                icon: Icons.camera_alt,
                title: AppTexts.takePhoto,
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.cameraScan);
                },
              ),
              
              Spacing.height(AppDimensions.spacingXLarge),
              
              _buildOption(
                icon: Icons.photo,
                title: AppTexts.importFromGallery,
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
              
              Spacing.height(AppDimensions.spacingXLarge),
              
              _buildOption(
                icon: Icons.folder,
                title: AppTexts.importFromFiles,
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
              
              Spacing.height(AppDimensions.paddingLarge),
              
              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingXMedium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                    side: const BorderSide(color: AppColors.grey400),
                  ),
                  child: CommonText(
                    text: AppTexts.cancel,
                    fontSize: AppFontSizes.font16,
                    color: AppColors.black87,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
