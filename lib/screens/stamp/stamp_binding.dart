import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/stamp/stamp_controller.dart';
import 'package:scanner_pdf_docs/screens/stamp/stamp_screen.dart';

class StampBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StampController>(() => StampController());
  }
}
