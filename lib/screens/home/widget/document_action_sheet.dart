// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../utils/app_colors.dart';
// import '../../../utils/app_constants.dart';
// import '../../../utils/app_dimensions.dart';
// import '../../../utils/app_font_sizes.dart';
// import '../../../utils/app_texts.dart';
// import '../../../widgets/common/common_text.dart';
//
// class DocumentActionSheet {
//   static void show({
//     required BuildContext context,
//     required File imageFile,
//     required String title,
//     required VoidCallback onShare,
//     required VoidCallback onDelete,
//     required Function(String) onRename,
//     VoidCallback? onFavorite,
//   }) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _DocumentBottomSheet(
//         imageFile: imageFile,
//         title: title,
//         onShare: onShare,
//         onDelete: onDelete,
//         onRename: onRename,
//         onFavorite: onFavorite,
//       ),
//     );
//   }
// }
//
// class _DocumentBottomSheet extends StatelessWidget {
//   final File imageFile;
//   final String title;
//   final VoidCallback onShare;
//   final VoidCallback onDelete;
//   final Function(String) onRename;
//   final VoidCallback? onFavorite;
//
//   const _DocumentBottomSheet({
//     required this.imageFile,
//     required this.title,
//     required this.onShare,
//     required this.onDelete,
//     required this.onRename,
//     this.onFavorite,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _item(
//             leading: Icons.edit_outlined,
//             trailing: Icons.edit,
//             title: AppTexts.renameDocument,
//             onTap: () {
//               Get.back();
//               _showRenameDialog();
//             },
//           ),
//
//           _item(
//             leading: Icons.share_outlined,
//             trailing: Icons.ios_share,
//             title: AppTexts.share,
//             onTap: () {
//               Get.back();
//               onShare();
//             },
//           ),
//
//           _item(
//             leading: Icons.star_outline,
//             trailing: Icons.star_border,
//             title: AppTexts.favorites,
//             onTap: () {
//               Get.back();
//               if (onFavorite != null) {
//                 onFavorite!();
//               } else {
//                 AppConstants.showCommonSnackBar(
//                   message: "Added to favourites",
//                 );
//               }
//             },
//           ),
//
//           _item(
//             leading: Icons.delete_outline,
//             trailing: Icons.delete,
//             title: AppTexts.delete,
//             color: AppColors.redColor,
//             onTap: () {
//               Get.back();
//               _confirmDelete();
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _item({
//     required IconData leading,
//     required IconData trailing,
//     required String title,
//     required VoidCallback onTap,
//     Color color = AppColors.black87,
//   }) {
//     return ListTile(
//       leading: Icon(
//         leading,
//         color: color,
//       ),
//       title: CommonText(
//         text: title,
//         fontSize: AppFontSizes.font16,
//         color: color,
//       ),
//       trailing: Icon(
//         trailing,
//         color: color == AppColors.redColor
//             ? AppColors.redColor
//             : AppColors.grey,
//         size: AppDimensions.iconSmall,
//       ),
//       onTap: onTap,
//     );
//   }
//
//   void _showRenameDialog() {
//     final controller = TextEditingController(text: title);
//
//     Get.dialog(
//       AlertDialog(
//         title: CommonText(
//           text: AppTexts.renameDocument,
//         ),
//         content: TextField(
//           controller: controller,
//           autofocus: true,
//           decoration: InputDecoration(
//             hintText: AppTexts.documentName,
//             border: const OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: Get.back,
//             child: CommonText(text: AppTexts.cancel),
//           ),
//           TextButton(
//             onPressed: () {
//               Get.back();
//               onRename(controller.text);
//             },
//             child: CommonText(
//               text: AppTexts.renameDocument,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _confirmDelete() {
//     Get.dialog(
//       AlertDialog(
//         title: CommonText(
//           text: AppTexts.deleteDocument,
//           color: AppColors.blackColor,
//           fontSize: AppFontSizes.font16,
//         ),
//         content: CommonText(
//           text: AppTexts.deleteConfirmMessage,
//           color: AppColors.blackColor,
//         ),
//         actions: [
//           TextButton(
//             onPressed: Get.back,
//             child: CommonText(
//               text: AppTexts.cancel,
//               color: AppColors.blackColor,
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Get.back();
//               onDelete();
//             },
//             child: const CommonText(
//               text: "Delete",
//               color: Colors.red,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }