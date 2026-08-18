import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';

class ExtractTextController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final textRecognizer = TextRecognizer();
  late ScanController scanController;
  
  final selectedImage = Rx<File?>(null);
  final extractedText = ''.obs;
  final isProcessing = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize scan controller
    if (Get.isRegistered<ScanController>()) {
      scanController = Get.find<ScanController>();
    } else {
      scanController = Get.put(ScanController());
    }
  }
  
  @override
  void onClose() {
    textRecognizer.close();
    super.onClose();
  }
  
  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        extractedText.value = '';
      }
    } catch (e) {
      debugPrint('Error picking from gallery: $e');
    }
  }
  
  Future<void> pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        extractedText.value = '';
      }
    } catch (e) {
      debugPrint('Error picking from camera: $e');
    }
  }
  
  Future<void> extractText() async {
    if (selectedImage.value == null || isProcessing.value) return;
    
    try {
      isProcessing.value = true;
      
      final inputImage = InputImage.fromFilePath(selectedImage.value!.path);
      final recognizedText = await textRecognizer.processImage(inputImage);
      
      extractedText.value = recognizedText.text;
      await scanController.addFile(selectedImage.value!);
      
    } catch (e) {
      debugPrint('Error extracting text: $e');
      extractedText.value = 'Failed to extract text';
    } finally {
      isProcessing.value = false;
    }
  }
  
  Future<void> copyText() async {
    try {
      // If text is not extracted yet, extract it first
      if (extractedText.value.isEmpty && selectedImage.value != null) {
        await extractText();
      }
      
      // Copy to clipboard if extraction was successful
      if (extractedText.value.isNotEmpty && !extractedText.value.contains('Failed to extract')) {
        await Clipboard.setData(ClipboardData(text: extractedText.value));
      }
    } catch (e) {
      debugPrint('Error in copyText: $e');
    }
  }
}
