import 'package:get/get.dart';

class BottomNavBarController extends GetxController {
  final currentIndex = 0.obs;
  
  void changeTab(int index) {
    currentIndex.value = index;
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
