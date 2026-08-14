import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/gallery/gallery_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class GalleryScreen extends GetView<GalleryController> {
  GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          text: AppTexts.chooseFromGallery,
          fontSize: AppFontSizes.font18,
          fontWeight: AppFontWeights.bold,
          color: AppColors.whiteColor,
        ),
        backgroundColor: AppColors.deepPurple,
        foregroundColor: AppColors.whiteColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadGalleryImages,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') {
                _showClearDialog();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear',
                child: CommonText(text: 'Clear Gallery'),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.galleryImages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(
                  Icons.photo_library_outlined,
                  size: AppDimensions.iconXLarge,
                  color: AppColors.grey400,
                ),
                 SizedBox(height: AppDimensions.spacingXLarge),
                CommonText(
                  text: 'No images in gallery',
                  fontSize: AppFontSizes.fontLarge,
                  color: AppColors.grey600,
                ),
                 SizedBox(height: AppDimensions.paddingLarge),
                ElevatedButton.icon(
                  onPressed: controller.pickImageFromGallery,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: CommonText(text: 'Add Images'),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(AppDimensions.marginSmall),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppDimensions.marginSmall,
            mainAxisSpacing: AppDimensions.marginSmall,
          ),
          itemCount: controller.galleryImages.length,
          itemBuilder: (context, index) {
            final image = controller.galleryImages[index];
            return GestureDetector(
              onTap: () => _showImagePreview(image, index),
              onLongPress: () => _showImageOptions(index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'camera',
            onPressed: controller.pickImageFromCamera,
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'gallery',
            onPressed: controller.pickImageFromGallery,
            child: const Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(File image, int index) {
    controller.selectImage(image);
    Get.dialog(
      Dialog(
        child: Stack(
          children: [
            Image.file(image),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      _showImageOptions(index);
                    },
                    icon: const Icon(Icons.more_vert),
                    label: const Text('Options'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageOptions(int index) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: CommonText(text: AppTexts.share),
              onTap: () {
                Get.back();
                controller.shareImage(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: CommonText(text: AppTexts.delete),
              onTap: () {
                Get.back();
                _showDeleteDialog(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: CommonText(text: AppTexts.cancel),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    Get.dialog(
      AlertDialog(
        title: CommonText(text: AppTexts.deleteDocument),
        content: CommonText(text: AppTexts.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CommonText(text: AppTexts.cancel),
          ),
          TextButton(
            onPressed: () {
              controller.deleteImage(index);
              Get.back();
            },
            child: CommonText(text: AppTexts.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showClearDialog() {
    Get.dialog(
      AlertDialog(
        title: CommonText(text: 'Clear Gallery'),
        content: CommonText(text: 'Are you sure you want to clear all images?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CommonText(text: AppTexts.cancel),
          ),
          TextButton(
            onPressed: () {
              controller.clearGallery();
              Get.back();
            },
            child: CommonText(text: 'Clear', color: Colors.red),
          ),
        ],
      ),
    );
  }
}