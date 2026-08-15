import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/count_objects/count_objects_controller.dart';

class CountObjectsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CountObjectsController>(() => CountObjectsController());
  }
}
