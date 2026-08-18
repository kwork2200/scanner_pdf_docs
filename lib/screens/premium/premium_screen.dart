import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/premium/premium_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class PremiumScreen extends GetView<PremiumController> {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    children: [
                      _buildTitle(),
                      Spacing.height(AppDimensions.spacingMedium),
                      _buildRatingSection(),
                      Spacing.height(AppDimensions.spacingLarge),
                      _buildFeaturesList(),
                      Spacing.height(AppDimensions.spacingXLarge),
                      _buildSubscriptionOptions(),
                      Spacing.height(AppDimensions.spacingLarge),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.startTrial,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.infoBlue,
                            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonText(
                                text: AppTexts.tryForFree,
                                fontSize: AppFontSizes.font16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteColor,
                              ),
                              Spacing.width(AppDimensions.spacingSmall),
                              Icon(Icons.arrow_forward_ios, color: AppColors.whiteColor, size: 18),
                            ],
                          ),
                        ),
                      ),
                      Spacing.height(AppDimensions.spacingSmall),
                      CommonText(
                        text: AppTexts.subscriptionTerms,
                        fontSize: AppFontSizes.fontNeNoSmall,
                        color: AppColors.textSecondaryColor,
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      Spacing.height(AppDimensions.spacingXLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: controller.openPrivacyPolicy,
                                child: CommonText(
                                  text: AppTexts.privacy,
                                  fontSize: AppFontSizes.fontNeNoSmall,
                                  color: AppColors.textSecondaryColor,
                                ),
                              ),
                              CommonText(
                                text: '  |  ',
                                fontSize: AppFontSizes.fontSmall,
                                color: AppColors.textSecondaryColor,
                              ),
                              GestureDetector(
                                onTap: controller.openTermsConditions,
                                child: CommonText(
                                  text: AppTexts.terms,
                                  fontSize: AppFontSizes.fontSmall,
                                  color: AppColors.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: controller.cancelAnytime,
                            child: CommonText(
                              text: AppTexts.cancelAnytime,
                              fontSize: AppFontSizes.fontSmall,
                              color: AppColors.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.close,
              color: AppColors.grey400,
              size: 28,
            ),
          ),
          GestureDetector(
            onTap: controller.restorePurchases,
            child: CommonText(
              text: AppTexts.restore,
              fontSize: AppFontSizes.font14,
              fontWeight: AppFontWeights.normal,
              color: AppColors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: AppTexts.unlimited,
            style: TextStyle(
              fontSize: AppFontSizes.fontXLarge26,
              fontWeight: FontWeight.bold,
              color: AppColors.infoBlue,
            ),
          ),
          TextSpan(
            text: ' ${AppTexts.access}',
            style: TextStyle(
              fontSize: AppFontSizes.fontXLarge26,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.park_outlined, color: Colors.grey.shade400, size: 40),
                  Spacing.width(100),
                  Icon(Icons.park_outlined, color: Colors.grey.shade400, size: 40),
                ],
              ),
              CommonText(
                text: AppTexts.rating,
                fontSize: AppFontSizes.font42 ,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryColor,
              ),
            ],
          ),
          Spacing.height(AppDimensions.spacingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => Icon(Icons.star, color: Colors.amber, size: 24.sp),),
          ),
          Spacing.height(AppDimensions.spacingSmall),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              color: AppColors.backgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0.r),
              child: CommonText(
                text: AppTexts.trustedByUsers,
                fontSize: AppFontSizes.fontSmall,
                color: AppColors.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {'icon': Icons.all_inclusive, 'text': AppTexts.unlimitedScans},
      {'icon': Icons.text_fields, 'text': AppTexts.textRecognitionOcr},
      {'icon': Icons.draw, 'text': AppTexts.easySignatures},
      {'icon': Icons.picture_as_pdf, 'text': AppTexts.pdfEditing},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: features.map((feature) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
          child: Row(
            children: [
              Icon(
                feature['icon'] as IconData,
                color: AppColors.textPrimaryColor,
                size: 22.sp,
              ),
              Spacing.width(AppDimensions.spacingMedium),
              CommonText(
                text: feature['text'] as String,
                fontSize: AppFontSizes.font14,
                color: AppColors.black87,
                fontWeight: AppFontWeights.normal,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubscriptionOptions() {
    return Obx(() => Column(
      children: [
        _buildSubscriptionOption(
          title: AppTexts.lifetimeAccess,
          isSelected: controller.selectedPlan.value == 'lifetime',
          onTap: () => controller.selectPlan('lifetime'),
        ),
        Spacing.height(AppDimensions.spacingMedium),
        _buildSubscriptionOption(
          title: AppTexts.yearlyAccess,
          isSelected: controller.selectedPlan.value == 'yearly',
          onTap: () => controller.selectPlan('yearly'),
        ),
      ],
    ));
  }

  Widget _buildSubscriptionOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingSmall),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.infoBlue.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.infoBlue : AppColors.borderColor,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.infoBlue : AppColors.textSecondaryColor,
            ),
            Spacing.width(AppDimensions.spacingMedium),
            CommonText(
              text: title,
              fontSize: AppFontSizes.font14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
