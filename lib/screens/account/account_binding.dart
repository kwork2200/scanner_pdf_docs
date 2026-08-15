import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/account/account_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountController>(() => AccountController());
  }
}
