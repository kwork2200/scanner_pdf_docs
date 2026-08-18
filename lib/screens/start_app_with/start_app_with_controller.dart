import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scanner_pdf_docs/utils/app_constants.dart';
import 'package:scanner_pdf_docs/utils/app_texts.dart';

enum StartOption { scanner, documents}

class StartAppWithController extends GetxController {
  final selectedOption = StartOption.documents.obs;
  
  static const String _startOptionKey = 'start_app_with_option';

  @override
  void onInit() {
    super.onInit();
    loadStartOption();
  }

  Future<void> loadStartOption() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOption = prefs.getString(_startOptionKey) ?? 'documents';
    
    if (savedOption == 'scanner') {
      selectedOption.value = StartOption.scanner;
    } else {
      selectedOption.value = StartOption.documents;
    }
  }

  Future<void> selectOption(StartOption option) async {
    selectedOption.value = option;
    
    final prefs = await SharedPreferences.getInstance();
    String optionString = option == StartOption.scanner ? 'scanner' : 'documents';
    
    await prefs.setString(_startOptionKey, optionString);
    
    String message = option == StartOption.scanner 
        ? 'App will start with Scanner (Camera)' 
        : 'App will start with Documents';
    
    // AppConstants.showCommonSnackBar(message: message, isSuccess: true);
  }

  static Future<String> getSavedStartOption() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_startOptionKey) ?? 'documents';
  }
}
