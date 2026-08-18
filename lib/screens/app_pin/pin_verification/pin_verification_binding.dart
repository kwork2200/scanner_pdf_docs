import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/app_pin/pin_verification/pin_verification_controller.dart';

class PinVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinVerificationController>(() => PinVerificationController());
  }
}
