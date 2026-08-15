import 'dart:io';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/bottom_nav_bar/bottom_nav_bar_screen.dart';
import 'package:scanner_pdf_docs/screens/home/home_screen.dart';
import 'package:scanner_pdf_docs/screens/splash/splash_binding.dart';
import 'package:scanner_pdf_docs/screens/splash/splash_screen.dart';
import 'package:scanner_pdf_docs/screens/bottom_nav_bar/bottom_nav_bar_binding.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_binding.dart';
import 'package:scanner_pdf_docs/screens/scan/scan_screen.dart';
import 'package:scanner_pdf_docs/screens/gallery/gallery_binding.dart';
import 'package:scanner_pdf_docs/screens/gallery/gallery_screen.dart';
import 'package:scanner_pdf_docs/screens/editor/editor_binding.dart';
import 'package:scanner_pdf_docs/screens/editor/camera_scan_screen.dart';
import 'package:scanner_pdf_docs/screens/editor/image_editor_screen.dart';
import 'package:scanner_pdf_docs/screens/editor/document_editor_screen.dart';
import 'package:scanner_pdf_docs/screens/editor/preview_share_screen.dart';
import 'package:scanner_pdf_docs/screens/qr_scanner/qr_scanner_screen.dart';
import 'package:scanner_pdf_docs/screens/qr_scanner/qr_scanner_binding.dart';
import 'package:scanner_pdf_docs/screens/id_card_scanner/id_card_scanner_screen.dart';
import 'package:scanner_pdf_docs/screens/id_card_scanner/id_card_scanner_binding.dart';
import 'package:scanner_pdf_docs/screens/count_objects/count_objects_screen.dart';
import 'package:scanner_pdf_docs/screens/count_objects/count_objects_binding.dart';
import 'package:scanner_pdf_docs/screens/signature/signature_screen.dart';
import 'package:scanner_pdf_docs/screens/signature/signature_binding.dart';
import 'package:scanner_pdf_docs/screens/tools/tools_screen.dart';
import 'package:scanner_pdf_docs/screens/tools/tools_binding.dart';
import 'package:scanner_pdf_docs/screens/account/account_screen.dart';
import 'package:scanner_pdf_docs/screens/account/account_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(name: AppRoutes.home, page: () => HomeTab()),
    GetPage(
      name: AppRoutes.bottomNavBar,
      page: () => BottomNavBrScreen(),
      binding: BottomNavBarBinding(),
    ),
    GetPage(
      name: AppRoutes.scan,
      page: () => ScanScreen(),
      binding: ScanBinding(),
    ),
    GetPage(
      name: AppRoutes.gallery,
      page: () => GalleryScreen(),
      binding: GalleryBinding(),
    ),
    GetPage(
      name: AppRoutes.cameraScan,
      page: () => const CameraScanScreen(),
      binding: EditorBinding(),
    ),
    GetPage(
      name: AppRoutes.imageEditor,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return ImageEditorScreen(imageFile: args?['imageFile'] as File?);
      },
      binding: EditorBinding(),
    ),
    GetPage(
      name: AppRoutes.documentEditor,
      page: () => const DocumentEditorScreen(),
      binding: EditorBinding(),
    ),
    GetPage(
      name: AppRoutes.previewShare,
      page: () => const PreviewShareScreen(),
      binding: EditorBinding(),
    ),
    GetPage(
      name: AppRoutes.qrScanner,
      page: () => const QrScannerScreen(),
      binding: QrScannerBinding(),
    ),
    GetPage(
      name: AppRoutes.idCardScanner,
      page: () => const IdCardScannerScreen(),
      binding: IdCardScannerBinding(),
    ),
    GetPage(
      name: AppRoutes.countObjects,
      page: () => const CountObjectsScreen(),
      binding: CountObjectsBinding(),
    ),
    GetPage(
      name: AppRoutes.signature,
      page: () => const SignatureScreen(),
      binding: SignatureBinding(),
    ),
    GetPage(
      name: AppRoutes.tools,
      page: () => const ToolsScreen(),
      binding: ToolsBinding(),
    ),
    GetPage(
      name: AppRoutes.account,
      page: () => const AccountScreen(),
      binding: AccountBinding(),
    ),
  ];
}
