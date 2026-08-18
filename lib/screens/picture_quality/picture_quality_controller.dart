import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';

enum PictureQuality { low, medium, high, hd}

class PictureQualityController extends GetxController {
  final selectedQuality = PictureQuality.low.obs;

  List<Map<String, dynamic>> get qualityOptions => [
    {'title': AppTexts.low, 'quality': PictureQuality.low},
    {'title': AppTexts.medium, 'quality': PictureQuality.medium},
    {'title': AppTexts.high, 'quality': PictureQuality.high},
    {'title': AppTexts.hd, 'quality': PictureQuality.hd},
  ];
  
  static const String _qualityKey = 'picture_quality';

  @override
  void onInit() {
    super.onInit();
    loadQuality();
  }

  Future<void> loadQuality() async {
    final prefs = await SharedPreferences.getInstance();
    final savedQuality = prefs.getString(_qualityKey) ?? 'low';
    
    switch (savedQuality) {
      case 'low':
        selectedQuality.value = PictureQuality.low;
        break;
      case 'medium':
        selectedQuality.value = PictureQuality.medium;
        break;
      case 'high':
        selectedQuality.value = PictureQuality.high;
        break;
      case 'hd':
        selectedQuality.value = PictureQuality.hd;
        break;
    }
  }

  Future<void> selectQuality(PictureQuality quality) async {
    selectedQuality.value = quality;
    
    final prefs = await SharedPreferences.getInstance();
    String qualityString = '';

    switch (quality) {
      case PictureQuality.low:
        qualityString = 'low';
        break;
      case PictureQuality.medium:
        qualityString = 'medium';
        break;
      case PictureQuality.high:
        qualityString = 'high';
        break;
      case PictureQuality.hd:
        qualityString = 'hd';
        break;
    }
    
    await prefs.setString(_qualityKey, qualityString);
    
    // AppConstants.showCommonSnackBar(
    //   message: '${AppTexts.pictureQuality} updated to $qualityText',
    //   isSuccess: true,
    // );
  }

  static Future<String> getSavedQuality() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_qualityKey) ?? 'low';
  }
}
