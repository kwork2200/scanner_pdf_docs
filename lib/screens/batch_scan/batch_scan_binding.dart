import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/batch_scan/batch_scan_controller.dart';
import 'package:scanner_pdf_docs/screens/batch_scan/batch_scan_screen.dart';

class BatchScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BatchScanController>(() => BatchScanController());
  }
}
