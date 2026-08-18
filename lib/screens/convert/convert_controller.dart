import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';

class ConvertController extends GetxController {
  final ScanController scanController = Get.put(ScanController());
  
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
  }

  List<File> getFilteredFiles() {
    final allImages = scanController.capturedImages;
    if (searchQuery.value.isEmpty) {
      return allImages;
    }
    
    return allImages.where((image) {
      final fileName = image.path.split('/').last.toLowerCase();
      return fileName.contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }
}
