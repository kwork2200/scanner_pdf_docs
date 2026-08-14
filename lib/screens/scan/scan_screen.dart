import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class ScanScreen extends GetView<ScanController> {
  ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }

        return Stack(
          children: [
            // Camera Preview
            Center(
              child: CameraPreview(controller.cameraController!),
            ),
            
            // Document Detection Overlay
            Positioned.fill(
              child: CustomPaint(
                painter: DocumentOverlayPainter(),
              ),
            ),
            
            // Top Controls
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon:  Icon(Icons.close, color: AppColors.whiteColor, size: AppDimensions.iconLarge),
                    onPressed: () => Get.back(),
                  ),
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
                  IconButton(
                    icon:  Icon(Icons.flip_camera_ios, color: AppColors.whiteColor, size: AppDimensions.iconLarge),
                    onPressed: controller.switchCamera,
                  ),
                ],
              ),
            ),
            
            // Bottom Controls
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Capture Button
                  GestureDetector(
                    onTap: controller.captureImage,
                    child: Container(
                      width: AppDimensions.paddingXLarge40,
                      height: AppDimensions.paddingXLarge40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.whiteColor, width: 4),
                        color: AppColors.whiteColor.withOpacity(0.3),
                      ),
                      child: Obx(() => controller.isProcessing.value
                          ?  Padding(
                              padding: EdgeInsets.all(AppDimensions.paddingXMedium),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                                strokeWidth: 2,
                              ),
                            )
                          :  Icon(
                              Icons.camera_alt,
                              color: AppColors.whiteColor,
                              size: AppDimensions.iconLarge,
                            )),
                    ),
                  ),
                  
                  Spacing.height(20),
                  
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.photo_library,
                        label: AppTexts.chooseFromGallery,
                        onTap: () => Get.toNamed(AppRoutes.gallery),
                      ),
                      _buildActionButton(
                        icon: Icons.document_scanner,
                        label: AppTexts.detectEdges,
                        onTap: controller.detectDocument,
                      ),
                      _buildActionButton(
                        icon: Icons.save,
                        label: AppTexts.save,
                        onTap: controller.saveToGallery,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Detected Text Preview
            Obx(() => controller.detectedText.value.isNotEmpty
                ? Positioned(
                    top: 100,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: AppTexts.ocrText,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          Spacing.height(8),
                          CommonText(
                            text: controller.detectedText.value,
                            color: Colors.white,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        );
      }),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onTap,
          ),
        ),
        Spacing.height(8),
        CommonText(
          text: label,
          color: Colors.white,
        ),
      ],
    );
  }
}

class DocumentOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.8,
      height: size.height * 0.6,
    );

    // Draw document frame
    canvas.drawRect(rect, paint);

    // Draw corner markers
    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cornerSize = 20.0;

    // Top-left corner
    canvas.drawRect(
      Rect.fromLTWH(rect.left - cornerSize / 2, rect.top - cornerSize / 2, cornerSize, cornerSize),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawRect(
      Rect.fromLTWH(rect.right - cornerSize / 2, rect.top - cornerSize / 2, cornerSize, cornerSize),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawRect(
      Rect.fromLTWH(rect.left - cornerSize / 2, rect.bottom - cornerSize / 2, cornerSize, cornerSize),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawRect(
      Rect.fromLTWH(rect.right - cornerSize / 2, rect.bottom - cornerSize / 2, cornerSize, cornerSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}