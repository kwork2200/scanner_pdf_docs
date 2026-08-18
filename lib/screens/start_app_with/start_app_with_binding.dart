import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/start_app_with/start_app_with_controller.dart';

class StartAppWithBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartAppWithController>(() => StartAppWithController());
  }
}
