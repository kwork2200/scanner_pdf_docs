import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/home/widget/feature_card_widget.dart';
import 'package:scanner_pdf_docs/screens/home/widget/recent_document_item.dart';
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
import 'package:scanner_pdf_docs/widgets/common/common_text_field.dart';

class HomeTab extends GetView<ScanController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.infoBlue.withValues(alpha: 0.01),
      appBar: CommonAppBar(title: AppTexts.appTitle),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.backgroundColor,
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingMedium),
                child: CommonTextField(
                  hintText: AppTexts.searchHint,
                  fillColor: AppColors.infoBlue.withValues(alpha: 0.05),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10.h,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.grey),
                ),
              ),
            ),
            Spacing.height(AppDimensions.paddingSmall),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppDimensions.paddingXMedium,
              crossAxisSpacing: AppDimensions.paddingSmall,
              mainAxisExtent: 70.h,
              children: [
                FeatureCardWidget(
                  icon: Icons.credit_card,
                  label: 'ID Cards',
                  color: AppColors.infoBlue,
                  onTap: () {
                    Get.toNamed(AppRoutes.idCardScanner);
                  },
                ),
                FeatureCardWidget(
                  icon: Icons.qr_code_scanner,
                  label: 'Scan\nQR Code',
                  color: AppColors.infoBlue,
                  onTap: () {
                    Get.toNamed(AppRoutes.qrScanner);
                  },
                ),
                FeatureCardWidget(
                  icon: Icons.photo_library,
                  label: 'Import\nImages',
                  color: AppColors.infoBlue,
                  onTap: () {
                    AppConstants.pickImages(
                      onImagesSelected: (imagePaths) async {
                        for (final path in imagePaths) {
                          await controller.addFile(File(path));
                        }
                      },
                      allowMultiple: true,
                    );
                  },
                ),
                FeatureCardWidget(
                  icon: Icons.draw,
                  label: 'Signature',
                  color: AppColors.infoBlue,
                  onTap: () {
                    Get.toNamed(AppRoutes.signature);
                  },
                ),
                FeatureCardWidget(
                  icon: Icons.folder_open,
                  label: 'Import\nFiles',
                  color: AppColors.infoBlue,
                  onTap: () {
                    AppConstants.pickFiles(
                      onFilesSelected: (filePaths) async {
                        // Handle selected files here
                        for (final path in filePaths) {
                          await controller.addFile(File(path));
                        }
                      },
                      allowMultiple: true,
                    );
                  },
                ),
                FeatureCardWidget(
                  icon: Icons.calculate,
                  label: 'Count\nObjects',
                  color: AppColors.infoBlue,
                  onTap: () {
                    Get.toNamed(AppRoutes.countObjects);
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacing.height(AppDimensions.paddingSmall),
                  CommonText(
                    text: AppTexts.recentS,
                    fontSize: AppFontSizes.font14,
                    fontWeight: AppFontWeights.bold,
                    color: AppColors.blackColor,
                  ),
                  Spacing.height(AppDimensions.spacingXLarge),
                  Obx(() {
                    if (controller.capturedImages.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppDimensions.paddingXLarge),
                          child: CommonText(
                            text: AppTexts.noDocumentsFound,
                            color: AppColors.grey,
                            fontSize: AppFontSizes.font16,
                          ),
                        ),
                      );
                    }

                    return RecentDocumentItemListView(
                      images: controller.capturedImages,
                      isGrid: false, // ListView
                      titleBuilder: (index) {
                        return 'M08 06, Doc ${index + 1}';
                      },
                      sizeBuilder: (image) {
                        return AppConstants.getFileSize(image);
                      },
                      onTap: (image) {
                        controller.currentImage.value = image;
                        Get.toNamed(
                          AppRoutes.documentEditor,
                          arguments: {'selectedImage': image},
                        );
                        return () {
                          print("2222");
                        };
                      },
                      onLongPress: (context, image, title) {
                        _showContextMenu(context, image, title);
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, File imageFile, String title) {
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
                size: AppDimensions.iconSmall,
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
                size: AppDimensions.iconSmall,
                color: AppColors.grey,
              ),
              onTap: () {
                Get.back();
                final scanController = Get.find<ScanController>();
                scanController.currentImage.value = imageFile;
                scanController.shareAsJPG();
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
                size: AppDimensions.iconSmall,
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
                size: AppDimensions.iconSmall,
                color: AppColors.redColor,
              ),
              onTap: () {
                Get.back();
                _confirmDelete(imageFile, title);
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

  void _confirmDelete(File imageFile, String title) {
    Get.dialog(
      AlertDialog(
        title: CommonText(
          text: AppTexts.deleteDocument,
          color: AppColors.blackColor,
          fontSize: AppFontSizes.fontLarge,
          fontWeight: AppFontWeights.extraBold,
        ),
        content: CommonText(
          text: AppTexts.deleteConfirmMessage,
          color: AppColors.blackColor,
          fontSize: AppFontSizes.fontSmall,
          fontWeight: AppFontWeights.normal,
          softWrap: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CommonText(text: AppTexts.cancel,color: AppColors.blackColor,fontSize: AppFontSizes.font14,fontWeight: AppFontWeights.normal),
          ),
          TextButton(
            onPressed: () {
              final scanController = Get.find<ScanController>();
              final index = scanController.capturedImages.indexOf(imageFile);
              if (index != -1) {
                scanController.deleteImage(index);
              }
              Get.back();
              AppConstants.showCommonSnackBar(
                message: 'Document deleted successfully',
                isError: true,
              );
            },
            child: CommonText(text: AppTexts.delete,color: AppColors.errorColor,fontSize: AppFontSizes.font14,fontWeight: AppFontWeights.normal),
          ),
        ],
      ),
    );
  }
}
