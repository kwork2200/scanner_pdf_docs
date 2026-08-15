import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:scanner_pdf_docs/screens/count_objects/count_objects_controller.dart';
import 'package:scanner_pdf_docs/screens/count_objects/widget/object_overlay_painter.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class CountObjectsScreen extends GetView<CountObjectsController> {
  const CountObjectsScreen({super.key});

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
          text: 'Count Objects',
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
      body: GetBuilder<CountObjectsController>(
        init: controller,
        builder: (_) {
          return Obx(() {
            // Show result screen if objects detected
            if (controller.capturedImage.value != null) {
              return _buildResultScreen();
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

          return SizedBox.expand(
            child: CameraPreview(controller.cameraController),
          );
        }),
        // Instruction overlay
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
            child: Column(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: AppColors.infoBlue,
                  size: 32.sp,
                ),
                SizedBox(height: AppDimensions.paddingSmall),
                CommonText(
                  text: 'Point camera at objects to count them',
                  color: AppColors.backgroundColor,
                  fontSize: AppFontSizes.font14,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              color: AppColors.blackColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
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
                    size: 32.sp,
                  ),
                ),
                Obx(() => GestureDetector(
                  onTap: controller.isProcessing.value
                      ? null
                      : controller.captureAndCountObjects,
                  child: Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.backgroundColor,
                        width: 4.w,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.isProcessing.value
                              ? AppColors.grey400
                              : AppColors.backgroundColor,
                        ),
                        child: controller.isProcessing.value
                            ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.blackColor,
                          ),
                        )
                            : null,
                      ),
                    ),
                  ),
                )),
                SizedBox(width: 48.w), // Spacer
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    return Stack(
      children: [
        // Show captured image
        Positioned.fill(
          child: Image.file(
            controller.capturedImage.value!,
            fit: BoxFit.contain,
          ),
        ),
        // Draw bounding boxes and numbers on detected objects
        Positioned.fill(
          child: Obx(() {
            final size = controller.imageSize.value;
            if (controller.detectedObjects.isEmpty || size == null) {
              return const SizedBox.shrink();
            }

            // LayoutBuilder gives us the actual on-screen size of this
            // Positioned.fill area, which matches the Image.file above
            // (since both fill the same Stack area). The painter uses
            // this plus the real image pixel size to correctly map
            // ML Kit's bounding boxes (image space) onto the canvas
            // (screen space) using the same math as BoxFit.contain.
            return LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: ObjectOverlayPainter(
                    objects: controller.detectedObjects,
                    imageSize: size,
                  ),
                );
              },
            );
          }),
        ),
        // // Count overlay at top
        // Positioned(
        //   top: AppDimensions.paddingLarge,
        //   left: 0,
        //   right: 0,
        //   child: Center(
        //     child: Container(
        //       padding: EdgeInsets.symmetric(
        //         horizontal: AppDimensions.paddingLarge,
        //         vertical: AppDimensions.paddingMedium,
        //       ),
        //       decoration: BoxDecoration(
        //         color: AppColors.infoBlue.withValues(alpha: 0.9),
        //         borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        //       ),
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           CommonText(
        //             text: 'Objects Detected',
        //             color: AppColors.backgroundColor,
        //             fontSize: AppFontSizes.font14,
        //             fontWeight: AppFontWeights.medium,
        //           ),
        //           SizedBox(height: AppDimensions.paddingSmall),
        //           Obx(() => CommonText(
        //             text: '${controller.objectCount.value}',
        //             color: AppColors.backgroundColor,
        //             fontSize: 48.sp,
        //             fontWeight: AppFontWeights.bold,
        //           )),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              color: AppColors.blackColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.retake,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retake'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.infoOrange,
                      foregroundColor: AppColors.backgroundColor,
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: Obx(() => ElevatedButton.icon(
                    onPressed: controller.isProcessing.value
                        ? null
                        : controller.saveResult,
                    icon: controller.isProcessing.value
                        ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.backgroundColor,
                      ),
                    )
                        : const Icon(Icons.check),
                    label: const Text('Done'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen,
                      foregroundColor: AppColors.backgroundColor,
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSmall),
                      ),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}