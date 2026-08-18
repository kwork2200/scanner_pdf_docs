import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/extract_text/extract_text_controller.dart';
import 'package:scanner_pdf_docs/screens/extract_text/extract_text_screen.dart';

class ExtractTextBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExtractTextController>(() => ExtractTextController());
  }
}
