import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/screens/editor/image_editor_screen.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class CameraScanScreen extends GetView<ScanController> {
  const CameraScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
            ),
          );
        }

        return Stack(
          children: [
            // Camera Preview
            Positioned.fill(
              child: CameraPreview(controller.cameraController!),
            ),
            
            // Document Frame Overlay
            Positioned.fill(
              child: CustomPaint(
                painter: DocumentFramePainter(),
              ),
            ),
            
            // Top Controls
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close Button
                    IconButton(
                      icon:  Icon(Icons.close, color: AppColors.whiteColor, size: AppDimensions.iconLarge),
                      onPressed: () => Get.back(),
                    ),
                    
                    // Flash Toggle
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
            
            // Bottom Controls
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Done Button (shows after capture)
                  Obx(() {
                    if (controller.currentImage.value != null) {
                      return Container(
                        margin: EdgeInsets.only(bottom: AppDimensions.paddingXMedium),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to Image Editor Screen (not document editor)
                            if (controller.currentImage.value != null) {
                              Get.off(() => ImageEditorScreen(
                                imageFile: controller.currentImage.value!,
                              ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.infoBlue,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingXLarge40,
                              vertical: AppDimensions.paddingXMedium,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                            ),
                          ),
                          child: CommonText(
                            text: AppTexts.done,
                            fontSize: AppFontSizes.fontLarge,
                            color: AppColors.whiteColor,
                            fontWeight: AppFontWeights.bold,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  
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

class DocumentFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Document frame
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.85,
      height: size.height * 0.65,
    );

    // Draw rounded rectangle
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    canvas.drawRRect(rrect, paint);

    // Corner markers
    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final cornerLength = 30.0;

    // Top-left corner
    canvas.drawLine(
      Offset(rect.left, rect.top + cornerLength),
      Offset(rect.left, rect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left + cornerLength, rect.top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(rect.right - cornerLength, rect.top),
      Offset(rect.right, rect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right, rect.top + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(rect.left, rect.bottom - cornerLength),
      Offset(rect.left, rect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left + cornerLength, rect.bottom),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(rect.right - cornerLength, rect.bottom),
      Offset(rect.right, rect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.bottom - cornerLength),
      Offset(rect.right, rect.bottom),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
