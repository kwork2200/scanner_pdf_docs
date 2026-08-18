import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scanner_pdf_docs/screens/account/models/account_settings_model.dart';
import 'package:scanner_pdf_docs/screens/account/models/premium_feature_model.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';

class AccountController extends GetxController {
  final String userId = 'd71e5b7252153f07d64ec137f1fae316';
  String appVersion = 'Loading...';

  final List<PremiumFeatureModel> premiumFeatures = [
    PremiumFeatureModel(
      title: AppTexts.unlimitedScanExport,
      onTap: () {},
    ),
    PremiumFeatureModel(
      title: AppTexts.textRecognition,
      onTap: () {},
    ),
    PremiumFeatureModel(
      title: AppTexts.signStamp,
      onTap: () {},
    ),
    PremiumFeatureModel(
      title: AppTexts.noAdsWatermarks,
      onTap: () {},
    ),
  ];

  late final List<AccountSettingsModel> settingsItems;

  void copyUserId() {
    Clipboard.setData(ClipboardData(text: userId));
    Get.snackbar(
      AppTexts.success,
      AppTexts.userIdCopied,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.successGreen,
      colorText: AppColors.whiteColor,
      margin: EdgeInsets.all(AppDimensions.paddingMedium),
    );
  }

  Future<void> shareApp() async {
    await AppConstants.shareApp();
  }

  Future<void> rateApp() async {
    await AppConstants.rateApp();
  }

  Future<void> openContactUs() async {
    Get.toNamed(AppRoutes.contactUs);
  }

  Future<void> openPrivacyPolicy() async {
    Get.toNamed(AppRoutes.privacyPolicy);
  }

  Future<void> openTermsConditions() async {
    Get.toNamed(AppRoutes.termsConditions);
  }

  Future<void> openFaq() async {
    Get.toNamed(AppRoutes.faq);
  }

  Future<void> openPremium() async {
    await AppConstants.showPremiumScreen();
  }

  Future<void> initAppVersion() async {
    appVersion = await AppConstants.getAppVersion();
  }

  Future<void> openSupportEmail() async {
    final email = 'support@fastscanapp.com';

    try {
      final emailBody =
          'User Feedback\n\n\n\n'
          '**Do not edit below this line**\n\n'
          'User ID:\n'
          '$userId\n\n'
          'App Version: Version $appVersion';

      final emailLaunchUri = Uri.parse(
        'mailto:$email'
            '?subject=${Uri.encodeComponent('User Feedback')}'
            '&body=${Uri.encodeComponent(emailBody)}',
      );

      await launchUrl(
        emailLaunchUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Error opening email: $e');

      Get.dialog(
        AlertDialog(
          title: const Text('Email Support'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Please email us at:'),
              const SizedBox(height: 8),
              SelectableText(
                email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: email),
                );

                Get.back();

                AppConstants.showCommonSnackBar(
                  message: 'Email address copied',
                  isError: false,
                );
              },
              child: const Text('Copy Email'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();

    initAppVersion();

    settingsItems = [
      AccountSettingsModel(
        icon: Icons.headset_mic_outlined,
        title: AppTexts.support,
        onTap: openSupportEmail,
      ),
      AccountSettingsModel(
        icon: Icons.copy_outlined,
        title: AppTexts.copyUserId,
        subtitle: userId,
        onTap: copyUserId,
      ),
      AccountSettingsModel(
        icon: Icons.lock_outline,
        title: AppTexts.appPin,
      ),
      AccountSettingsModel(
        icon: Icons.star_outline,
        title: AppTexts.getPro,
        onTap: openPremium,
      ),
      AccountSettingsModel(
        icon: Icons.restore_outlined,
        title: AppTexts.restorePurchases,
      ),
      AccountSettingsModel(
        icon: Icons.open_in_new_outlined,
        title: AppTexts.startAppWith,
      ),
      AccountSettingsModel(
        icon: Icons.photo_outlined,
        title: AppTexts.pictureQuality,
      ),
      AccountSettingsModel(
        icon: Icons.help_outline,
        title: AppTexts.faq,
        onTap: openFaq,
      ),
      AccountSettingsModel(
        icon: Icons.rate_review_outlined,
        title: AppTexts.rateApp,
        onTap: rateApp,
      ),
      AccountSettingsModel(
        icon: Icons.share_outlined,
        title: AppTexts.shareApp,
        onTap: shareApp,
      ),
      AccountSettingsModel(
        icon: Icons.contact_support_outlined,
        title: AppTexts.contactUs,
        onTap: openContactUs,
      ),
      AccountSettingsModel(
        icon: Icons.privacy_tip_outlined,
        title: AppTexts.privacyPolicy,
        onTap: openPrivacyPolicy,
      ),
      AccountSettingsModel(
        icon: Icons.description_outlined,
        title: AppTexts.termsConditions,
        onTap: openTermsConditions,
      ),
    ];
  }

  @override
  void onClose() {
    super.onClose();
  }
}
