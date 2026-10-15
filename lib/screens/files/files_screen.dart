import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_controller.dart';
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
import 'package:scanner_pdf_docs/widgets/components/ads/hybrid_native_ad_widget.dart';
import 'package:scanner_pdf_docs/utils/functions.dart';

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
                  color: AppColors.grey,
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

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(AppDimensions.paddingSmall),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildListItemWithAds(context, index);
                  },
                  childCount: _getItemCountWithAds(controller.capturedImages.length),
                ),
              ),
            ),
          ],
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
            ListTile(
              leading: const Icon(
                Icons.edit_outlined,
                color: AppColors.black87,
              ),
              title: CommonText(
                text: AppTexts.renameDocument,
                fontSize: AppFontSizes.font16,
                color: AppColors.blackColor,
              ),
              trailing: Icon(
                Icons.edit,
                size: AppDimensions.iconMedium,
                color: AppColors.grey,
              ),
              onTap: () {
                Get.back();
                _showRenameDialog(title);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.share_outlined,
                color: AppColors.black87,
              ),
              title: CommonText(
                text: AppTexts.share,
                fontSize: AppFontSizes.font16,
                color: AppColors.blackColor,
              ),
              trailing: Icon(
                Icons.ios_share,
                size: AppDimensions.iconMedium,
                color: AppColors.grey,
              ),
              onTap: () {
                Get.back();
                controller.currentImage.value = imageFile;
                controller.shareAsJPG();
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_outline, color: AppColors.black87),
              title: CommonText(
                text: AppTexts.favorites,
                fontSize: AppFontSizes.font16,
                color: AppColors.blackColor,
              ),
              trailing: Icon(
                Icons.star_border,
                size: AppDimensions.iconMedium,
                color: AppColors.grey,
              ),
              onTap: () {
                Get.back();
                AppConstants.showCommonSnackBar(message: 'Added to favourites');
              },
            ),
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
                size: AppDimensions.iconMedium,
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

  // Calculate total items including ad rows
  int _getItemCountWithAds(int imageCount) {
    if (imageCount == 0) return 0;
    
    int fullRows = imageCount ~/ 3; // Complete rows of 3 docs
    int remainder = imageCount % 3; // Remaining docs
    
    // One row per 3 docs + one ad row after each 3 docs
    int totalRows = fullRows * 2; // Each group of 3 docs = 1 grid row + 1 ad row
    
    if (remainder > 0) {
      totalRows += 1; // Add one more grid row for remaining docs
    }
    
    return totalRows;
  }

  // Build grid rows and ad rows
  Widget _buildListItemWithAds(BuildContext context, int rowIndex) {
    final controller = Get.find<ScanController>();
    
    // Determine if this row is an ad row or grid row
    // Pattern: grid, ad, grid, ad, grid, ad...
    final bool isAdRow = rowIndex % 2 == 1; // Odd indices are ad rows
    
    if (isAdRow) {
      // Ad row - full width native ad
      final adNumber = (rowIndex ~/ 2) + 1;
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: HybridNativeAdWidget(
          height: 120,
          smallHeight: 80,
          adKey: 'files_tab_ad_$adNumber',
          margin: EdgeInsets.zero,
        ),
      );
    }
    
    // Grid row - show 3 documents
    final gridRowNumber = rowIndex ~/ 2;
    final startIndex = gridRowNumber * 3;
    
    if (startIndex >= controller.capturedImages.length) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(3, (colIndex) {
          final imageIndex = startIndex + colIndex;
          
          if (imageIndex >= controller.capturedImages.length) {
            return Expanded(child: SizedBox.shrink());
          }
          
          final image = controller.capturedImages[imageIndex];
          final fileSize = _getFileSize(image);
          final fileName = 'Document ${imageIndex + 1}';
          
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: colIndex < 2 ? 4 : 0,
              ),
              child: _buildDocumentCard(
                context,
                image,
                fileName,
                fileSize,
                imageIndex,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDocumentCard(
    BuildContext context,
    File image,
    String fileName,
    String fileSize,
    int imageIndex,
  ) {
    final controller = Get.find<ScanController>();
    
    return InkWell(
      onTap: () async {
        // Show ad before opening document editor
        await showManagedInterstitialAd(context);
        
        controller.currentImage.value = image;
        Get.toNamed(AppRoutes.documentEditor, arguments: {'selectedImage': image});
      },
      onLongPress: () {
        _showContextMenu(context, image, fileName, imageIndex);
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
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusSmall),
                    topRight: Radius.circular(AppDimensions.radiusSmall),
                  ),
                  color: AppColors.grey300,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusSmall),
                    topRight: Radius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Image.file(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image,
                        color: AppColors.grey,
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
                    color: AppColors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
