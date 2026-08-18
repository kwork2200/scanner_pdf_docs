import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';
import 'document_editor_screen.dart';

class ImageEditorScreen extends StatefulWidget {
  final File? imageFile;
  
  const ImageEditorScreen({
    super.key,
    this.imageFile,
  });

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  final ScanController controller = Get.find<ScanController>();
  
  String selectedFilter = 'Original';
  String selectedTab = 'All';
  File? processedImage;
  img.Image? decodedImage;
  double rotationAngle = 0.0; // For rotation
  
  final List<Map<String, dynamic>> filters = [
    {'name': 'No Shadow', 'icon': Icons.wb_sunny_outlined},
    {'name': 'Auto', 'icon': Icons.auto_fix_high},
    {'name': 'Original', 'icon': Icons.image_outlined},
    {'name': 'Gray', 'icon': Icons.filter_b_and_w},
    {'name': 'Lighten', 'icon': Icons.brightness_5},
  ];

  Offset topLeft = const Offset(0.1, 0.15);
  Offset topRight = const Offset(0.9, 0.15);
  Offset bottomLeft = const Offset(0.1, 0.85);
  Offset bottomRight = const Offset(0.9, 0.85);

  @override
  void initState() {
    super.initState();
    // Get image file from arguments if not provided directly
    if (widget.imageFile == null) {
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null && args['imageFile'] != null) {
        processedImage = args['imageFile'] as File;
        setState(() {});
      }
    }
    _loadImage();
  }

  Future<void> _loadImage() async {
    final imageFile = widget.imageFile ?? processedImage;
    if (imageFile == null) return;
    
    final bytes = await imageFile.readAsBytes();
    decodedImage = img.decodeImage(bytes);
    processedImage = imageFile;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: AppColors.grey300,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () {
            Get.back();
          },
        ),
        title: CommonText(
          text: 'M08 06, Doc (${controller.capturedImages.length + 1})',
          fontSize: AppFontSizes.font16,
          color: AppColors.blackColor,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveAndContinue,
            child: CommonText(
              text: AppTexts.done,
              color: AppColors.infoBlue,
              fontSize: AppFontSizes.font16,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Image Preview with Crop Corners
          Expanded(
            child: Container(
              color: AppColors.grey300,
              child: processedImage == null
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        // Background Image with rotation
                        Center(
                          child: Transform.rotate(
                            angle: rotationAngle,
                            child: Image.file(
                              processedImage!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        
                        // Crop Overlay
                        CustomPaint(
                          size: screenSize,
                          painter: CropOverlayPainter(
                            topLeft: Offset(
                              screenSize.width * topLeft.dx,
                              screenSize.height * topLeft.dy,
                            ),
                            topRight: Offset(
                              screenSize.width * topRight.dx,
                              screenSize.height * topRight.dy,
                            ),
                            bottomLeft: Offset(
                              screenSize.width * bottomLeft.dx,
                              screenSize.height * bottomLeft.dy,
                            ),
                            bottomRight: Offset(
                              screenSize.width * bottomRight.dx,
                              screenSize.height * bottomRight.dy,
                            ),
                          ),
                        ),
                        
                        // Draggable Corner Points
                        _buildCornerPoint(
                          Offset(
                            screenSize.width * topLeft.dx,
                            screenSize.height * topLeft.dy,
                          ),
                          (details) {
                            setState(() {
                              topLeft = Offset(
                                details.localPosition.dx / screenSize.width,
                                details.localPosition.dy / screenSize.height,
                              );
                            });
                          },
                        ),
                        _buildCornerPoint(
                          Offset(
                            screenSize.width * topRight.dx,
                            screenSize.height * topRight.dy,
                          ),
                          (details) {
                            setState(() {
                              topRight = Offset(
                                details.localPosition.dx / screenSize.width,
                                details.localPosition.dy / screenSize.height,
                              );
                            });
                          },
                        ),
                        _buildCornerPoint(
                          Offset(
                            screenSize.width * bottomLeft.dx,
                            screenSize.height * bottomLeft.dy,
                          ),
                          (details) {
                            setState(() {
                              bottomLeft = Offset(
                                details.localPosition.dx / screenSize.width,
                                details.localPosition.dy / screenSize.height,
                              );
                            });
                          },
                        ),
                        _buildCornerPoint(
                          Offset(
                            screenSize.width * bottomRight.dx,
                            screenSize.height * bottomRight.dy,
                          ),
                          (details) {
                            setState(() {
                              bottomRight = Offset(
                                details.localPosition.dx / screenSize.width,
                                details.localPosition.dy / screenSize.height,
                              );
                            });
                          },
                        ),
                        
                        // Page counter
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CommonText(
                              text: '1/1',
                              color: AppColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          // Container(
          //   height: 100,
          //   color: Colors.white,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //     itemCount: filters.length,
          //     itemBuilder: (context, index) {
          //       final filter = filters[index];
          //       final isSelected = selectedFilter == filter['name'];
          //
          //       return GestureDetector(
          //         onTap: () async {
          //           setState(() {
          //             selectedFilter = filter['name'];
          //           });
          //           await _applyFilter(filter['name']);
          //         },
          //         child: Container(
          //           margin: const EdgeInsets.only(right: 16),
          //           child: Column(
          //             children: [
          //               Container(
          //                 width: 60,
          //                 height: 60,
          //                 decoration: BoxDecoration(
          //                   color: Colors.grey[200],
          //                   borderRadius: BorderRadius.circular(8),
          //                   border: Border.all(
          //                     color: isSelected ? Colors.blue : Colors.grey[300]!,
          //                     width: isSelected ? 3 : 1,
          //                   ),
          //                 ),
          //                 child: Icon(
          //                   filter['icon'],
          //                   color: isSelected ? Colors.blue : Colors.grey[600],
          //                   size: 30,
          //                 ),
          //               ),
          //               const SizedBox(height: 4),
          //               Text(
          //                 filter['name'],
          //                 style: TextStyle(
          //                   fontSize: 11,
          //                   color: isSelected ? Colors.blue : Colors.black,
          //                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          //
          // Bottom Navigation Tabs (All, Left, Right)
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomTab(
                  Icons.select_all,
                  'All',
                  selectedTab == 'All',
                  () {
                    setState(() {
                      selectedTab = 'All';
                      rotationAngle = 0.0;
                    });
                  },
                ),
                _buildBottomTab(
                  Icons.rotate_left,
                  'Left',
                  selectedTab == 'Left',
                  () async {
                    setState(() {
                      selectedTab = 'Left';
                      rotationAngle -= 1.5708;
                    });
                    await _rotateImage(-90);
                  },
                ),
                _buildBottomTab(
                  Icons.rotate_right,
                  'Right',
                  selectedTab == 'Right',
                  () async {
                    setState(() {
                      selectedTab = 'Right';
                      rotationAngle += 1.5708;
                    });
                    await _rotateImage(90);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerPoint(Offset position, Function(DragUpdateDetails) onDrag) {
    return Positioned(
      left: position.dx - 15,
      top: position.dy - 15,
      child: GestureDetector(
        onPanUpdate: onDrag,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.infoBlue,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.whiteColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTab(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          Spacing.height(4),
          CommonText(
            text: label,
            fontSize: 12,
            color: isSelected ? Colors.blue : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ],
      ),
    );
  }

  // Apply Filter Function
  Future<void> _applyFilter(String filterName) async {
    if (decodedImage == null || widget.imageFile == null) return;

    try {
      img.Image filtered = img.Image.from(decodedImage!);

      switch (filterName) {
        case 'No Shadow':
          // Increase brightness and reduce contrast
          filtered = img.adjustColor(filtered, brightness: 1.2, contrast: 0.9);
          break;
        case 'Auto':
          // Auto enhance
          filtered = img.adjustColor(filtered, brightness: 1.1, contrast: 1.1);
          break;
        case 'Original':
          // No changes
          filtered = decodedImage!;
          break;
        case 'Gray':
          // Grayscale
          filtered = img.grayscale(filtered);
          break;
        case 'Lighten':
          // Brighten
          filtered = img.adjustColor(filtered, brightness: 1.3);
          break;
      }

      // Save filtered image
      final tempPath = '${widget.imageFile!.path}_filtered.jpg';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(img.encodeJpg(filtered));

      setState(() {
        processedImage = tempFile;
      });
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: 'Failed to apply filter: $e',
        isError: true,
      );
    }
  }

  // Rotate Image Function
  Future<void> _rotateImage(int degrees) async {
    if (decodedImage == null || widget.imageFile == null) return;

    try {
      img.Image rotated = img.Image.from(decodedImage!);

      if (degrees == 90) {
        rotated = img.copyRotate(rotated, angle: 90);
      } else if (degrees == -90) {
        rotated = img.copyRotate(rotated, angle: -90);
      }

      // Save rotated image
      final tempPath = '${widget.imageFile!.path}_rotated.jpg';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(img.encodeJpg(rotated));

      // Update decoded image for further operations
      decodedImage = rotated;

      setState(() {
        processedImage = tempFile;
      });

      AppConstants.showCommonSnackBar(
        message: 'Image rotated successfully',
      );
    } catch (e) {
      AppConstants.showCommonSnackBar(
        message: 'Failed to rotate image: $e',
        isError: true,
      );
    }
  }

  void _saveAndContinue() async {
    try {
      // Show loading
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: AppColors.whiteColor),
        ),
        barrierDismissible: false,
      );

      // Use processed image if available, otherwise original
      final finalImage = processedImage ?? widget.imageFile;
      
      if (finalImage == null) {
        Get.back();
        AppConstants.showCommonSnackBar(
          message: 'No image to save',
          isError: true,
        );
        return;
      }

      // 1. Save to capturedImages list (for recent section)
      controller.confirmAndSaveImage(finalImage);
      
      // 2. Save to device gallery
      controller.currentImage.value = finalImage;
      await controller.saveToGallery();
      
      // Close loading dialog
      Get.back();
      
      // Navigate to document editor
      Get.offNamed(AppRoutes.documentEditor);
      
      AppConstants.showCommonSnackBar(
        message: 'Document saved successfully',
      );
    } catch (e) {
      // Close loading dialog
      Get.back();
      
      AppConstants.showCommonSnackBar(
        message: 'Failed to save document: $e',
        isError: true,
      );
    }
  }
}

class CropOverlayPainter extends CustomPainter {
  final Offset topLeft;
  final Offset topRight;
  final Offset bottomLeft;
  final Offset bottomRight;

  CropOverlayPainter({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });


  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw crop lines
    final path = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..close();

    canvas.drawPath(path, paint);

    // Draw corner handles
    final cornerLength = 20.0;
    final cornerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw L-shaped corners at each point
    // Top-left
    canvas.drawLine(
      Offset(topLeft.dx - cornerLength / 2, topLeft.dy),
      Offset(topLeft.dx + cornerLength / 2, topLeft.dy),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(topLeft.dx, topLeft.dy - cornerLength / 2),
      Offset(topLeft.dx, topLeft.dy + cornerLength / 2),
      cornerPaint,
    );

    // Top-right
    canvas.drawLine(
      Offset(topRight.dx - cornerLength / 2, topRight.dy),
      Offset(topRight.dx + cornerLength / 2, topRight.dy),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(topRight.dx, topRight.dy - cornerLength / 2),
      Offset(topRight.dx, topRight.dy + cornerLength / 2),
      cornerPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(bottomLeft.dx - cornerLength / 2, bottomLeft.dy),
      Offset(bottomLeft.dx + cornerLength / 2, bottomLeft.dy),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(bottomLeft.dx, bottomLeft.dy - cornerLength / 2),
      Offset(bottomLeft.dx, bottomLeft.dy + cornerLength / 2),
      cornerPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(bottomRight.dx - cornerLength / 2, bottomRight.dy),
      Offset(bottomRight.dx + cornerLength / 2, bottomRight.dy),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(bottomRight.dx, bottomRight.dy - cornerLength / 2),
      Offset(bottomRight.dx, bottomRight.dy + cornerLength / 2),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
