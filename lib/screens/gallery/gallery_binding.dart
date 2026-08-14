import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/gallery/gallery_controller.dart';

class GalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GalleryController>(() => GalleryController());
  }
}
