import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/screens/app_pin/app_pin/app_pin_controller.dart';

class AppLifecycleService extends GetxController with WidgetsBindingObserver {
  static AppLifecycleService get to => Get.find();
  
  final isAppInBackground = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        isAppInBackground.value = true;
        break;
        
      case AppLifecycleState.resumed:
        if (isAppInBackground.value) {
          _checkPinAndNavigate();
          isAppInBackground.value = false;
        }
        break;
        
      default:
        break;
    }
  }

  Future<void> _checkPinAndNavigate() async {
    final isPinEnabled = await AppPinController.isPinSet();
    
    if (isPinEnabled) {
      final currentRoute = Get.currentRoute;
      
      if (currentRoute != AppRoutes.pinVerification &&
          currentRoute != AppRoutes.createPin &&
          currentRoute != AppRoutes.appPin &&
          currentRoute != AppRoutes.splash) {
        Get.toNamed(AppRoutes.pinVerification);
      }
    }
  }
}
