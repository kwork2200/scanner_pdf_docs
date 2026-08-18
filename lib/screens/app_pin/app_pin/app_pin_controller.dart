import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';

class AppPinController extends GetxController {
  final isPinEnabled = false.obs;
  
  static const String _pinEnabledKey = 'app_pin_enabled';
  static const String _savedPinKey = 'app_pin_code';

  @override
  void onInit() {
    super.onInit();
    loadPinStatus();
  }

  Future<void> loadPinStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isPinEnabled.value = prefs.getBool(_pinEnabledKey) ?? false;
  }

  Future<void> togglePin(bool value) async {
    if (value) {
      final result = await Get.toNamed(AppRoutes.createPin, arguments: {'mode': 'create'});
      if (result == true) {
        isPinEnabled.value = true;
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_pinEnabledKey, false);
      await prefs.remove(_savedPinKey);
      isPinEnabled.value = false;
      
      Get.snackbar(
        'Success',
        'App PIN has been disabled',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.successGreen,
        colorText: AppColors.whiteColor,
        margin: EdgeInsets.all(AppDimensions.paddingMedium),
      );
    }
  }

  Future<void> enablePin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pinEnabledKey, true);
    isPinEnabled.value = true;
  }

  void openEnterPin() {
    Get.toNamed(AppRoutes.createPin, arguments: {'mode': 'verify'});
  }

  static Future<String?> getSavedPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedPinKey);
  }

  static Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedPinKey, pin);
  }

  static Future<bool> isPinSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_pinEnabledKey) ?? false;
  }
}
