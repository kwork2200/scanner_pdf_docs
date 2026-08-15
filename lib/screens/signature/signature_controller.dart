import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';

class SignatureController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final ScanController scanController = Get.put(ScanController());
  
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> pickSignatureFromGallery() async {
    try {
      isLoading.value = true;
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        await _saveSignature(File(image.path));
      }
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: 'Failed to pick signature: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> captureSignature() async {
    try {
      isLoading.value = true;
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image != null) {
        await _saveSignature(File(image.path));
      }
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: 'Failed to capture signature: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveSignature(File imageFile) async {
    try {
      await Gal.putImage(imageFile.path);

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'signature_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${appDir.path}/$fileName';
      await imageFile.copy(savedPath);
      
      await scanController.addFile(File(savedPath));

      AppConstants.showCommonSnackBar(
        message: 'Signature saved to gallery and recent files',
      );
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: 'Failed to save signature: $e',
        isError: true,
      );
    }
  }

  List<File> getFilteredSignatures() {
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
