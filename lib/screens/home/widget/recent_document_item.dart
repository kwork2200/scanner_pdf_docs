import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class RecentDocumentItemListView extends StatelessWidget {
  final List<File> images;
  final String Function(int index) titleBuilder;
  final String Function(File image) sizeBuilder;
  final VoidCallback Function(File image) onTap;
  final void Function(BuildContext context, File image, String title, )? onLongPress;
  final bool isGrid;

  const RecentDocumentItemListView({
    super.key,
    required this.images,
    required this.titleBuilder,
    required this.sizeBuilder,
    required this.onTap,
    this.onLongPress,
    this.isGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return isGrid ? _buildGridView(context) : _buildListView(context);
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.67,
      ),
      itemBuilder: (context, index) {
        return _buildItem(context, index);
      },
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      separatorBuilder: (_, __) => Spacing.height(AppDimensions.spacingLarge),
      itemBuilder: (context, index) {
        return _buildItem(context, index);
      },
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final image = images[index];
    final title = titleBuilder(index);

    return RecentDocumentItem(
      imageFile: image,
      title: title,
      date: '06.08.2026',
      size: sizeBuilder(image),
      isGrid: isGrid,
      onTap: () => onTap(image),
      onLongPress: onLongPress == null ? null : () => onLongPress!(context, image, title),
    );
  }
}

class RecentDocumentItem extends StatelessWidget {
  final File imageFile;
  final String title;
  final String date;
  final String size;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isGrid;

  const RecentDocumentItem({
    super.key,
    required this.imageFile,
    required this.title,
    required this.date,
    required this.size,
    required this.onTap,
    this.onLongPress,
    this.isGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // onTap: isGrid ? null : onTap,
      onLongPress: isGrid ? null : onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
        child: isGrid ? _buildGridContent() : _buildListContent(),
      ),
    );
  }

  Widget _buildListContent() {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacingLarge),
      child: Row(
        children: [
          _buildImage(width: AppDimensions.paddingXLarge40 + 5.w,height: AppDimensions.paddingXLarge40 + 5.h),
          Spacing.width(AppDimensions.spacingLarge),
          Expanded(child: _buildDocumentInfo()),
        ],
      ),
    );
  }

  Widget _buildGridContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(aspectRatio: 1, child: _buildImage(width: double.infinity, height: double.infinity),),
        Spacing.height(AppDimensions.paddingSmall - 6.w),
        _buildTitle(),
        _buildSubtitle(),
      ],
    );
  }

  Widget _buildDocumentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        _buildSubtitle(),
      ],
    );
  }

  Widget _buildTitle() {
    return CommonText(
      text: title,
      fontSize: isGrid ? AppFontSizes.fontSmall : AppFontSizes.font14,
      fontWeight: AppFontWeights.medium,
      color: AppColors.blackColor,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildSubtitle() {
    return CommonText(
      text: '$date  $size',
      fontSize: AppFontSizes.fontNeNoSmall,
      color: AppColors.grey,
      fontWeight: AppFontWeights.medium,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildImage({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        child: Image.file(
          imageFile, width: width, height: height, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
            return Container(
              color: AppColors.infoBlue,
              alignment: Alignment.center,
              child: Icon(Icons.document_scanner, color: AppColors.whiteColor, size: AppDimensions.iconLarge),
            );
          },
        ),
      ),
    );
  }
}