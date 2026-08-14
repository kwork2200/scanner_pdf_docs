import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class GalleryController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  
  RxList<File> galleryImages = <File>[].obs;
  RxBool isLoading = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    loadGalleryImages();
  }

  Future<void> loadGalleryImages() async {
    try {
      isLoading.value = true;
      
      // Request storage permission
      final storagePermission = await Permission.storage.request();
      if (!storagePermission.isGranted) {
        Get.snackbar('Permission', 'Storage permission is required');
        return;
      }

      // Get app's document directory
      final appDir = await getApplicationDocumentsDirectory();
      final files = appDir.listSync();
      
      galleryImages.clear();
      for (final file in files) {
        if (file.path.endsWith('.jpg') || 
            file.path.endsWith('.jpeg') || 
            file.path.endsWith('.png')) {
          galleryImages.add(File(file.path));
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load gallery: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        // Copy to app directory
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'gallery_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedPath = path.join(appDir.path, fileName);
        
        await File(image.path).copy(savedPath);
        galleryImages.add(File(savedPath));
        
        Get.snackbar('Success', 'Image added to gallery');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image != null) {
        // Copy to app directory
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'camera_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedPath = path.join(appDir.path, fileName);
        
        await File(image.path).copy(savedPath);
        galleryImages.add(File(savedPath));
        
        Get.snackbar('Success', 'Image added to gallery');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image: $e');
    }
  }

  void selectImage(File imageFile) {
    selectedImage.value = imageFile;
  }

  void deleteImage(int index) {
    if (index >= 0 && index < galleryImages.length) {
      final imageFile = galleryImages[index];
      imageFile.deleteSync();
      galleryImages.removeAt(index);
      
      if (selectedImage.value == imageFile) {
        selectedImage.value = null;
      }
    }
  }

  Future<void> shareImage(int index) async {
    // This would require a share plugin like share_plus
    // For now, just show a snackbar
    Get.snackbar('Info', 'Share feature coming soon');
  }

  Future<void> clearGallery() async {
    try {
      for (final image in galleryImages) {
        await image.delete();
      }
      galleryImages.clear();
      selectedImage.value = null;
      Get.snackbar('Success', 'Gallery cleared');
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear gallery: $e');
    }
  }
}