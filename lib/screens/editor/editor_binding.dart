import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';

class EditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanController>(() => ScanController());
  }
}
