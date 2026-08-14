import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/qr_scanner/qr_scanner_controller.dart';

class QrScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrScannerController>(() => QrScannerController());
  }
}
