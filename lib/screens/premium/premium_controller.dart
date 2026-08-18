import 'package:get/get.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';

class PremiumController extends GetxController {
  final selectedPlan = 'yearly'.obs;

  void selectPlan(String plan) {
    selectedPlan.value = plan;
  }

  Future<void> startTrial() async {
    AppConstants.showCommonSnackBar(message: 'Starting trial for ${selectedPlan.value} plan...',isSuccess: true,);
  }

  Future<void> restorePurchases() async {
    AppConstants.showCommonSnackBar(message: 'Restoring purchases...');
  }

  Future<void> openPrivacyPolicy() async {
    Get.toNamed(AppRoutes.privacyPolicy);
  }

  Future<void> openTermsConditions() async {
    Get.toNamed(AppRoutes.termsConditions);
  }

  void cancelAnytime() {
    AppConstants.showCommonSnackBar(
      message: 'You can cancel anytime from your account settings',
      isSuccess: true,
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
