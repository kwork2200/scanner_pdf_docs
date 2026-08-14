import 'package:get/get.dart';
import 'id_card_scanner_controller.dart';

class IdCardScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IdCardScannerController>(() => IdCardScannerController());
  }
}
