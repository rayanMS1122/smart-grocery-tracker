import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_grocery_tracker/core/app_colors.dart';
import 'package:smart_grocery_tracker/controllers/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_grocery_tracker/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Smart Grocery Tracker',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.scaffoldBackground,
            primaryColor: AppColors.primaryLime,
          ),
          initialBinding: BindingsBuilder(() {
            Get.put(AuthController());
          }),
          home: child,
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryLime),
        ),
      ),
    );
  }
}
