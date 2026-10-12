import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_app_bar.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: AppTexts.privacyPolicy,
        backgroundColor: AppColors.whiteColor,
        showProBadge: false,
        leading: InkWell(
          onTap: () => Get.back(),
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
            _buildSection(
              title: 'Introduction',
              content: 'We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you about how we handle your personal data when you use our PDF Scanner application.',
            ),
            _buildSection(
              title: 'Information We Collect',
              content: 'We collect minimal information necessary to provide our services. This may include:\n\n• Device information (model, OS version)\n• App usage statistics\n• Crash reports for bug fixing\n• Camera access for scanning documents\n• Storage access for saving scanned files',
            ),
            _buildSection(
              title: 'How We Use Your Information',
              content: 'We use the collected information to:\n\n• Provide and maintain our services\n• Improve user experience\n• Fix bugs and technical issues\n• Analyze app performance\n• Respond to user support requests',
            ),
            _buildSection(
              title: 'Data Storage',
              content: 'All your scanned documents and data are stored locally on your device. We do not store your documents on our servers. You have full control over your data and can delete it at any time.',
            ),
            _buildSection(
              title: 'Third-Party Services',
              content: 'We may use third-party services for analytics and crash reporting. These services have their own privacy policies and we encourage you to read them.',
            ),
            _buildSection(
              title: 'Security',
              content: 'We take appropriate security measures to protect your data. You can enable app PIN protection for additional security of your documents.',
            ),
            _buildSection(
              title: 'Your Rights',
              content: 'You have the right to:\n\n• Access your personal data\n• Delete your data\n• Opt-out of analytics\n• Request information about data usage',
            ),
            _buildSection(
              title: 'Children\'s Privacy',
              content: 'Our app is not intended for children under 13 years of age. We do not knowingly collect personal information from children.',
            ),
            _buildSection(
              title: 'Changes to This Policy',
              content: 'We may update this privacy policy from time to time. We will notify you of any changes by updating the policy within the app.',
            ),
            _buildSection(
              title: 'Contact Us',
              content: 'If you have any questions about this privacy policy, please contact us at:\n\nEmail: vaghasiyasanket36@gmail.com\nPhone: +91 97260 30303',
            ),
            Spacing.height(AppDimensions.spacingMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacing.height(AppDimensions.spacingMedium),
        CommonText(
          text: title,
          fontSize: AppFontSizes.fontSmall,
          fontWeight: AppFontWeights.semiBold,
          color: AppColors.blackColor,
        ),
        Spacing.height(AppDimensions.spacingSmall),
        CommonText(
          text: content,
          fontSize: AppFontSizes.fontSmall,
          fontWeight: AppFontWeights.normal,
          color: AppColors.grey,
          textAlign: TextAlign.justify,
        ),
        Spacing.height(AppDimensions.spacingMedium),
        Divider(
          color: AppColors.grey.withOpacity(0.2),
          thickness: 1,
        ),
      ],
    );
  }
}
