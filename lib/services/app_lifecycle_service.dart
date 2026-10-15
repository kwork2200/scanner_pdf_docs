import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/ads/app_open_ad_manager.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/screens/app_pin/app_pin/app_pin_controller.dart';

class AppLifecycleService extends GetxController with WidgetsBindingObserver {
  static AppLifecycleService get to => Get.find();

  final isAppInBackground = false.obs;
  bool _isFirstResume = true;
  DateTime? _lastAdShownTime;

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
        if (!AppOpenAdManager.instance.isAdAvailable) {
          AppOpenAdManager.instance.loadAd();
        }
        break;

      case AppLifecycleState.resumed:
        if (_isFirstResume) {
          print('🔹 First resume - skipping ad (handled by splash)');
          _isFirstResume = false;
          return;
        }
        if (isAppInBackground.value) {
          if (_lastAdShownTime != null) {
            final timeSinceLastAd = DateTime.now().difference(_lastAdShownTime!);
            if (timeSinceLastAd.inSeconds < 10) {
              print('🔹 Ad shown recently (${timeSinceLastAd.inSeconds}s ago), skipping');
              isAppInBackground.value = false;
              return;
            }
          }
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
    } else {
      final currentRoute = Get.currentRoute;
      if (currentRoute != AppRoutes.splash) {
        await Future.delayed(const Duration(milliseconds: 300));
        _lastAdShownTime = DateTime.now(); // Record ad show time
        AppOpenAdManager.instance.showAdIfAvailable(
          onAdDismissed: () {
            print('🔹 App Open Ad dismissed on resume');
          },
        );
      }
    }
  }
}
