import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:scanner_pdf_docs/screens/splash/splash_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_images.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.navigateToHome();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180.w,
              height: 180.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(AppImages.pdfLogo, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 30.h),
            CommonText(
              text: AppTexts.appTitle,
              fontSize: AppFontSizes.fontXLarge,
              fontWeight: AppFontWeights.bold,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 8.h),
            CommonText(
              text: AppTexts.splashSubtitle,
              fontSize: AppFontSizes.font14,
              fontWeight: AppFontWeights.regular,
              color: AppColors.infoBlue,
            ),
          ],
        ),
      ),
    );
  }
}
