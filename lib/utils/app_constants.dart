import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';

class AppConstants {
  static final ImagePicker _imagePicker = ImagePicker();
  // App URLs
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.xstudios.fastscan';
  static const String contactUsUrl = 'https://fastscanapp.com/en/contact';
  static const String privacyPolicyUrl = 'https://fastscanapp.com/en/privacy';
  static const String termsConditionsUrl = 'https://fastscanapp.com/en/terms';
  static const String faqUrl = 'https://fastscanapp.com/en#faq';
  static const String shareMessage = 'Try PDF Scanner App! It helps scan and share any documents you need. http://play.google.com/store/apps/details?id=com.xstudios.fastscan';

  static showCommonSnackBar({required String message, bool isError = false, bool isSuccess = false, BuildContext? context}) {
    Get.snackbar(
      "",
      message,
      titleText: const SizedBox(),
      messageText: Text(
        message,
        style: TextStyle(
          color: AppColors.whiteColor,
          fontWeight: FontWeight.bold,
          fontSize:AppFontSizes.font14,
        ),
      ),
      backgroundColor: isError ? AppColors.redAccentColor : (isSuccess ? AppColors.successGreen : AppColors.primaryColor),
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


  static Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      return '2.3.6';
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

  static Future<void> shareApp() async {
    try {
      await Share.share(shareMessage);
    } catch (e) {
      debugPrint('AppConstants.shareApp error: $e');
      showCommonSnackBar(message: 'Failed to share app', isError: true);
    }
  }

  static Future<void> openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
        showCommonSnackBar(message: 'Could not open link', isError: true);
      }
    } catch (e) {
      debugPrint('AppConstants.openUrl error: $e');
      showCommonSnackBar(message: 'Failed to open link', isError: true);
    }
  }

  static Future<void> rateApp() async {
    await openUrl(playStoreUrl);
  }

  static Future<void> openContactUs() async {
    await openUrl(contactUsUrl);
  }

  static Future<void> openPrivacyPolicy() async {
    await openUrl(privacyPolicyUrl);
  }

  static Future<void> openTermsConditions() async {
    await openUrl(termsConditionsUrl);
  }

  static Future<void> openFaq() async {
    await openUrl(faqUrl);
  }

  static Future<void> showPremiumScreen() async {
    Get.toNamed('/premium');
  }

}
