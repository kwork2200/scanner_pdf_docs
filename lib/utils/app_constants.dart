import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';

class AppConstants {
  static final ImagePicker _imagePicker = ImagePicker();

  static showCommonSnackBar({required String message, bool isError = false, BuildContext? context}) {
    Get.snackbar(
      "",
      message,
      titleText: const SizedBox(),
      backgroundColor: isError ? AppColors.redAccentColor : AppColors.primaryColor,
      colorText: AppColors.whiteColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.only(bottom: 30.h, left: 16.w, right: 16.w),
      duration: const Duration(seconds: 2),
    );
  }

  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }
  static String getFileSize(File file) {
    try {
      final bytes = file.lengthSync();
      if (bytes < 1024) {
        return '$bytes B';
      } else if (bytes < 1024 * 1024) {
        return '${(bytes / 1024).toStringAsFixed(1)} KB';
      } else {
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
    } catch (e) {
      return '0 KB';
    }
  }


  static Future<void> pickFiles({
    required Function(List<String>) onFilesSelected,
    bool allowMultiple = true,
  }) async {
    try {
      final List<XFile> files = await _imagePicker.pickMultipleMedia(
        imageQuality: 100,
      );
      
      if (files.isNotEmpty) {
        final List<String> filePaths = files.map((file) => file.path).toList();
        onFilesSelected(filePaths);
      } else {
        showCommonSnackBar(message: 'No files selected', isError: true);
      }
    } catch (e) {
      debugPrint('AppConstants.pickFiles error: $e');
      showCommonSnackBar(message: 'Failed to pick files', isError: true);
    }
  }

  static Future<void> pickImages({
    required Function(List<String>) onImagesSelected,
    bool allowMultiple = true,
  }) async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        imageQuality: 100,
      );
      
      if (images.isNotEmpty) {
        final List<String> imagePaths = images.map((image) => image.path).toList();
        onImagesSelected(imagePaths);
      } else {
        showCommonSnackBar(message: 'No images selected', isError: true);
      }
    } catch (e) {
      debugPrint('AppConstants.pickImages error: $e');
      showCommonSnackBar(message: 'Failed to pick images', isError: true);
    }
  }

  static Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      showCommonSnackBar(message: AppTexts.copiedToClipboard);
    } catch (e) {
      debugPrint('AppConstants.copyToClipboard error: $e');
      showCommonSnackBar(message: AppTexts.failedToCopy, isError: true);
    }
  }

}
