import 'dart:io';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/app_pin/app_pin/app_pin_screen.dart';
import 'package:scanner_pdf_docs/screens/app_pin/pin_verification/pin_verification_binding.dart';
import 'package:scanner_pdf_docs/screens/app_pin/pin_verification/pin_verification_screen.dart';
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
import 'package:scanner_pdf_docs/screens/passport_scanner/passport_scanner_screen.dart';
import 'package:scanner_pdf_docs/screens/passport_scanner/passport_scanner_binding.dart';
import 'package:scanner_pdf_docs/screens/count_objects/count_objects_screen.dart';
import 'package:scanner_pdf_docs/screens/count_objects/count_objects_binding.dart';
import 'package:scanner_pdf_docs/screens/extract_text/extract_text_screen.dart';
import 'package:scanner_pdf_docs/screens/extract_text/extract_text_binding.dart';
import 'package:scanner_pdf_docs/screens/signature/signature_screen.dart';
import 'package:scanner_pdf_docs/screens/signature/signature_binding.dart';
import 'package:scanner_pdf_docs/screens/convert/convert_screen.dart';
import 'package:scanner_pdf_docs/screens/convert/convert_binding.dart';
import 'package:scanner_pdf_docs/screens/stamp/stamp_screen.dart';
import 'package:scanner_pdf_docs/screens/stamp/stamp_binding.dart';
import 'package:scanner_pdf_docs/screens/batch_scan/batch_scan_screen.dart';
import 'package:scanner_pdf_docs/screens/batch_scan/batch_scan_binding.dart';
import 'package:scanner_pdf_docs/screens/tools/tools_screen.dart';
import 'package:scanner_pdf_docs/screens/tools/tools_binding.dart';
import 'package:scanner_pdf_docs/screens/account/account_screen.dart';
import 'package:scanner_pdf_docs/screens/account/account_binding.dart';
import 'package:scanner_pdf_docs/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:scanner_pdf_docs/screens/privacy_policy/privacy_policy_binding.dart';
import 'package:scanner_pdf_docs/screens/terms_conditions/terms_conditions_screen.dart';
import 'package:scanner_pdf_docs/screens/terms_conditions/terms_conditions_binding.dart';
import 'package:scanner_pdf_docs/screens/contact_us/contact_us_screen.dart';
import 'package:scanner_pdf_docs/screens/contact_us/contact_us_binding.dart';
import 'package:scanner_pdf_docs/screens/faq/faq_screen.dart';
import 'package:scanner_pdf_docs/screens/faq/faq_binding.dart';
import 'package:scanner_pdf_docs/screens/premium/premium_screen.dart';
import 'package:scanner_pdf_docs/screens/premium/premium_binding.dart';
import 'package:scanner_pdf_docs/screens/app_pin/app_pin/app_pin_binding.dart';
import 'package:scanner_pdf_docs/screens/app_pin/create_pin/create_pin_screen.dart';
import 'package:scanner_pdf_docs/screens/app_pin/create_pin/create_pin_binding.dart';
import 'package:scanner_pdf_docs/screens/picture_quality/picture_quality_screen.dart';
import 'package:scanner_pdf_docs/screens/picture_quality/picture_quality_binding.dart';
import 'package:scanner_pdf_docs/screens/start_app_with/start_app_with_screen.dart';
import 'package:scanner_pdf_docs/screens/start_app_with/start_app_with_binding.dart';
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
      name: AppRoutes.batchScan,
      page: () => const BatchScanScreen(),
      binding: BatchScanBinding(),
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
      name: AppRoutes.passportScanner,
      page: () => const PassportScannerScreen(),
      binding: PassportScannerBinding(),
    ),
    GetPage(
      name: AppRoutes.countObjects,
      page: () => const CountObjectsScreen(),
      binding: CountObjectsBinding(),
    ),
    GetPage(
      name: AppRoutes.extractText,
      page: () => const ExtractTextScreen(),
      binding: ExtractTextBinding(),
    ),
    GetPage(
      name: AppRoutes.signature,
      page: () => const SignatureScreen(),
      binding: SignatureBinding(),
    ),
    GetPage(
      name: AppRoutes.convert,
      page: () => const ConvertScreen(),
      binding: ConvertBinding(),
    ),
    GetPage(
      name: AppRoutes.stamp,
      page: () => const StampScreen(),
      binding: StampBinding(),
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
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: AppRoutes.termsConditions,
      page: () => const TermsConditionsScreen(),
      binding: TermsConditionsBinding(),
    ),
    GetPage(
      name: AppRoutes.contactUs,
      page: () => const ContactUsScreen(),
      binding: ContactUsBinding()
    ),
    GetPage(
      name: AppRoutes.faq,
      page: () => const FaqScreen(),
      binding: FaqBinding()
    ),
    GetPage(
      name: AppRoutes.premium,
      page: () => const PremiumScreen(),
      binding: PremiumBinding()
    ),
    GetPage(
      name: AppRoutes.appPin,
      page: () => const AppPinScreen(),
      binding: AppPinBinding()
    ),
    GetPage(
      name: AppRoutes.createPin,
      page: () => const CreatePinScreen(),
      binding: CreatePinBinding()
    ),
    GetPage(
      name: AppRoutes.pinVerification,
      page: () => const PinVerificationScreen(),
      binding: PinVerificationBinding()
    ),
    GetPage(
      name: AppRoutes.pictureQuality,
      page: () => const PictureQualityScreen(),
      binding: PictureQualityBinding()
    ),
    GetPage(
      name: AppRoutes.startAppWith,
      page: () => const StartAppWithScreen(),
      binding: StartAppWithBinding()
    ),
  ];
}
