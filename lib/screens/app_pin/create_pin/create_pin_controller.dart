import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/app_pin/app_pin/app_pin_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';

class CreatePinController extends GetxController {
  final currentPin = ''.obs;
  final isConfirming = false.obs;
  final showError = false.obs;
  final mode = 'create'.obs;
  String? firstPin;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['mode'] != null) {
      mode.value = args['mode'];
    }
  }

  String get title {
    if (mode.value == 'verify') {
      return AppTexts.enterPin;
    }
    return isConfirming.value ? AppTexts.confirmPin : AppTexts.createPin;
  }

  void addDigit(String digit) {
    if (currentPin.value.length < 4) {
      currentPin.value += digit;
      showError.value = false;
      
      if (currentPin.value.length == 4) {
        _processPinComplete();
      }
    }
  }

  void removeDigit() {
    if (currentPin.value.isNotEmpty) {
      currentPin.value = currentPin.value.substring(0, currentPin.value.length - 1);
      showError.value = false;
    }
  }

  Future<void> _processPinComplete() async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (mode.value == 'verify') {
      await _verifyPin();
    } else {
      await _createPin();
    }
  }

  Future<void> _verifyPin() async {
    final savedPin = await AppPinController.getSavedPin();
    
    if (currentPin.value == savedPin) {
      Get.back();
      
      AppConstants.showCommonSnackBar(
        message: AppTexts.pinVerified,
        isSuccess: true,
      );
    } else {
      // PIN is incorrect
      showError.value = true;
      currentPin.value = '';
    }
  }

  Future<void> _createPin() async {
    if (!isConfirming.value) {
      firstPin = currentPin.value;
      isConfirming.value = true;
      currentPin.value = '';
    } else {
      if (currentPin.value == firstPin) {
        await AppPinController.savePin(currentPin.value);
        
        final appPinController = Get.find<AppPinController>();
        await appPinController.enablePin();
        
        Get.back(result: true);
        
        AppConstants.showCommonSnackBar(
          message: AppTexts.pinSetSuccessfully,
          isSuccess: true,
        );
      } else {
        AppConstants.showCommonSnackBar(
          message: AppTexts.pinsDoNotMatch,
          isError: true,
        );
        
        isConfirming.value = false;
        firstPin = null;
        currentPin.value = '';
      }
    }
  }
}
