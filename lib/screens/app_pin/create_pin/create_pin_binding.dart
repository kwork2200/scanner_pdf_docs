import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/app_pin/create_pin/create_pin_controller.dart';

class CreatePinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePinController>(() => CreatePinController());
  }
}
