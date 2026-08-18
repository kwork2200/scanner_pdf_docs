import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/picture_quality/picture_quality_controller.dart';

class PictureQualityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PictureQualityController>(() => PictureQualityController());
  }
}
