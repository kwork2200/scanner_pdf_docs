import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanner_pdf_docs/routes/app_pages.dart';
import 'package:scanner_pdf_docs/routes/app_routes.dart';
import 'package:scanner_pdf_docs/screens/splash/splash_binding.dart';
import 'package:scanner_pdf_docs/services/app_lifecycle_service.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Google Mobile Ads
  await MobileAds.instance.initialize();
  print('✅ Google Mobile Ads initialized');
  
  // Initialize AppLifecycleService
  Get.put(AppLifecycleService(), permanent: true);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'PDF Viewer',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.infoBlue),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          initialBinding: SplashBinding(),
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
