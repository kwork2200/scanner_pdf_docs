import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
import 'package:scanner_pdf_docs/screens/editor/document_editor_screen.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/widgets/common/common_app_bar.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class FilesTab extends GetView<ScanController> {
  const FilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: AppTexts.scannerApp),
      body: Obx(() {
        if (controller.capturedImages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open,
                  size: AppDimensions.iconXLarge,
                  color: AppColors.grey400,
                ),
                Spacing.height(AppDimensions.spacingSmall),
                CommonText(
                  text: AppTexts.noDocumentsFound,
                  fontSize: AppFontSizes.font16,
                  color: AppColors.grey600,
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(AppDimensions.paddingSmall),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: controller.capturedImages.length,
          itemBuilder: (context, index) {
            final image = controller.capturedImages[index];
            final fileSize = _getFileSize(image);
            final fileName = 'Document ${index + 1}';

            return InkWell(
              onTap: () {
                controller.currentImage.value = image;
                Get.toNamed(AppRoutes.documentEditor);
              },
              onLongPress: () {
                _showContextMenu(context, image, fileName, index);
              },
              child: Card(
                elevation: 2,
                color: AppColors.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppDimensions.radiusSmall),
                            topRight: Radius.circular(
                              AppDimensions.radiusSmall,
                            ),
                          ),
                          color: AppColors.grey300,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppDimensions.radiusSmall),
                            topRight: Radius.circular(
                              AppDimensions.radiusSmall,
                            ),
                          ),
                          child: Image.file(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image,
                                color: AppColors.grey400,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: fileName,
                            fontSize: AppFontSizes.fontNeNoSmall,
                            fontWeight: AppFontWeights.medium,
                            color: AppColors.blackColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          CommonText(
                            text: fileSize,
                            fontSize: AppFontSizes.fontNeNoSmall,
                            color: AppColors.grey400,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showContextMenu(
    BuildContext context,
    File imageFile,
    String title,
    int index,
  ) {
    final controller = Get.find<ScanController>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rename Option
            ListTile(
              leading: const Icon(
                Icons.edit_outlined,
                color: AppColors.black87,
              ),
              title: CommonText(
                text: AppTexts.renameDocument,
                fontSize: AppFontSizes.font16,
              ),
              trailing: Icon(
                Icons.edit,
                size: AppDimensions.iconSmall,
                color: AppColors.grey400,
              ),
              onTap: () {
                Get.back();
                _showRenameDialog(title);
              },
            ),

            // Share Option
            ListTile(
              leading: const Icon(
                Icons.share_outlined,
                color: AppColors.black87,
              ),
              title: CommonText(
                text: AppTexts.share,
                fontSize: AppFontSizes.font16,
              ),
              trailing: Icon(
                Icons.ios_share,
                size: AppDimensions.iconSmall,
                color: AppColors.grey400,
              ),
              onTap: () {
                Get.back();
                controller.currentImage.value = imageFile;
                controller.shareAsJPG();
              },
            ),

            // Favourite Option
            ListTile(
              leading: const Icon(Icons.star_outline, color: AppColors.black87),
              title: CommonText(
                text: AppTexts.favorites,
                fontSize: AppFontSizes.font16,
              ),
              trailing: Icon(
                Icons.star_border,
                size: AppDimensions.iconSmall,
                color: AppColors.grey400,
              ),
              onTap: () {
                Get.back();
                AppConstants.showCommonSnackBar(message: 'Added to favourites');
              },
            ),

            // Delete Option (Red)
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: AppColors.redColor,
              ),
              title: CommonText(
                text: AppTexts.delete,
                fontSize: AppFontSizes.font16,
                color: AppColors.redColor,
              ),
              trailing: Icon(
                Icons.delete,
                size: AppDimensions.iconSmall,
                color: AppColors.redColor,
              ),
              onTap: () {
                Get.back();
                _confirmDelete(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(String currentName) {
    final TextEditingController nameController = TextEditingController(
      text: currentName,
    );

    Get.dialog(
      AlertDialog(
        title: CommonText(text: AppTexts.renameDocument),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: AppTexts.documentName,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CommonText(text: AppTexts.cancel),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              AppConstants.showCommonSnackBar(
                message: 'Document renamed to ${nameController.text}',
              );
            },
            child: CommonText(text: AppTexts.renameDocument),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int index) {
    final controller = Get.find<ScanController>();

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
              AppConstants.showCommonSnackBar(
                message: 'Document deleted successfully',
                isError: true,
              );
            },
            child: CommonText(text: AppTexts.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  String _getFileSize(File file) {
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
}
