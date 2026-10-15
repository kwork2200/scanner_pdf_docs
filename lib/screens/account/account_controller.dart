import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scanner_pdf_docs/screens/app_pin/app_pin/app_pin_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scanner_pdf_docs/screens/account/models/account_settings_model.dart';
import 'package:scanner_pdf_docs/screens/account/models/premium_feature_model.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/utils/functions.dart';
import 'package:scanner_pdf_docs/widgets/components/ads/interstitial_ad_manager.dart';

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

  /// Helper method to ensure ad is loaded and ready before showing
  /// If ad is not ready, it will wait up to 3 seconds for it to load
  Future<void> _showInterstitialAdAndWait(BuildContext context) async {
    try {
      if (InterstitialAdManager.instance.isAdReady) {
        await showManagedInterstitialAd(context);
        return;
      }

      debugPrint('🔄 Ad not ready, loading and waiting...');
      await InterstitialAdManager.instance.loadAd();
      for (int i = 0; i < 6; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (InterstitialAdManager.instance.isAdReady) {
          debugPrint('✅ Ad loaded after ${(i + 1) * 500}ms, showing...');
          await showManagedInterstitialAd(context);
          return;
        }
      }
      
      debugPrint('⚠️ Ad not ready after 3s, proceeding...');
      await showManagedInterstitialAd(context);
    } catch (e) {
      debugPrint('❌ Error in _showInterstitialAdAndWait: $e');
    }
  }

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
    final context = Get.context;
    if (context != null) {
      await _showInterstitialAdAndWait(context);
    }
    await AppConstants.shareApp();
  }

  Future<void> rateApp() async {
    final context = Get.context;
    if (context != null) {
      await _showInterstitialAdAndWait(context);
    }
    await AppConstants.rateApp();
  }

  Future<void> openContactUs() async {
    final context = Get.context;
    if (context != null) {
      await _showInterstitialAdAndWait(context);
    }
    Get.toNamed(AppRoutes.contactUs);
  }

  Future<void> openPrivacyPolicy() async {
    final context = Get.context;
    if (context != null) {
      await _showInterstitialAdAndWait(context);
    }
    Get.toNamed(AppRoutes.privacyPolicy);
  }

  Future<void> openTermsConditions() async {
    final context = Get.context;
    if (context != null) {
      await _showInterstitialAdAndWait(context);
    }
    Get.toNamed(AppRoutes.termsConditions);
  }

  Future<void> openFaq() async {
    final context = Get.context;
    if (context != null) {
      await _showInterstitialAdAndWait(context);
    }
    Get.toNamed(AppRoutes.faq);
  }

  Future<void> openPremium() async {
    final context = Get.context;
    if (context != null) {
      await _showInterstitialAdAndWait(context);
    }
    await AppConstants.showPremiumScreen();
  }

  Future<void> openAppPin() async {
    final context = Get.context;
    if (context != null) {
      await _showInterstitialAdAndWait(context);
    }
    Get.toNamed(AppRoutes.appPin);
  }

  Future<void> openStartAppWith() async {
    final context = Get.context;
    if (context != null) {
      await _showInterstitialAdAndWait(context);
    }
    Get.toNamed(AppRoutes.startAppWith);
  }

  Future<void> openPictureQuality() async {
    final context = Get.context;
    if (context != null) {
      await _showInterstitialAdAndWait(context);
    }
    Get.toNamed(AppRoutes.pictureQuality);
  }

  Future<void> initAppVersion() async {
    appVersion = await AppConstants.getAppVersion();
  }

  Future<void> openSupportEmail() async {
    final context = Get.context;
    if (context != null) {
      await _showInterstitialAdAndWait(context);
    }
    
    final email = 'vaghasiyasanket36@gmail.com';

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

    if (!Get.isRegistered<AppPinController>()) {
      Get.put(AppPinController());
    }

    initAppVersion();
    
    // Preload interstitial ad when AccountScreen opens
    debugPrint('🔄 Preloading interstitial ad for AccountScreen');
    InterstitialAdManager.instance.loadAd();

    settingsItems = [
      AccountSettingsModel(
        icon: Icons.headset_mic_outlined,
        title: AppTexts.support,
        onTap: openSupportEmail,
      ),
      // AccountSettingsModel(
      //   icon: Icons.copy_outlined,
      //   title: AppTexts.copyUserId,
      //   subtitle: userId,
      //   onTap: copyUserId,
      // ),
      AccountSettingsModel(
        icon: Icons.lock_outline,
        title: AppTexts.appPin,
        onTap: openAppPin,
      ),
      AccountSettingsModel(
        icon: Icons.star_outline,
        title: AppTexts.getPro,
        onTap: openPremium,
      ),
      // AccountSettingsModel(
      //   icon: Icons.restore_outlined,
      //   title: AppTexts.restorePurchases,
      // ),
      AccountSettingsModel(
        icon: Icons.open_in_new_outlined,
        title: AppTexts.startAppWith,
        onTap: openStartAppWith,
      ),
      AccountSettingsModel(
        icon: Icons.photo_outlined,
        title: AppTexts.pictureQuality,
        onTap: openPictureQuality,
      ),
      AccountSettingsModel(
        icon: Icons.help_outline,
        title: AppTexts.faq,
        onTap: openFaq,
      ),
      // Rate App - Commented for now
      // AccountSettingsModel(
      //   icon: Icons.rate_review_outlined,
      //   title: AppTexts.rateApp,
      //   onTap: rateApp,
      // ),
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
