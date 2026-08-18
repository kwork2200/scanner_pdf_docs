import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/app_pin/app_pin/app_pin_controller.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';

class PinVerificationController extends GetxController {
  final currentPin = ''.obs;
  final showError = false.obs;
  final remainingAttempts = 3.obs;

  void addDigit(String digit) {
    if (currentPin.value.length < 4) {
      currentPin.value += digit;
      showError.value = false;
      
      if (currentPin.value.length == 4) {
        _verifyPin();
      }
    }
  }

  void removeDigit() {
    if (currentPin.value.isNotEmpty) {
      currentPin.value = currentPin.value.substring(0, currentPin.value.length - 1);
      showError.value = false;
    }
  }

  Future<void> _verifyPin() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final savedPin = await AppPinController.getSavedPin();
    
    if (currentPin.value == savedPin) {
      // PIN is correct, navigate to main app
      Get.offNamed(AppRoutes.bottomNavBar);
    } else {
      // PIN is incorrect
      remainingAttempts.value--;
      showError.value = true;
      currentPin.value = '';
      
      if (remainingAttempts.value <= 0) {
        // No more attempts, show message and reset
        AppConstants.showCommonSnackBar(
          message: 'Too many incorrect attempts. Please try again later.',
          isError: true,
        );
        remainingAttempts.value = 3;
      } else {
        AppConstants.showCommonSnackBar(
          message: '${AppTexts.incorrectPin}. ${remainingAttempts.value} attempts remaining.',
          isError: true,
        );
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    remainingAttempts.value = 3;
  }
}
