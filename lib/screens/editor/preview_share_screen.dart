import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';
import 'package:scanner_pdf_docs/widgets/sheets/share_options_sheet.dart';

class PreviewShareScreen extends GetView<ScanController> {
  const PreviewShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        foregroundColor: AppColors.whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: CommonText(
          text: 'Preview',
          fontSize: AppFontSizes.font18,
          fontWeight: AppFontWeights.bold,
          color: AppColors.whiteColor,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Add edit functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Image Preview
          Expanded(
            child: Center(
              child: Obx(() {
                if (controller.currentImage.value == null) {
                  return CommonText(
                    text: 'No image available',
                    color: AppColors.whiteColor,
                  );
                }
                
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.file(
                    controller.currentImage.value!,
                    fit: BoxFit.contain,
                  ),
                );
              }),
            ),
          ),
          
          // Share Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const ShareOptionsSheet(),
                  );
                },
                icon:  Icon(Icons.share, size: AppDimensions.iconMedium),
                label: CommonText(
                  text: AppTexts.share,
                  fontSize: AppFontSizes.fontLarge,
                  fontWeight: AppFontWeights.bold,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.infoBlue,
                  foregroundColor: AppColors.whiteColor,
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingXMedium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
