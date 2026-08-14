import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';

class IdCardScannerController extends GetxController {
  late CameraController cameraController;
  final isCameraInitialized = false.obs;
  final isFlashOn = false.obs;
  final isAutoCapture = true.obs; // Always enabled for ID cards
  final detectedText = ''.obs;
  final isProcessing = false.obs;
  final capturedImage = Rx<File?>(null); // For preview before saving
  final isCardDetected = false.obs; // Track if card is in frame

  final textRecognizer = TextRecognizer();
  late FaceDetector faceDetector;
  final ImagePicker _picker = ImagePicker();
  final ScanController scanController = Get.put(ScanController());

  @override
  void onInit() {
    super.onInit();
    _initializeFaceDetector();
    _initializeCamera();
  }

  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: false,
      minFaceSize: 0.15,
    );
    faceDetector = FaceDetector(options: options);
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        AppConstants.showCommonSnackBar(
          message: AppTexts.cameraPermissionDenied,
          isError: true,
        );
        return;
      }

      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await cameraController.initialize();
      isCameraInitialized.value = true;

      // Auto capture is always enabled for ID cards
      _startAutoCapture();
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: '${AppTexts.somethingWentWrong}: $e',
        isError: true,
      );
    }
  }

  void toggleFlash() async {
    if (!isCameraInitialized.value) return;
    
    try {
      if (isFlashOn.value) {
        await cameraController.setFlashMode(FlashMode.off);
        isFlashOn.value = false;
      } else {
        await cameraController.setFlashMode(FlashMode.torch);
        isFlashOn.value = true;
      }
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: '${AppTexts.somethingWentWrong}: $e',
        isError: true,
      );
    }
  }

  void _startAutoCapture() async {
    if (!isCameraInitialized.value || !isAutoCapture.value) return;

    while (isAutoCapture.value && isCameraInitialized.value && capturedImage.value == null) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!isProcessing.value && isAutoCapture.value && capturedImage.value == null) {
        await _detectIdCard();
      }
    }
  }

  Future<void> _detectIdCard() async {
    if (isProcessing.value || !isCameraInitialized.value || capturedImage.value != null) return;

    try {
      isProcessing.value = true;
      final image = await cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      
      // Run both text recognition and face detection in parallel
      final results = await Future.wait([
        textRecognizer.processImage(inputImage),
        faceDetector.processImage(inputImage),
      ]);
      
      final recognizedText = results[0] as RecognizedText;
      final faces = results[1] as List<Face>;

      // Check if this is likely an ID card
      final isIdCard = _isLikelyIdCard(recognizedText, faces);

      if (isIdCard) {
        // Card detected - stop auto capture and show preview
        isCardDetected.value = true;
        detectedText.value = recognizedText.text;
        capturedImage.value = File(image.path);
        isAutoCapture.value = false; // Stop further captures
      } else {
        // Not an ID card, delete temp image
        await File(image.path).delete();
        isCardDetected.value = false;
      }
    } catch (e) {
      debugPrint('Error detecting ID card: $e');
      isCardDetected.value = false;
    } finally {
      isProcessing.value = false;
    }
  }

  bool _isLikelyIdCard(RecognizedText recognizedText, List<Face> faces) {
    // Check for ID card keywords in the text
    final text = recognizedText.text.toLowerCase();
    final idKeywords = [
      'id card', 'identity card', 'identification', 'license', 'driving',
      'passport', 'national id', 'aadhaar', 'pan card', 'voter id',
      'date of birth', 'dob', 'expiry', 'valid', 'sex', 'gender',
      'blood group', 'signature', 'issue date', 'issued'
    ];
    
    final hasIdKeyword = idKeywords.any((keyword) => text.contains(keyword));
    
    // Check for face presence (ID cards typically have a photo)
    final hasFace = faces.isNotEmpty;
    
    // Check text structure - ID cards have structured text
    final textBlocks = recognizedText.blocks;
    final hasStructuredText = textBlocks.length >= 3 && 
                               text.length > 30 && 
                               text.length < 500;
    
    // Check for numeric patterns (dates, ID numbers)
    final hasNumbers = RegExp(r'\d{4,}').hasMatch(text);
    
    // Score the likelihood
    int score = 0;
    if (hasIdKeyword) score += 3;
    if (hasFace) score += 2;
    if (hasStructuredText) score += 1;
    if (hasNumbers) score += 1;
    
    // Need at least 4 points to be considered an ID card
    return score >= 4;
  }

  Future<void> captureIdCard() async {
    if (!isCameraInitialized.value || isProcessing.value || capturedImage.value != null) return;

    try {
      isProcessing.value = true;
      
      if (isFlashOn.value) {
        await cameraController.setFlashMode(FlashMode.off);
      }

      final image = await cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      
      // Run both text recognition and face detection
      final results = await Future.wait([
        textRecognizer.processImage(inputImage),
        faceDetector.processImage(inputImage),
      ]);
      
      final recognizedText = results[0] as RecognizedText;
      final faces = results[1] as List<Face>;

      // Validate that this is an ID card
      if (!_isLikelyIdCard(recognizedText, faces)) {
        AppConstants.showCommonSnackBar(
          message: 'No ID card detected. Please position an ID card in the frame.',
          isError: true,
        );
        await File(image.path).delete();
        return;
      }

      // Show preview
      detectedText.value = recognizedText.text;
      capturedImage.value = File(image.path);
      isAutoCapture.value = false; // Stop auto capture
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: '${AppTexts.somethingWentWrong}: $e',
        isError: true,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> confirmAndSaveIdCard() async {

    if (capturedImage.value == null) return;

    try {
      isProcessing.value = true;

      await Gal.putImage(capturedImage.value!.path);

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'id_card_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${appDir.path}/$fileName';
      await capturedImage.value!.copy(savedPath);
      
      Get.back();
      await scanController.addFile(File(savedPath));

      AppConstants.showCommonSnackBar(message: 'ID card saved to gallery and recent files');

    } catch (e) {
      AppConstants.showCommonSnackBar(message: 'Failed to save ID card: $e', isError: true);
    } finally {
      isProcessing.value = false;
    }
  }

  void retakePhoto() async {
    if (capturedImage.value != null) {
      try {
        await capturedImage.value!.delete();
      } catch (e) {
        debugPrint('Error deleting temp file: $e');
      }
    }
    capturedImage.value = null;
    detectedText.value = '';
    isCardDetected.value = false;
    isAutoCapture.value = true;
    _startAutoCapture();
  }

  Future<void> _processAndSaveIdCard(File imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      
      // Run both text recognition and face detection
      final results = await Future.wait([
        textRecognizer.processImage(inputImage),
        faceDetector.processImage(inputImage),
      ]);
      
      final recognizedText = results[0] as RecognizedText;
      final faces = results[1] as List<Face>;

      // Validate that this is an ID card
      if (!_isLikelyIdCard(recognizedText, faces)) {
        AppConstants.showCommonSnackBar(
          message: 'No ID card detected in the selected image.',
          isError: true,
        );
        await imageFile.delete();
        return;
      }

      detectedText.value = recognizedText.text;
      capturedImage.value = imageFile;
      isAutoCapture.value = false;
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: 'Failed to process ID card: $e',
        isError: true,
      );
      await imageFile.delete();
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        await _processAndSaveIdCard(File(image.path));
      }
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: '${AppTexts.somethingWentWrong}: $e',
        isError: true,
      );
    }
  }

  @override
  void onClose() {
    if (isCameraInitialized.value) {
      cameraController.dispose();
    }
    textRecognizer.close();
    faceDetector.close();
    super.onClose();
  }
}
