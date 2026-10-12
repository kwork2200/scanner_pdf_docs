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

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: AppTexts.faq,
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
            _buildFaqItem(
              question: 'What is PDF Scanner?',
              answer: 'PDF Scanner is a powerful mobile application that allows you to scan documents, convert them to PDF, and manage your digital documents efficiently.',
            ),
            _buildFaqItem(
              question: 'How do I scan a document?',
              answer: 'Open the app, tap the camera icon, position your document within the frame, and tap the capture button. The app will automatically detect edges and enhance the image.',
            ),
            _buildFaqItem(
              question: 'Can I edit scanned documents?',
              answer: 'Yes! After scanning, you can crop, rotate, adjust filters, add signatures, and apply various editing options to your documents.',
            ),
            _buildFaqItem(
              question: 'How do I convert images to PDF?',
              answer: 'Select the images you want to convert, tap the PDF icon, arrange them in the desired order, and save as a PDF document.',
            ),
            _buildFaqItem(
              question: 'Where are my scanned documents saved?',
              answer: 'All scanned documents are saved in the app\'s gallery. You can organize them into folders and access them anytime from the home screen.',
            ),
            _buildFaqItem(
              question: 'Can I share my scanned PDFs?',
              answer: 'Yes, you can share your PDFs via email, messaging apps, cloud storage, or any other sharing method available on your device.',
            ),
            _buildFaqItem(
              question: 'What is OCR (Text Recognition)?',
              answer: 'OCR (Optical Character Recognition) allows you to extract text from scanned images and PDFs, making them searchable and editable.',
            ),
            _buildFaqItem(
              question: 'How do I unlock premium features?',
              answer: 'Tap on the "Get Pro" option in settings to view all premium features and subscribe. Premium includes unlimited scans, no watermarks, OCR, and more.',
            ),
            _buildFaqItem(
              question: 'Is my data secure?',
              answer: 'Yes, all your documents are stored locally on your device. You can also set up app PIN protection for additional security.',
            ),
            _buildFaqItem(
              question: 'How do I contact support?',
              answer: 'You can reach us through the Support option in settings or email us at vaghasiyasanket36@gmail.com.',
            ),
            Spacing.height(AppDimensions.spacingMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacing.height(AppDimensions.spacingMedium),
        CommonText(
          text: question,
          fontSize: AppFontSizes.fontSmall,
          fontWeight: AppFontWeights.semiBold,
          color: AppColors.blackColor,
        ),
        Spacing.height(AppDimensions.spacingSmall),
        CommonText(
          text: answer,
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
