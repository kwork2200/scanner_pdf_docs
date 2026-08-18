import 'package:get/get.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/screens/app_pin/app_pin/app_pin_controller.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToHome();
  }

  void navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final isPinSet = await AppPinController.isPinSet();
    
    if (isPinSet) {
      Get.offNamed(AppRoutes.pinVerification);
    } else {
      Get.offNamed(AppRoutes.bottomNavBar);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
