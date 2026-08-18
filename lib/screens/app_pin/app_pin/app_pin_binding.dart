import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/app_pin/app_pin/app_pin_controller.dart';

class AppPinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppPinController>(() => AppPinController());
  }
}
