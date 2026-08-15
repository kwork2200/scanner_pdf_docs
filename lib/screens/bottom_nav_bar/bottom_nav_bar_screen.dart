import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/screens/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:scanner_pdf_docs/screens/files/files_screen.dart';
import 'package:scanner_pdf_docs/screens/home/home_screen.dart';
import 'package:scanner_pdf_docs/utils/app_font_weights.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:scanner_pdf_docs/utils/app_dimensions.dart';
import 'package:scanner_pdf_docs/widgets/sheets/scan_bottom_sheet.dart';

class BottomNavBrScreen extends GetView<BottomNavBarController> {
   BottomNavBrScreen({super.key});

  final List<Widget> _tabs = [
    HomeTab(),
    const FilesTab(),
  ];

  void showScanBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ScanBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _tabs[controller.currentIndex.value]),
      bottomNavigationBar:Obx(() {
        return  BottomNavigationBar(
          selectedLabelStyle: TextStyle(fontWeight: AppFontWeights.bold),
          unselectedLabelStyle: TextStyle(fontWeight: AppFontWeights.bold),
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.changeTab(index);
          },
          selectedItemColor: AppColors.infoBlue,
          unselectedItemColor: AppColors.grey400,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: AppTexts.navHome),
            BottomNavigationBarItem(icon: Icon(Icons.folder), label: AppTexts.files),
          ],
        );
      },),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showScanBottomSheet(context),
        backgroundColor: AppColors.infoBlue,
        child: Icon(Icons.add, size: AppDimensions.iconLarge, color: AppColors.whiteColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
