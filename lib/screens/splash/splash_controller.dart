import 'package:get/get.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToHome();
  }

  void navigateToHome() {
    Future.delayed(const Duration(seconds: 7), () {
      Get.offNamed(AppRoutes.bottomNavBar);
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
