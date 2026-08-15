import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/signature/signature_controller.dart';
import 'package:scanner_pdf_docs/screens/signature/signature_screen.dart';

class SignatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignatureController>(() => SignatureController());
  }
}
