import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/app_pin/pin_verification/pin_verification_controller.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/utils/app_font_sizes.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/spacing_widget.dart';
import 'package:scanner_pdf_docs/widgets/common/common_text.dart';

class PinVerificationScreen extends GetView<PinVerificationController> {
  const PinVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Obx(() => Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText(
                  text: AppTexts.enterPin,
                  fontSize: AppFontSizes.fontLarge,
                  fontWeight: AppFontWeights.semiBold,
                  color: AppColors.blackColor,
                ),
                Spacing.height(40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final isFilled = index < controller.currentPin.value.length;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.w),
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFilled ? AppColors.infoBlue : Colors.transparent,
                        border: Border.all(
                          color: isFilled ? AppColors.infoBlue : AppColors.grey,
                          width: 2,
                        ),
                      ),
                    );
                  }),
                ),
                if (controller.showError.value) ...[
                  Spacing.height(20.h),
                  CommonText(
                    text: AppTexts.incorrectPin,
                    fontSize: AppFontSizes.font14,
                    fontWeight: AppFontWeights.medium,
                    color: AppColors.errorColor,
                  ),
                ],
                Spacing.height(20.h),
                CommonText(
                  text: '${controller.remainingAttempts.value} attempts remaining',
                  fontSize: AppFontSizes.fontSmall,
                  fontWeight: AppFontWeights.normal,
                  color: AppColors.grey,
                ),
              ],
            ),
          ),
          // Number Pad
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
              top: 20.h,
            ),
            child: Column(
              children: [
                ...List.generate(3, (row) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(3, (col) {
                        final number = row * 3 + col + 1;
                        return _buildNumberButton(number.toString());
                      }),
                    ),
                  );
                }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: 80.w),
                      _buildNumberButton('0'),
                      _buildBackspaceButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => controller.addDigit(number),
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.grey100,
        ),
        child: Center(
          child: CommonText(
            text: number,
            fontSize: AppFontSizes.fontXLarge26,
            fontWeight: AppFontWeights.medium,
            color: AppColors.blackColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: controller.removeDigit,
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.grey100,
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            size: AppDimensions.iconMedium,
            color: AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}
