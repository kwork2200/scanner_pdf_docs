import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/splash/splash_controller.dart';
import 'package:scanner_pdf_docs/services/app_lifecycle_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.put(AppLifecycleService(), permanent: true);
  }
}
