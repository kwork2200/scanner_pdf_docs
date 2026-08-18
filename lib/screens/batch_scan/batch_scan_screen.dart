import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:scanner_pdf_docs/screens/batch_scan/batch_scan_controller.dart';
import 'package:scanner_pdf_docs/screens/batch_scan/widget/document_batch_frame_painter.dart';
import 'package:scanner_pdf_docs/screens/editor/document_editor_screen.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class BatchScanScreen extends GetView<BatchScanController> {
  const BatchScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return const Center(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor)),
          );
        }

        return Stack(
          children: [
            Positioned.fill(child: CameraPreview(controller.cameraController!)),
            Positioned.fill(child: CustomPaint(painter: DocumentBatchFramePainter())),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:  Icon(Icons.close, color: AppColors.whiteColor, size: AppDimensions.iconLarge),
                      onPressed: () => Get.back(),
                    ),
                    Obx(() => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium,
                        vertical: AppDimensions.paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blackColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: CommonText(
                        text: '${controller.capturedImages.length} pages',
                        fontSize: AppFontSizes.font14,
                        color: AppColors.whiteColor,
                        fontWeight: AppFontWeights.medium,
                      ),
                    )),
                    Obx(() => IconButton(
                      icon: Icon(
                        controller.isFlashOn.value 
                            ? Icons.flash_on 
                            : Icons.flash_off,
                        color: AppColors.whiteColor,
                        size: AppDimensions.iconLarge,
                      ),
                      onPressed: controller.toggleFlash,
                    )),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Captured Images Thumbnails with Arrow Button
                  Obx(() {
                    if (controller.capturedImages.isNotEmpty) {
                      return Container(
                        margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Cancel Button
                            GestureDetector(
                              onTap: () {
                                controller.clearAllImages();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.blackColor.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.whiteColor,
                                  size: AppDimensions.iconMedium,
                                ),
                              ),
                            ),
                            Spacing.width(AppDimensions.paddingMedium),
                            
                            // Thumbnails List
                            Expanded(
                              child: Container(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.capturedImages.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 60,
                                      height: 80,
                                      margin: EdgeInsets.only(right: AppDimensions.marginSmall),
                                      decoration: BoxDecoration(
                                        color: AppColors.blackColor.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                                        border: Border.all(
                                          color: AppColors.whiteColor.withOpacity(0.5),
                                          width: 2,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall - 2),
                                            child: Image.file(
                                              controller.capturedImages[index],
                                              width: 60,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          // Image number badge
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: AppColors.blackColor.withOpacity(0.7),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: CommonText(
                                                text: '${index + 1}',
                                                fontSize: AppFontSizes.fontNeNoSmall,
                                                color: AppColors.whiteColor,
                                                fontWeight: AppFontWeights.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Spacing.width(AppDimensions.paddingMedium),
                            GestureDetector(
                              onTap: () {
                                final scanController = Get.find<  ScanController>();
                                scanController.capturedImages.value = controller.capturedImages;
                                if (controller.capturedImages.isNotEmpty) {
                                  scanController.currentImage.value = controller.capturedImages.last;
                                }
                                
                                // Navigate to editor
                                Get.off(() => const DocumentEditorScreen());
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.infoBlue,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                                ),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.whiteColor,
                                  size: AppDimensions.iconMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  
                  Spacing.height(AppDimensions.paddingMedium),
                  
                  // Capture Button
                  GestureDetector(
                    onTap: () async {
                      await controller.captureImage();
                    },
                    child: Container(
                      width: AppDimensions.paddingXLarge40,
                      height: AppDimensions.paddingXLarge40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.whiteColor, width: 5),
                        color: Colors.transparent,
                      ),
                      child: Obx(() => controller.isProcessing.value
                          ?  Padding(
                              padding: EdgeInsets.all(AppDimensions.paddingXMedium),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                                strokeWidth: 3,
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.all(AppDimensions.marginSmall),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.whiteColor,
                              ),
                            )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

