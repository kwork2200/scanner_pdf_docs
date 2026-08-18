import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:image/image.dart' as img;

class ScanController extends GetxController {
  // Camera
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  RxBool isCameraInitialized = false.obs;
  RxBool isFlashOn = false.obs;
  RxInt selectedCameraIndex = 0.obs;

  // Scanning
  RxBool isScanning = false.obs;
  RxBool isProcessing = false.obs;
  RxString detectedText = ''.obs;
  RxList<TextLine> detectedLines = <TextLine>[].obs;

  // Captured Images
  RxList<File> capturedImages = <File>[].obs;
  Rx<File?> currentImage = Rx<File?>(null);
  
  // Document names and favourites
  RxMap<String, String> documentNames = <String, String>{}.obs; // filepath -> custom name
  RxList<String> favouriteDocuments = <String>[].obs; // List of favourite file paths

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
      debugPrint('Error disposing camera: $e');
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
      debugPrint('Failed to initialize camera controller: $e');
      Get.snackbar('Error', 'Failed to initialize camera controller: $e');
      isCameraInitialized.value = false;
    }
  }

  Future<void> switchCamera() async {
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

  Future<void> toggleFlash() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        final newFlashMode = isFlashOn.value ? FlashMode.off : FlashMode.torch;
        await cameraController!.setFlashMode(newFlashMode);
        isFlashOn.value = !isFlashOn.value;
      } catch (e) {
        debugPrint('Failed to toggle flash: $e');
        Get.snackbar('Error', 'Failed to toggle flash: $e');
      }
    }
  }

  Future<void> captureImage() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      debugPrint('Camera not initialized');
      return;
    }

    try {
      isProcessing.value = true;
      
      final image = await cameraController!.takePicture();
      
      final tempDir = await getTemporaryDirectory();
      final fileName = 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = path.join(tempDir.path, fileName);
      
      final savedFile = await File(image.path).copy(savedPath);
      currentImage.value = savedFile;

      Get.snackbar('Success', 'Image captured successfully');
    } catch (e) {
      debugPrint('Failed to capture image: $e');
      Get.snackbar('Error', 'Failed to capture image: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  void confirmAndSaveImage(File imageFile) {
    if (!capturedImages.contains(imageFile)) {
      capturedImages.add(imageFile);
      currentImage.value = imageFile;
    }
  }

  Future<void> detectDocument() async {
    if (currentImage.value == null) {
      Get.snackbar('Error', 'No image to process');
      return;
    }

    try {
      isScanning.value = true;
      
      final inputImage = InputImage.fromFilePath(currentImage.value!.path);
      final textRecognizer = TextRecognizer();
      
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      detectedLines.clear();
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          detectedLines.add(line);
        }
      }
      
      detectedText.value = recognizedText.text;
      
      await textRecognizer.close();
      
      Get.snackbar('Success', 'Document detected successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to detect document: $e');
    } finally {
      isScanning.value = false;
    }
  }

  Future<void> saveToGallery() async {
    if (currentImage.value == null) {
      Get.snackbar('Error', 'No image to save');
      return;
    }

    try {
      if (Platform.isAndroid) {
        final androidVersion = await _getAndroidVersion();
        if (androidVersion < 33) {
          final storagePermission = await Permission.storage.request();
          if (!storagePermission.isGranted) {
            Get.snackbar('Permission', 'Storage permission is required');
            return;
          }
        }
      }

      await Gal.putImage(currentImage.value!.path);
      Get.snackbar('Success', 'Image saved to gallery');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save to gallery: $e');
    }
  }

  Future<int> _getAndroidVersion() async {
    try {
      return 33;
    } catch (e) {
      return 30;
    }
  }

  void deleteImage(int index) {
    if (index >= 0 && index < capturedImages.length) {
      final imageFile = capturedImages[index];
      imageFile.deleteSync();
      capturedImages.removeAt(index);
      
      if (currentImage.value == imageFile) {
        currentImage.value = capturedImages.isNotEmpty 
            ? capturedImages.last 
            : null;
      }
    }
  }

  void clearAllImages() {
    for (final imageFile in capturedImages) {
      imageFile.deleteSync();
    }
    capturedImages.clear();
    currentImage.value = null;
    detectedText.value = '';
    detectedLines.clear();
  }

  Future<void> processPickedImage(String imagePath) async {
    try {
      isProcessing.value = true;
      
      final tempDir = await getTemporaryDirectory();
      final fileName = 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = path.join(tempDir.path, fileName);
      
      final savedFile = await File(imagePath).copy(savedPath);
      currentImage.value = savedFile;

      Get.snackbar('Success', 'Image loaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to load image: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> addFile(File file) async {
    try {
      isProcessing.value = true;
      
      final tempDir = await getTemporaryDirectory();
      final fileExtension = path.extension(file.path);
      final fileName = 'import_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final savedPath = path.join(tempDir.path, fileName);
      
      final savedFile = await file.copy(savedPath);
      
      if (!capturedImages.contains(savedFile)) {
        capturedImages.add(savedFile);
      }
      
      // Get.snackbar('Success', 'File added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add file: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> shareAsPDF() async {
    if (currentImage.value == null) {
      Get.snackbar('Error', 'No image to share');
      return;
    }

    try {
      Get.snackbar('Processing', 'Creating PDF...');
      
      final pdf = pw.Document();
      
      final imageBytes = await currentImage.value!.readAsBytes();
      final image = pw.MemoryImage(imageBytes);
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
      
      final tempDir = await getTemporaryDirectory();
      final pdfPath = path.join(tempDir.path, 'scan_${DateTime.now().millisecondsSinceEpoch}.pdf');
      final pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(await pdf.save());
      
      await Share.shareXFiles(
        [XFile(pdfPath)],
        subject: 'Scanned Document',
        text: 'Sharing scanned document as PDF',
      );
      
      Get.snackbar('Success', 'PDF shared successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to share PDF: $e');
    }
  }

  Future<void> shareAsLongImage() async {
    if (capturedImages.isEmpty) {
      Get.snackbar('Error', 'No images to share');
      return;
    }

    try {
      Get.snackbar('Processing', 'Creating long image...');
      
      List<img.Image> images = [];
      int totalHeight = 0;
      int maxWidth = 0;
      
      for (final imageFile in capturedImages) {
        final bytes = await imageFile.readAsBytes();
        final decodedImage = img.decodeImage(bytes);
        if (decodedImage != null) {
          images.add(decodedImage);
          totalHeight += decodedImage.height;
          if (decodedImage.width > maxWidth) {
            maxWidth = decodedImage.width;
          }
        }
      }
      
      if (images.isEmpty) {
        Get.snackbar('Error', 'Failed to process images');
        return;
      }
      
      final combinedImage = img.Image(width: maxWidth, height: totalHeight);
      
      int currentY = 0;
      for (final image in images) {
        img.compositeImage(combinedImage, image, dstY: currentY);
        currentY += image.height;
      }
      
      final tempDir = await getTemporaryDirectory();
      final longImagePath = path.join(tempDir.path, 'long_scan_${DateTime.now().millisecondsSinceEpoch}.jpg');
      final longImageFile = File(longImagePath);
      await longImageFile.writeAsBytes(img.encodeJpg(combinedImage));
      
      await Share.shareXFiles(
        [XFile(longImagePath)],
        subject: 'Scanned Document',
        text: 'Sharing scanned document as long image',
      );
      
      Get.snackbar('Success', 'Long image shared successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to share long image: $e');
    }
  }

  // Share as JPG
  Future<void> shareAsJPG() async {
    if (currentImage.value == null) {
      Get.snackbar('Error', 'No image to share');
      return;
    }

    try {
      await Share.shareXFiles(
        [XFile(currentImage.value!.path)],
        subject: 'Scanned Document',
        text: 'Sharing scanned document as JPG',
      );
      
      Get.snackbar('Success', 'Image shared successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to share image: $e');
    }
  }

  // Email as PDF
  Future<void> emailAsPDF() async {
    if (currentImage.value == null) {
      Get.snackbar('Error', 'No image to email');
      return;
    }

    try {
      Get.snackbar('Processing', 'Creating PDF for email...');
      
      // Create PDF
      final pdf = pw.Document();
      final imageBytes = await currentImage.value!.readAsBytes();
      final image = pw.MemoryImage(imageBytes);
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
      
      // Save PDF
      final tempDir = await getTemporaryDirectory();
      final pdfPath = path.join(tempDir.path, 'scan_${DateTime.now().millisecondsSinceEpoch}.pdf');
      final pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(await pdf.save());
      
      // Share via email
      await Share.shareXFiles(
        [XFile(pdfPath)],
        subject: 'Scanned Document - PDF',
        text: 'Please find the attached scanned document.',
      );
      
      Get.snackbar('Success', 'Email ready to send');
    } catch (e) {
      Get.snackbar('Error', 'Failed to prepare email: $e');
    }
  }

  // Email as Long Image
  Future<void> emailAsLongImage() async {
    if (capturedImages.isEmpty) {
      Get.snackbar('Error', 'No images to email');
      return;
    }

    try {
      Get.snackbar('Processing', 'Creating long image for email...');
      
      List<img.Image> images = [];
      int totalHeight = 0;
      int maxWidth = 0;
      
      for (final imageFile in capturedImages) {
        final bytes = await imageFile.readAsBytes();
        final decodedImage = img.decodeImage(bytes);
        if (decodedImage != null) {
          images.add(decodedImage);
          totalHeight += decodedImage.height;
          if (decodedImage.width > maxWidth) {
            maxWidth = decodedImage.width;
          }
        }
      }
      
      if (images.isEmpty) {
        Get.snackbar('Error', 'Failed to process images');
        return;
      }
      
      final combinedImage = img.Image(width: maxWidth, height: totalHeight);
      
      int currentY = 0;
      for (final image in images) {
        img.compositeImage(combinedImage, image, dstY: currentY);
        currentY += image.height;
      }
      
      final tempDir = await getTemporaryDirectory();
      final longImagePath = path.join(tempDir.path, 'long_scan_${DateTime.now().millisecondsSinceEpoch}.jpg');
      final longImageFile = File(longImagePath);
      await longImageFile.writeAsBytes(img.encodeJpg(combinedImage));
      
      await Share.shareXFiles(
        [XFile(longImagePath)],
        subject: 'Scanned Document - Long Image',
        text: 'Please find the attached scanned document.',
      );
      
      Get.snackbar('Success', 'Email ready to send');
    } catch (e) {
      Get.snackbar('Error', 'Failed to prepare email: $e');
    }
  }

  // Email as JPG
  Future<void> emailAsJPG() async {
    if (currentImage.value == null) {
      Get.snackbar('Error', 'No image to email');
      return;
    }

    try {
      await Share.shareXFiles(
        [XFile(currentImage.value!.path)],
        subject: 'Scanned Document - JPG',
        text: 'Please find the attached scanned document.',
      );
      
      Get.snackbar('Success', 'Email ready to send');
    } catch (e) {
      Get.snackbar('Error', 'Failed to prepare email: $e');
    }
  }
}