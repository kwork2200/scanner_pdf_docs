                                                                  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner_pdf_docs/screens/qr_scanner/qr_scanner_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class QrScannerScreen extends GetView<QrScannerController> {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: AppColors.whiteColor,
            size: 28.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: CommonText(
          text: AppTexts.scanQrCode,
          fontSize: AppFontSizes.font18,
          fontWeight: AppFontWeights.semiBold,
          color: AppColors.whiteColor,
        ),
        centerTitle: true,
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              controller.flashOn.value ? Icons.flash_on : Icons.flash_off,
              color: AppColors.whiteColor,
              size: 24.sp,
            ),
            onPressed: controller.toggleFlash,
          )),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller.cameraController,
            onDetect: controller.onDetect,
            fit: BoxFit.cover,
          ),
          Center(
            child: Obx(() => !controller.isScanned.value 
                ? _buildScanningFrame()
                : _buildScannedFrame()),
          ),
          Obx(() => controller.isScanned.value && controller.scannedData.value != null
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.all(AppDimensions.paddingMedium),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSmall,
                      vertical: AppDimensions.paddingMedium,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blackColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.infoBlue.withValues(alpha: 0.5),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppDimensions.paddingSmall),
                          decoration: BoxDecoration(
                            color: AppColors.grey600.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: CommonText(
                                  text: controller.scannedData.value!,
                                  fontSize: AppFontSizes.fontSmall,
                                  color: AppColors.whiteColor,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                               InkWell(
                                onTap: () => controller.copyToClipboard(controller.scannedData.value!),
                                child: Icon(
                                  Icons.content_copy,
                                  color: AppColors.whiteColor,
                                  size: 18.sp,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: AppDimensions.paddingSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildActionButton(
                              icon: Icons.arrow_forward,
                              label: AppTexts.open,
                              onTap: () => controller.openLink(controller.scannedData.value!),
                            ),
                            SizedBox(width: AppDimensions.paddingSmall),
                            _buildActionButton(
                              icon: Icons.delete_outline,
                              label: 'Delete',
                              onTap: controller.deleteScannedData,
                              color: AppColors.redColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Positioned(
                  bottom: 50.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingLarge,
                        vertical: AppDimensions.paddingMedium,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blackColor.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: CommonText(
                        text: AppTexts.positionQrCode,
                        fontSize: AppFontSizes.font14,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildScanningFrame() {
    return Container(
      width: 280.w,
      height: 280.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.infoBlue,
          width: 2.w,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: _buildScanningAnimation(),
    );
  }

  Widget _buildScannedFrame() {
    return Container(
      width: 280.w,
      height: 280.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greenColor,
          width: 3.w,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Icon(
          Icons.check_circle,
          color: AppColors.greenColor,
          size: 48.sp,
        ),
      ),
    );
  }

  Widget _buildScanningAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return SizedBox(
          height: 280.h,
          width: 280.w,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.infoBlue, width: 3.w),
                      left: BorderSide(color: AppColors.infoBlue, width: 3.w),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.infoBlue, width: 3.w),
                      right: BorderSide(color: AppColors.infoBlue, width: 3.w),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.infoBlue, width: 3.w),
                      left: BorderSide(color: AppColors.infoBlue, width: 3.w),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.infoBlue, width: 3.w),
                      right: BorderSide(color: AppColors.infoBlue, width: 3.w),
                    ),
                  ),
                ),
              ),
              // Scanning line
              Positioned(
                top: value * 260.h,
                left: 0,
                right: 0,
                child: Container(
                  height: 2.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.infoBlue,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onEnd: () {
        if (!controller.isScanned.value) {
          controller.cameraController.start();
        }
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: (color ?? AppColors.infoBlue).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(
            color: color ?? AppColors.infoBlue,
            width: 1.0.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color ?? AppColors.whiteColor,
              size: 20.sp,
            ),
            SizedBox(width: 4.h),
            CommonText(
              text: label,
              fontSize: AppFontSizes.font14,
              color: color ?? AppColors.whiteColor,
              fontWeight: AppFontWeights.medium,
            ),
          ],
        ),
      ),
    );
  }
}
