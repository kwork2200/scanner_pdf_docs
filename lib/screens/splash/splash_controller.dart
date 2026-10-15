import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/ads/app_open_ad_manager.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/screens/app_pin/app_pin/app_pin_controller.dart';
import 'package:scanner_pdf_docs/utils/functions.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToHome();
  }

  void navigateToHome() async {
    // Wait for 3 seconds on splash screen
    await Future.delayed(const Duration(seconds: 3));
    
    final isPinSet = await AppPinController.isPinSet();
    
    // Navigate to appropriate screen
    if (isPinSet) {
      Get.offNamed(AppRoutes.pinVerification);
    } else {
      Get.offNamed(AppRoutes.bottomNavBar);
    }
    
    // Small delay to let navigation complete
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Wait for ad to be ready (max 5 seconds total wait)
    if (!AppOpenAdManager.instance.isAdAvailable) {
      print('⏳ App Open Ad not ready yet, waiting...');
      int attempts = 0;
      while (!AppOpenAdManager.instance.isAdAvailable && attempts < 10) {
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      }
    }
    
    // Try to show ad only once after waiting is done
    if (AppOpenAdManager.instance.isAdAvailable) {
      print('✅ App Open Ad ready, showing now...');
      AppOpenAdManager.instance.showAdIfAvailable(
        onAdDismissed: () {
          print('🔹 App Open Ad dismissed, app is ready');
        },
      );
    } else {
      print('⚠️ App Open Ad could not load, skipping...');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
