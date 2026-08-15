import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/tools/tools_controller.dart';

class ToolsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToolsController>(() => ToolsController());
  }
}
