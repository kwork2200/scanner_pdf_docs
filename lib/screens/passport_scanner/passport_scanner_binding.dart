import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/passport_scanner/passport_scanner_controller.dart';
import 'package:scanner_pdf_docs/screens/passport_scanner/passport_scanner_screen.dart';

class PassportScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassportScannerController>(() => PassportScannerController());
  }
}
