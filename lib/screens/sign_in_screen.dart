import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_grocery_tracker/controllers/auth_controller.dart';
import 'package:smart_grocery_tracker/core/app_colors.dart';
import 'package:get/get.dart';
import 'package:smart_grocery_tracker/screens/sign_up_screen.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final RxBool _obscurePassword = true.obs;
  final AuthController _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          Positioned(
            top: -120.h,
            left: -150.w,
            child: Container(
              width: 450.w,
              height: 450.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.white.withValues(alpha: 0.07),
                    AppColors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.8],
                ),
              ),
            ),
          ),

          Positioned(
            top: -80.h,
            right: -110.w,
            child: Container(
              width: 410.w,
              height: 410.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.white.withValues(alpha: 0.05),
                    AppColors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.8],
                ),
              ),
            ),
          ),

          Positioned(
            top: 310.h,
            left: -110.w,
            right: -110.w,
            child: Container(
              height: 600.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.white.withValues(alpha: 0.05),
                    AppColors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.1, 0.8],
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 60.h),

                            Image.asset(
                              'assets/logo.png',
                              height: 180.h,
                              width: 180.w,
                            ),
                            SizedBox(height: 30.h),
                            Text(
                              'Welcome',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Wellkommen in mein app. bitte loge\ndich ein',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.grey,
                              ),
                            ),
                            SizedBox(height: 40.h),
                            Text(
                              'Email-address*',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextField(
                              controller: _authController.emailController,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.sp,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Example@gmai.com',
                                hintStyle: TextStyle(
                                  color: AppColors.greyMedium,
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 16.h,
                                  horizontal: 16.w,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: AppColors.greyDark,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryLime,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'Password*',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Obx(
                              () => TextField(
                                controller: _authController.passwordController,
                                obscureText: _obscurePassword.value,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14.sp,
                                ),
                                decoration: InputDecoration(
                                  hintText: '*****************',
                                  hintStyle: TextStyle(
                                    color: AppColors.greyMedium,
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.h,
                                    horizontal: 16.w,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: const BorderSide(
                                      color: AppColors.greyDark,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: const BorderSide(
                                      color: AppColors.primaryLime,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.circle,
                                      color: Colors.grey.shade300,
                                      size: 20.r,
                                    ),
                                    onPressed: () {
                                      _obscurePassword.value =
                                          !_obscurePassword.value;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 40.h),
                            ElevatedButton(
                              onPressed: () {
                                _authController.login();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryLime,
                                foregroundColor: AppColors.black,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hast du kein Account? ',
                                  style: TextStyle(
                                    color: AppColors.greyMedium,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignUpPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
