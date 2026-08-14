import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/app_utils.dart';

class QrScannerController extends GetxController {
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  RxnString scannedData = RxnString();
  RxBool isScanned = false.obs;
  RxBool flashOn = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  void onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    
    for (final barcode in barcodes) {
      if (barcode.rawValue != null && !isScanned.value) {
        scannedData.value = barcode.rawValue;
        isScanned.value = true;
        cameraController.stop();
        // Provide haptic feedback
        HapticFeedback.vibrate();
        break;
      }
    }
  }

  Future<void> openLink(String url) async {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || (!uri.scheme.startsWith('http') && !uri.scheme.startsWith('https'))) {
      AppConstants.showCommonSnackBar(message: AppTexts.notValidUrl, isError: true);
      return;
    }

    await AppUtils.openUrl(url);
  }

  Future<void> copyToClipboard(String text) async {
    await AppConstants.copyToClipboard(text);
  }

  void deleteScannedData() {
    scannedData.value = null;
    isScanned.value = false;
    cameraController.start();
  }

  void toggleFlash() {
    flashOn.value = !flashOn.value;
    cameraController.toggleTorch();
  }
}
