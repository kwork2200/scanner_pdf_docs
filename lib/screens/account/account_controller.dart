import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/account/models/account_settings_model.dart';
import 'package:scanner_pdf_docs/screens/account/models/premium_feature_model.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';

class AccountController extends GetxController {
  final String userId = '062455f5517817163\n83abadd83162164';

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

  final List<AccountSettingsModel> settingsItems = [
    AccountSettingsModel(
      icon: Icons.headset_mic_outlined,
      title: AppTexts.support,
    ),
    AccountSettingsModel(
      icon: Icons.copy_outlined,
      title: AppTexts.copyUserId,
      subtitle: '062455f5517817163\n83abadd83162164',
    ),
    AccountSettingsModel(
      icon: Icons.lock_outline,
      title: AppTexts.appPin,
    ),
    AccountSettingsModel(
      icon: Icons.star_outline,
      title: AppTexts.getPro,
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
    ),
    AccountSettingsModel(
      icon: Icons.rate_review_outlined,
      title: AppTexts.rateApp,
    ),
    AccountSettingsModel(
      icon: Icons.share_outlined,
      title: AppTexts.shareApp,
    ),
    AccountSettingsModel(
      icon: Icons.contact_support_outlined,
      title: AppTexts.contactUs,
    ),
    AccountSettingsModel(
      icon: Icons.privacy_tip_outlined,
      title: AppTexts.privacyPolicy,
    ),
    AccountSettingsModel(
      icon: Icons.description_outlined,
      title: AppTexts.termsConditions,
    ),
  ];

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

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
