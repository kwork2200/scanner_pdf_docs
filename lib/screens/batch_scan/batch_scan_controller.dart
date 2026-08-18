import 'dart:io';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';

class BatchScanController extends GetxController {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  RxBool isCameraInitialized = false.obs;
  RxBool isFlashOn = false.obs;
  RxInt selectedCameraIndex = 0.obs;
  RxBool isProcessing = false.obs;
  RxList<File> capturedImages = <File>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  @override
  void onClose() {
    disposeCamera();
    super.onClose();
  }

  Future<void> disposeCamera() async {
    try {
      if (cameraController != null && cameraController!.value.isInitialized) {
        await cameraController!.dispose();
        cameraController = null;
        isCameraInitialized.value = false;
      }
    } catch (e) {
      print('Error disposing camera: $e');
    }
  }

  Future<void> initializeCamera() async {
    try {
      final cameraPermission = await Permission.camera.request();
      if (!cameraPermission.isGranted) {
        Get.snackbar('Permission', 'Camera permission is required');
        return;
      }

      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        await initializeCameraController(cameras![selectedCameraIndex.value]);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera: $e');
    }
  }

  Future<void> initializeCameraController(CameraDescription description) async {
    try {
      await disposeCamera();
      
      cameraController = CameraController(
        description,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera controller: $e');
      isCameraInitialized.value = false;
    }
  }

  void switchCamera() async {
    if (cameras != null && cameras!.length > 1) {
      try {
        await disposeCamera();
        selectedCameraIndex.value = (selectedCameraIndex.value + 1) % cameras!.length;
        await initializeCameraController(cameras![selectedCameraIndex.value]);
      } catch (e) {
        Get.snackbar('Error', 'Failed to switch camera: $e');
      }
    }
  }

  void toggleFlash() async {
    if (cameraController != null) {
      try {
        await cameraController!.setFlashMode(
          isFlashOn.value ? FlashMode.off : FlashMode.torch,
        );
        isFlashOn.value = !isFlashOn.value;
      } catch (e) {
        Get.snackbar('Error', 'Failed to toggle flash: $e');
      }
    }
  }

  Future<void> captureImage() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    try {
      isProcessing.value = true;
      final image = await cameraController!.takePicture();
      
      final tempDir = await getTemporaryDirectory();
      final fileName = 'batch_scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = path.join(tempDir.path, fileName);
      
      final savedFile = await File(image.path).copy(savedPath);
      capturedImages.add(savedFile);
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  void deleteLastImage() {
    if (capturedImages.isNotEmpty) {
      final lastImage = capturedImages.last;
      lastImage.deleteSync();
      capturedImages.removeLast();
    }
  }

  void clearAllImages() {
    for (final imageFile in capturedImages) {
      imageFile.deleteSync();
    }
    capturedImages.clear();
  }
}
