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

class PassportScannerController extends GetxController {
  late CameraController cameraController;
  final isCameraInitialized = false.obs;
  final isFlashOn = false.obs;
  final isAutoCapture = true.obs; // Always enabled for passport
  final detectedText = ''.obs;
  final isProcessing = false.obs;
  final capturedImage = Rx<File?>(null); // For preview before saving
  final isCardDetected = false.obs; // Track if passport is in frame

  final textRecognizer = TextRecognizer();
  late FaceDetector faceDetector;
  final ImagePicker _picker = ImagePicker();
  late ScanController scanController;

  @override
  void onInit() {
    super.onInit();
    // Initialize scan controller
    if (Get.isRegistered<ScanController>()) {
      scanController = Get.find<ScanController>();
    } else {
      scanController = Get.put(ScanController());
    }
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
        debugPrint('No cameras available');
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

      // Auto capture is always enabled for passport
      _startAutoCapture();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
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
      debugPrint('Error toggling flash: $e');
    }
  }

  void _startAutoCapture() async {
    if (!isCameraInitialized.value || !isAutoCapture.value) return;

    while (isAutoCapture.value && isCameraInitialized.value && capturedImage.value == null) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!isProcessing.value && isAutoCapture.value && capturedImage.value == null) {
        await _detectPassport();
      }
    }
  }

  Future<void> _detectPassport() async {
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

      // Check if this is likely a passport
      final isPassport = _isLikelyPassport(recognizedText, faces);

      if (isPassport) {
        // Passport detected - stop auto capture and show preview
        isCardDetected.value = true;
        detectedText.value = recognizedText.text;
        capturedImage.value = File(image.path);
        isAutoCapture.value = false; // Stop further captures
      } else {
        // Not a passport, delete temp image
        await File(image.path).delete();
        isCardDetected.value = false;
      }
    } catch (e) {
      debugPrint('Error detecting passport: $e');
      isCardDetected.value = false;
    } finally {
      isProcessing.value = false;
    }
  }

  bool _isLikelyPassport(RecognizedText recognizedText, List<Face> faces) {
    // Check for passport keywords in the text
    final text = recognizedText.text.toLowerCase();
    final passportKeywords = [
      'passport', 'república', 'republic', 'united states', 'kingdom', 'federal',
      'nationality', 'place of birth', 'date of birth', 'dob', 'sex', 'passport no',
      'passport number', 'issued', 'expiry', 'valid until', 'authority', 'surname',
      'given names', 'citizenship', 'type', 'code', 'mrz', 'machine readable'
    ];
    
    final hasPassportKeyword = passportKeywords.any((keyword) => text.contains(keyword));
    
    // Check for face presence (passports typically have a photo)
    final hasFace = faces.isNotEmpty;
    
    // Check text structure - passports have structured text
    final textBlocks = recognizedText.blocks;
    final hasStructuredText = textBlocks.length >= 3 && 
                               text.length > 30 && 
                               text.length < 800;
    
    // Check for numeric patterns (dates, passport numbers)
    final hasNumbers = RegExp(r'\d{4,}').hasMatch(text);
    
    // Check for MRZ pattern (machine readable zone - typically at bottom of passport)
    final hasMRZPattern = RegExp(r'[A-Z0-9<]{30,}').hasMatch(text);
    
    // Score the likelihood
    int score = 0;
    if (hasPassportKeyword) score += 3;
    if (hasFace) score += 2;
    if (hasStructuredText) score += 1;
    if (hasNumbers) score += 1;
    if (hasMRZPattern) score += 2;
    
    // Need at least 4 points to be considered a passport
    return score >= 4;
  }

  Future<void> capturePassport() async {
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

      // Validate that this is a passport
      if (!_isLikelyPassport(recognizedText, faces)) {
        await File(image.path).delete();
        return;
      }

      // Show preview
      detectedText.value = recognizedText.text;
      capturedImage.value = File(image.path);
      isAutoCapture.value = false; // Stop auto capture
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> confirmAndSavePassport() async {

    if (capturedImage.value == null) return;

    try {
      isProcessing.value = true;

      await Gal.putImage(capturedImage.value!.path);

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'passport_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${appDir.path}/$fileName';
      await capturedImage.value!.copy(savedPath);
      
      Get.back();
      await scanController.addFile(File(savedPath));

    } catch (e) {
      AppConstants.showCommonSnackBar(message: 'Failed to save passport: $e', isError: true);
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

  Future<void> _processAndSavePassport(File imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      
      // Run both text recognition and face detection
      final results = await Future.wait([
        textRecognizer.processImage(inputImage),
        faceDetector.processImage(inputImage),
      ]);
      
      final recognizedText = results[0] as RecognizedText;
      final faces = results[1] as List<Face>;

      // Validate that this is a passport
      if (!_isLikelyPassport(recognizedText, faces)) {
        await imageFile.delete();
        return;
      }

      detectedText.value = recognizedText.text;
      capturedImage.value = imageFile;
      isAutoCapture.value = false;
    } catch (e) {
      debugPrint('Error processing passport: $e');
      await imageFile.delete();
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        await _processAndSavePassport(File(image.path));
      }
    } catch (e) {
      debugPrint('Error picking from gallery: $e');
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
