import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';

class CountObjectsController extends GetxController {
  late CameraController cameraController;
  final isCameraInitialized = false.obs;
  final isFlashOn = false.obs;
  final isProcessing = false.obs;
  final detectedObjects = <DetectedObject>[].obs;
  final objectCount = 0.obs;
  final capturedImage = Rx<File?>(null);

  // NEW: actual decoded dimensions of the captured/picked image.
  // Needed so the overlay painter can correctly map ML Kit's
  // image-space bounding boxes onto the screen-space canvas.
  final imageSize = Rx<Size?>(null);

  final ImagePicker _picker = ImagePicker();
  ObjectDetector? _objectDetector;
  final ScanController scanController = Get.put(ScanController());

  @override
  void onInit() {
    super.onInit();
    _initializeObjectDetector();
    _initializeCamera();
  }

  Future<void> _initializeObjectDetector() async {
    try {
      final options = ObjectDetectorOptions(
        mode: DetectionMode.single,
        classifyObjects: true,
        multipleObjects: true,
      );
      _objectDetector = ObjectDetector(options: options);
    } catch (e) {
      debugPrint('Error initializing object detector: $e');
    }
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

  Future<void> captureAndCountObjects() async {
    if (!isCameraInitialized.value || isProcessing.value) return;

    try {
      isProcessing.value = true;

      if (isFlashOn.value) {
        await cameraController.setFlashMode(FlashMode.off);
      }

      final image = await cameraController.takePicture();
      await _processImage(File(image.path));
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: '${AppTexts.somethingWentWrong}: $e',
        isError: true,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _processImage(File imageFile) async {
    try {
      if (_objectDetector == null) {
        AppConstants.showCommonSnackBar(
          message: 'Object detector not initialized',
          isError: true,
        );
        await imageFile.delete();
        return;
      }

      final inputImage = InputImage.fromFilePath(imageFile.path);
      final objects = await _objectDetector!.processImage(inputImage);

      if (objects.isEmpty) {
        AppConstants.showCommonSnackBar(
          message: 'No objects detected. Try again.',
          isError: true,
        );
        await imageFile.delete();
        return;
      }

      // NEW: decode the actual image to get its real pixel dimensions.
      // ML Kit's boundingBox values are in this same coordinate space,
      // so the overlay painter needs it to scale boxes correctly.
      final bytes = await imageFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      imageSize.value = Size(
        frame.image.width.toDouble(),
        frame.image.height.toDouble(),
      );

      // Show results
      detectedObjects.value = objects;
      objectCount.value = objects.length;
      capturedImage.value = imageFile;

      AppConstants.showCommonSnackBar(
        message: 'Detected ${objects.length} object(s)',
      );
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: 'Failed to detect objects: $e',
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
        isProcessing.value = true;
        await _processImage(File(image.path));
        isProcessing.value = false;
      }
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: '${AppTexts.somethingWentWrong}: $e',
        isError: true,
      );
      isProcessing.value = false;
    }
  }

  void retake() {
    if (capturedImage.value != null) {
      try {
        capturedImage.value!.delete();
      } catch (e) {
        debugPrint('Error deleting temp file: $e');
      }
    }
    capturedImage.value = null;
    detectedObjects.clear();
    objectCount.value = 0;
    imageSize.value = null;
  }

  void saveResult() async {
    if (capturedImage.value == null) return;

    try {
      isProcessing.value = true;

      await Gal.putImage(capturedImage.value!.path);

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'counted_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${appDir.path}/$fileName';
      await capturedImage.value!.copy(savedPath);
      
      Get.back();
      await scanController.addFile(File(savedPath));

      AppConstants.showCommonSnackBar(
        message: 'Image saved to gallery and recent files',
      );

    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: 'Failed to save: $e',
        isError: true,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  @override
  void onClose() {
    if (isCameraInitialized.value) {
      cameraController.dispose();
    }
    _objectDetector?.close();
    super.onClose();
  }
}