import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/account/account_controller.dart';
import 'package:scanner_pdf_docs/screens/account/widgets/premium_card_widget.dart';
import 'package:scanner_pdf_docs/screens/account/widgets/settings_item_widget.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_app_bar.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class AccountScreen extends GetView<AccountController> {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ...List.generate(controller.settingsItems.length, (index) {
            final item = controller.settingsItems[index];
            return Column(
              children: [
                SettingsItemWidget(
                  icon: item.icon,
                  title: item.title,
                  subtitle: item.subtitle,
                  onTap: item.onTap,
                ),
                if (index < controller.settingsItems.length - 1)
                  Spacing.height(AppDimensions.spacingSmall),
              ],
            );
          }),
          Spacing.height(AppDimensions.spacingXLarge),
          Center(
            child: CommonText(
              text: AppTexts.appVersion,
              fontSize: AppFontSizes.fontSmall,
              fontWeight: AppFontWeights.normal,
              color: AppColors.grey,
            ),
          ),
          Spacing.height(AppDimensions.spacingXLarge),
        ],
      ),
    );
  }
}
