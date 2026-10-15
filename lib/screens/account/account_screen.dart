import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/account/account_controller.dart';
import 'package:scanner_pdf_docs/screens/account/widgets/premium_card_widget.dart';
import 'package:scanner_pdf_docs/screens/account/widgets/settings_item_widget.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_app_bar.dart';
import 'package:scanner_pdf_docs/widgets/common/ad_on_back_wrapper.dart';
import 'package:scanner_pdf_docs/widgets/components/ads/hybrid_native_ad_widget.dart';

class AccountScreen extends GetView<AccountController> {
  const AccountScreen({super.key});

  /// Build settings items with native ads inserted after every 2 items
  List<Widget> _buildSettingsWithAds() {
    final List<Widget> widgets = [];
    int adCounter = 1;

    for (int index = 0; index < controller.settingsItems.length; index++) {
      final item = controller.settingsItems[index];

      // Add settings item
      widgets.add(
        SettingsItemWidget(
          icon: item.icon,
          title: item.title,
          subtitle: item.subtitle,
          onTap: item.onTap,
        ),
      );

      // Add spacing after each item
      if (index < controller.settingsItems.length - 1) {
        widgets.add(Spacing.height(AppDimensions.spacingSmall));
      }

      // Add native ad after every 2 items (but not after the last item)
      if ((index + 1) % 2 == 0 && index < controller.settingsItems.length - 1) {
        // widgets.add(Spacing.height(AppDimensions.spacingMedium));
        widgets.add(
          HybridNativeAdWidget(
            height: 50,
            smallHeight: 50,
            adKey: '',
          ),
        );
        adCounter++;
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return AdOnBackWrapper(
      child: Scaffold(
        backgroundColor: AppColors.infoBlue.withValues(alpha: 0.01),
        appBar: CommonAppBar(
          title: AppTexts.settings,
          backgroundColor: AppColors.whiteColor,
        ),
        body: ListView(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          children: [
            const PremiumCardWidget(),
            Spacing.height(AppDimensions.spacingXLarge),
            ..._buildSettingsWithAds(),
            Spacing.height(AppDimensions.spacingXLarge),
            // Center(
            //   child: CommonText(
            //     text: AppTexts.appVersion,
            //     fontSize: AppFontSizes.fontSmall,
            //     fontWeight: AppFontWeights.normal,
            //     color: AppColors.grey,
            //   ),
            // ),
            Spacing.height(AppDimensions.spacingXLarge),
          ],
        ),
      ),
    );
  }
}
