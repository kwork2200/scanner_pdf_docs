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

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: AppTexts.termsConditions,
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
              title: 'Acceptance of Terms',
              content: 'By downloading, installing, or using PDF Scanner application, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the application.',
            ),
            _buildSection(
              title: 'License Grant',
              content: 'We grant you a limited, non-exclusive, non-transferable, revocable license to use the PDF Scanner application for your personal or business use, subject to these terms and conditions.',
            ),
            _buildSection(
              title: 'User Responsibilities',
              content: 'You are responsible for:\n\n• Maintaining the security of your device\n• All activities that occur under your account\n• Ensuring your use complies with applicable laws\n• Not using the app for any illegal purposes\n• Not attempting to reverse engineer the application',
            ),
            _buildSection(
              title: 'Subscription and Payments',
              content: 'Premium features require a subscription. Subscriptions are billed on a recurring basis. You can cancel your subscription at any time. Refunds are subject to our refund policy and applicable platform policies.',
            ),
            _buildSection(
              title: 'Intellectual Property',
              content: 'All content, features, and functionality of the app, including but not limited to text, graphics, logos, icons, images, and software, are the exclusive property of PDF Scanner and are protected by copyright, trademark, and other intellectual property laws.',
            ),
            _buildSection(
              title: 'User Content',
              content: 'You retain all rights to the documents and content you scan, create, or upload using our app. We do not claim ownership of your content. You are solely responsible for the content you process through the app.',
            ),
            _buildSection(
              title: 'Prohibited Uses',
              content: 'You agree not to:\n\n• Use the app for any unlawful purpose\n• Scan or process copyrighted materials without permission\n• Attempt to gain unauthorized access to the app\n• Transmit viruses or malicious code\n• Interfere with or disrupt the app\'s functionality',
            ),
            _buildSection(
              title: 'Disclaimer of Warranties',
              content: 'The app is provided "as is" without warranties of any kind, either express or implied. We do not guarantee that the app will be error-free, uninterrupted, or free of viruses or other harmful components.',
            ),
            _buildSection(
              title: 'Limitation of Liability',
              content: 'To the maximum extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use or inability to use the app.',
            ),
            _buildSection(
              title: 'Updates and Modifications',
              content: 'We reserve the right to modify or discontinue the app or these terms at any time without prior notice. Continued use of the app after changes constitutes acceptance of the modified terms.',
            ),
            _buildSection(
              title: 'Termination',
              content: 'We reserve the right to terminate or suspend your access to the app at any time, without notice, for conduct that we believe violates these terms or is harmful to other users, us, or third parties.',
            ),
            _buildSection(
              title: 'Governing Law',
              content: 'These terms shall be governed by and construed in accordance with the laws of India, without regard to its conflict of law provisions.',
            ),
            _buildSection(
              title: 'Contact Information',
              content: 'For any questions about these Terms and Conditions, please contact us at:\n\nEmail: vaghasiyasanket36@gmail.com\nPhone: +91 97260 30303',
            ),
            Spacing.height(AppDimensions.spacingMedium),
            Center(
              child: CommonText(
                text: 'Last Updated: ${DateTime.now().year}',
                fontSize: AppFontSizes.fontSmall,
                fontWeight: AppFontWeights.normal,
                color: AppColors.grey,
              ),
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
