import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/screens/convert/widgets/conversion_dialog.dart';
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

  void showConversionDialog(BuildContext context) {
    ConversionDialog.show(
      context: context,
      onContinue: () {
        _startConversion();
      },
      onCancel: () {
        // AppConstants.showCommonSnackBar(
        //   message: 'Conversion cancelled',
        //   isError: false,
        // );
      },
    );
  }

  Future<void> _startConversion() async {
    // Simulate conversion process
    isLoading.value = true;
    
    // Show message that conversion started
    AppConstants.showCommonSnackBar(
      message: 'Conversion started in background',
      isError: false,
    );
    
    // Simulate some delay for conversion
    await Future.delayed(const Duration(seconds: 3));
    
    isLoading.value = false;
    
    // Show completion message
    AppConstants.showCommonSnackBar(
      message: 'Conversion completed successfully',
      isError: false,
    );
  }
}
