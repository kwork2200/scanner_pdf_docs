import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class ProImageEditorScreen extends StatelessWidget {
  final File imageFile;
  final int imageIndex;

  const ProImageEditorScreen({
    super.key,
    required this.imageFile,
    required this.imageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final ScanController controller = Get.find<ScanController>();

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.whiteColor),
          onPressed: () {
            Get.back();
          },
        ),
        title: CommonText(
          text: 'Edit Image',
          fontSize: AppFontSizes.font16,
          color: AppColors.whiteColor,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              Get.back();
            },
            child: CommonText(
              text: AppTexts.cancel,
              color: AppColors.whiteColor,
              fontSize: AppFontSizes.font16,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
      body: ProImageEditor.file(
        imageFile,
        callbacks: ProImageEditorCallbacks(
          onImageEditingComplete: (editedBytes) async {
            try {
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(color: AppColors.whiteColor),
                ),
                barrierDismissible: false,
              );

              final directory = imageFile.parent;
              final fileName = 'edited_${DateTime.now().millisecondsSinceEpoch}.jpg';
              final editedPath = '${directory.path}/$fileName';
              final editedFile = File(editedPath);
              await editedFile.writeAsBytes(editedBytes);

              if (imageIndex < controller.capturedImages.length) {
                controller.capturedImages[imageIndex] = editedFile;
                controller.currentImage.value = editedFile;
              } else {
                controller.currentImage.value = editedFile;
              }

              Get.back();
              Get.back();

              // AppConstants.showCommonSnackBar(message: 'Image edited successfully');
            } catch (e) {
              Get.back();
              AppConstants.showCommonSnackBar(message: 'Failed to save edited image: $e', isError: true);
            }
          },
        ),
        configs: ProImageEditorConfigs(
          theme: ThemeData.dark(),
        ),
      ),
    );
  }
}
