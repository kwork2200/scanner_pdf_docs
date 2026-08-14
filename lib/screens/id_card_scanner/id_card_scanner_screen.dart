import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/id_card_scanner/id_card_scanner_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class IdCardScannerScreen extends GetView<IdCardScannerController> {
  const IdCardScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.backgroundColor),
          onPressed: () => Get.back(),
        ),
        title: CommonText(
          text: AppTexts.scanIdCard,
          color: AppColors.backgroundColor,
          fontSize: AppFontSizes.font18,
          fontWeight: AppFontWeights.semiBold,
        ),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isFlashOn.value ? Icons.flash_on : Icons.flash_off,
                  color: AppColors.backgroundColor,
                ),
                onPressed: controller.toggleFlash,
              )),
        ],
      ),
      body: GetBuilder<IdCardScannerController>(
        init: controller,
        builder: (_) {
          return Obx(() {
            // Show preview screen if image is captured
            if (controller.capturedImage.value != null) {
              return _buildPreviewScreen();
            }
            
            // Show camera view
            return _buildCameraView();
          });
        },
      ),
    );
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        Obx(() {
          if (!controller.isCameraInitialized.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.infoBlue,
              ),
            );
          }

          // Proper camera preview without stretching
          return SizedBox.expand(
            child: CameraPreview(controller.cameraController),
          );
        }),
        CustomPaint(
          painter: IdCardFramePainter(),
          size: Size.infinite,
        ),
        Positioned(
          top: AppDimensions.paddingLarge,
          left: AppDimensions.paddingLarge,
          right: AppDimensions.paddingLarge,
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.blackColor.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: CommonText(
              text: 'Position ID card in frame with photo visible',
              color: AppColors.backgroundColor,
              fontSize: AppFontSizes.font14,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Obx(() {
          if (controller.isCardDetected.value && controller.detectedText.isNotEmpty) {
            return Positioned(
              bottom: AppDimensions.positionBottom,
              left: AppDimensions.paddingLarge,
              right: AppDimensions.paddingLarge,
              child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: CommonText(
                  text: '✓ ID Card Detected',
                  color: AppColors.backgroundColor,
                  fontSize: AppFontSizes.font14,
                  fontWeight: AppFontWeights.semiBold,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          // Show scanning indicator when processing
          if (controller.isProcessing.value) {
            return Positioned(
              bottom: AppDimensions.positionBottom,
              left: AppDimensions.paddingLarge,
              right: AppDimensions.paddingLarge,
              child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.infoBlue.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: AppDimensions.loadingSmall,
                      height: AppDimensions.loadingSmall,
                      child: CircularProgressIndicator(
                        strokeWidth: AppDimensions.strokeThin,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                    Spacing.width(AppDimensions.paddingSmall),
                    CommonText(
                      text: 'Detecting ID card...',
                      color: AppColors.backgroundColor,
                      fontSize: AppFontSizes.font14,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              color: AppColors.blackColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusLarge),
                topRight: Radius.circular(AppDimensions.radiusLarge),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: controller.pickFromGallery,
                  icon: Icon(
                    Icons.photo_library,
                    color: AppColors.backgroundColor,
                    size: AppDimensions.iconLarge,
                  ),
                ),
                GestureDetector(
                  onTap: controller.captureIdCard,
                  child: Container(
                    width: AppDimensions.buttonMedium,
                    height: AppDimensions.buttonMedium,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.backgroundColor,
                        width: AppDimensions.borderWidthMedium,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.borderWidthThin),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                // Auto capture is always ON for ID cards
                Spacing.width(48.w), // Spacer for layout balance
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewScreen() {
    return Stack(
      children: [
        // Show captured image
        Positioned.fill(
          child: Image.file(
            controller.capturedImage.value!,
            fit: BoxFit.contain,
          ),
        ),
        // Overlay with buttons
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              color: AppColors.blackColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusLarge),
                topRight: Radius.circular(AppDimensions.radiusLarge),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText(
                  text: AppTexts.idCardDetected,
                  color: AppColors.successGreen,
                  fontSize: AppFontSizes.font16,
                  fontWeight: AppFontWeights.semiBold,
                ),
                Spacing.height(AppDimensions.paddingLarge),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.retakePhoto,
                        icon: const Icon(Icons.refresh),
                        label: CommonText(
                          text: AppTexts.retake,
                          color: AppColors.backgroundColor,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.infoOrange,
                          foregroundColor: AppColors.backgroundColor,
                          padding: EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingMedium,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          ),
                        ),
                      ),
                    ),
                    Spacing.width(AppDimensions.paddingMedium),
                    Expanded(
                      child: Obx(() => ElevatedButton.icon(
                            onPressed: controller.isProcessing.value
                                ? null
                                : controller.confirmAndSaveIdCard,
                            icon: controller.isProcessing.value
                                ? SizedBox(
                                    width: AppDimensions.loadingSmall,
                                    height: AppDimensions.loadingSmall,
                                    child: CircularProgressIndicator(
                                      strokeWidth: AppDimensions.strokeThin,
                                      color: AppColors.backgroundColor,
                                    ),
                                  )
                                : const Icon(Icons.check),
                            label: CommonText(
                              text: AppTexts.done,
                              color: AppColors.backgroundColor,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.successGreen,
                              foregroundColor: AppColors.backgroundColor,
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimensions.paddingMedium,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class IdCardFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.backgroundColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppDimensions.strokeMedium;

    // Adjusted frame size - smaller width for better fit
    final frameWidth = size.width * 0.75;  // Reduced from 0.85 to 0.75
    final frameHeight = frameWidth / 1.586;  // Standard ID card aspect ratio
    final left = (size.width - frameWidth) / 2;
    final top = (size.height - frameHeight) / 2;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, frameWidth, frameHeight),
      Radius.circular(AppDimensions.radiusMedium),
    );
    canvas.drawRRect(rect, paint);

    final cornerPaint = Paint()
      ..color = AppColors.infoBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppDimensions.strokeThick
      ..strokeCap = StrokeCap.round;

    final cornerLength = AppDimensions.cornerLength;

    canvas.drawLine(
      Offset(left, top + cornerLength),
      Offset(left, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(left + frameWidth - cornerLength, top),
      Offset(left + frameWidth, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + frameWidth, top),
      Offset(left + frameWidth, top + cornerLength),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(left, top + frameHeight - cornerLength),
      Offset(left, top + frameHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + frameHeight),
      Offset(left + cornerLength, top + frameHeight),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(left + frameWidth - cornerLength, top + frameHeight),
      Offset(left + frameWidth, top + frameHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + frameWidth, top + frameHeight - cornerLength),
      Offset(left + frameWidth, top + frameHeight),
      cornerPaint,
    );

    final overlayPaint = Paint()
      ..color = AppColors.blackColor.withValues(alpha: 0.5);

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(rect),
      ),
      overlayPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
