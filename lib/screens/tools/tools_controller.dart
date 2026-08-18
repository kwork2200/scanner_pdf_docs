import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/screens/tools/models/tool_model.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';

class ToolsController extends GetxController {
  final selectedTabIndex = 0.obs;

  final List<ToolModel> scanTools = [
    ToolModel(
      icon: Icons.document_scanner_outlined,
      title: 'Single',
      subtitle: 'Scan Single Document',
      route: AppRoutes.cameraScan,
    ),
    ToolModel(
      icon: Icons.view_carousel_outlined,
      title: 'Batch',
      subtitle: 'Scan Batch Document',
      route: AppRoutes.batchScan,
    ),
    ToolModel(
      icon: Icons.grid_3x3_outlined,
      title: 'Count Objects',
      subtitle: 'Scan Objects',
      route: AppRoutes.countObjects,
    ),
    ToolModel(
      icon: Icons.credit_card_outlined,
      title: 'ID Card',
      subtitle: 'Scan ID cards',
      route: AppRoutes.idCardScanner,
    ),
    ToolModel(
      icon: Icons.badge_outlined,
      title: 'Passport',
      subtitle: 'Scan Passport',
      route: AppRoutes.passportScanner,
    ),
    ToolModel(
      icon: Icons.qr_code_scanner_outlined,
      title: 'QR Code',
      subtitle: 'Scan QR Codes',
      route: AppRoutes.qrScanner,
    ),
    ToolModel(
      icon: Icons.text_fields_outlined,
      title: 'Extract Text',
      subtitle: 'Extract texts',
      route: AppRoutes.extractText,
    ),
  ];

  final List<EditToolModel> editTools = [
    EditToolModel(
      icon: Icons.draw_outlined,
      title: 'Signature',
      route: AppRoutes.signature,
    ),
    EditToolModel(
      icon: Icons.branding_watermark_outlined,
      title: 'Stamp',
      route: AppRoutes.stamp,
    ),
  ];

  final List<ConvertToolModel> convertTools = [
    ConvertToolModel(
      icon: Icons.picture_as_pdf,
      iconColor: AppColors.redColor,
      title: 'Convert to PDF',
      route: AppRoutes.convert,
    ),
    ConvertToolModel(
      icon: Icons.description,
      iconColor: AppColors.infoBlue,
      title: 'Convert to DOC',
      route: AppRoutes.convert,
    ),
    ConvertToolModel(
      icon: Icons.image,
      iconColor: AppColors.darkBlueColor,
      title: 'Convert to JPG',
      route: AppRoutes.convert,
    ),
    ConvertToolModel(
      icon: Icons.text_snippet,
      iconColor: AppColors.grey600,
      title: 'Convert to TXT',
      route: AppRoutes.convert,
    ),
    ConvertToolModel(
      icon: Icons.description,
      iconColor: AppColors.orangeColor,
      title: 'Convert to PPTX',
      route: AppRoutes.convert,
    ),
  ];

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
