import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_app_bar.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';
import 'package:scanner_pdf_docs/widgets/common/ad_on_back_wrapper.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdOnBackWrapper(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CommonAppBar(
          title: AppTexts.contactUs,
          backgroundColor: AppColors.whiteColor,
          showProBadge: false,
          leading: InkWell(
            onTap: () => handleBackWithAd(context),
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColors.infoBlue,
              size: 20.sp,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.height(AppDimensions.spacingMedium),
              Center(
                child: Icon(
                  Icons.contact_support_outlined,
                  size: 80.sp,
                  color: AppColors.infoBlue,
                ),
              ),
              Spacing.height(AppDimensions.spacingLarge),
              Center(
                child: CommonText(
                  text: 'Get in Touch',
                  fontSize: AppFontSizes.fontXLarge,
                  fontWeight: AppFontWeights.bold,
                  color: AppColors.blackColor,
                ),
              ),
              Spacing.height(AppDimensions.spacingSmall),
              Center(
                child: CommonText(
                  text: 'We\'d love to hear from you!\nFeel free to reach out for any questions or support.',
                  fontSize: AppFontSizes.fontSmall,
                  fontWeight: AppFontWeights.normal,
                  color: AppColors.grey,
                  textAlign: TextAlign.center,
                ),
              ),
              Spacing.height(AppDimensions.spacingXLarge),
              _buildContactCard(
                icon: Icons.email_outlined,
                title: 'Email',
                value: 'vaghasiyasanket36@gmail.com',
                onTap: () => _launchEmail(),
                onLongPress: () => _copyToClipboard(
                  'vaghasiyasanket36@gmail.com',
                  'Email copied to clipboard',
                ),
              ),
              Spacing.height(AppDimensions.spacingMedium),
              _buildContactCard(
                icon: Icons.phone_outlined,
                title: 'Phone',
                value: '+91 97260 30303',
                onTap: () => _launchPhone(),
                onLongPress: () => _copyToClipboard(
                  '+91 97260 30303',
                  'Phone number copied to clipboard',
                ),
              ),
              Spacing.height(AppDimensions.spacingXLarge),
              Container(
                padding: EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.infoBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.infoBlue,
                          size: 20.sp,
                        ),
                        Spacing.width(AppDimensions.spacingSmall),
                        CommonText(
                          text: 'Support Hours',
                          fontSize: AppFontSizes.fontSmall,
                          fontWeight: AppFontWeights.semiBold,
                          color: AppColors.blackColor,
                        ),
                      ],
                    ),
                    Spacing.height(AppDimensions.spacingSmall),
                    CommonText(
                      text: 'Monday - Friday: 9:00 AM - 6:00 PM (IST)\nSaturday: 10:00 AM - 4:00 PM (IST)\nSunday: Closed',
                      fontSize: AppFontSizes.fontSmall,
                      fontWeight: AppFontWeights.normal,
                      color: AppColors.grey,
                    ),
                  ],
                ),
              ),
              Spacing.height(AppDimensions.spacingMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    required VoidCallback onLongPress,
  }) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.grey.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.infoBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: AppColors.infoBlue,
                size: 24.sp,
              ),
            ),
            Spacing.width(AppDimensions.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: title,
                    fontSize: AppFontSizes.fontSmall,
                    fontWeight: AppFontWeights.normal,
                    color: AppColors.grey,
                  ),
                  Spacing.height(4.h),
                  CommonText(
                    text: value,
                    fontSize: AppFontSizes.fontSmall,
                    fontWeight: AppFontWeights.semiBold,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.grey,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'vaghasiyasanket36@gmail.com',
      query: 'subject=Support Request&body=',
    );
    
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open email app',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorColor,
          colorText: AppColors.whiteColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open email app',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorColor,
        colorText: AppColors.whiteColor,
      );
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+919726030303',
    );
    
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open phone app',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorColor,
          colorText: AppColors.whiteColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open phone app',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorColor,
        colorText: AppColors.whiteColor,
      );
    }
  }

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.successGreen,
      colorText: AppColors.whiteColor,
      duration: const Duration(seconds: 2),
    );
  }
}
