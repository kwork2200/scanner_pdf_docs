import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/widgets/sheets/scan_bottom_sheet.dart';
import 'package:scanner_pdf_docs/widgets/sheets/share_options_sheet.dart';
import 'package:scanner_pdf_docs/widgets/sheets/email_options_sheet.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class DocumentEditorScreen extends GetView<ScanController> {
  const DocumentEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    bool isFromBatch = false;
    
    if (args != null && args is Map<String, dynamic>) {
      isFromBatch = args['fromBatch'] ?? false;
      if (args.containsKey('selectedImage')) {
        final selectedImage = args['selectedImage'] as File;
        if (controller.currentImage.value != selectedImage) {
          controller.currentImage.value = selectedImage;
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.infoBlue),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _showShareOptions(context);
            },
            child: CommonText(
              text: AppTexts.share,
              color: AppColors.infoBlue,
              fontSize: AppFontSizes.font16,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (isFromBatch && controller.capturedImages.length > 1) {
                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: PageView.builder(
                        itemCount: controller.capturedImages.length,
                        itemBuilder: (context, index) {
                          final image = controller.capturedImages[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          _showScanBottomSheet(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 48,
                                  color: Colors.blue,
                                ),
                              ),
                              Spacing.height(16),
                              CommonText(
                                text: 'Tap to add new',
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              CommonText(
                                text: 'pages',
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              
              return Row(
                children: [
                  if (controller.capturedImages.isNotEmpty)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              controller.currentImage.value ?? controller.capturedImages.first,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        _showScanBottomSheet(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 48,
                                color: Colors.blue,
                              ),
                            ),
                            Spacing.height(16),
                            CommonText(
                              text: 'Tap to add new',
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            CommonText(
                              text: 'pages',
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                _buildActionButton(
                  icon: Icons.note_add_outlined,
                  label: 'Add',
                  color: Colors.blue,
                  onTap: () {
                    _showScanBottomSheet(context);
                  },
                ),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  color: Colors.blue,
                  onTap: () {
                    _showShareOptions(context);
                  },
                ),
                _buildActionButton(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  color: Colors.blue,
                  onTap: () {
                    _showEmailOptions(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: color),
          Spacing.height(4),
          CommonText(
            text: label,
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  void _showScanBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ScanBottomSheet(),
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ShareOptionsSheet(),
    );
  }

  void _showEmailOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const EmailOptionsSheet(),
    );
  }
}
