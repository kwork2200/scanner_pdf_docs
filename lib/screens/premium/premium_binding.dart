import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/premium/premium_controller.dart';

class PremiumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PremiumController>(() => PremiumController());
  }
}
