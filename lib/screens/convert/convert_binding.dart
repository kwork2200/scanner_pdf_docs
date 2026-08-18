import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/convert/convert_controller.dart';
import 'package:scanner_pdf_docs/screens/convert/convert_screen.dart';

class ConvertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConvertController>(() => ConvertController());
  }
}
