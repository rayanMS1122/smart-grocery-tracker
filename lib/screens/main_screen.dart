import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_grocery_tracker/controllers/navigation_controller.dart';
import 'package:smart_grocery_tracker/core/app_colors.dart';
import 'package:smart_grocery_tracker/screens/add_grocery_screen.dart';
import 'package:smart_grocery_tracker/screens/home_screen.dart';
import 'package:smart_grocery_tracker/screens/overview_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final NavigationController navContainer = Get.put(NavigationController());

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
                    AppColors.white.withValues(alpha: 0.09),
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
                    AppColors.white.withValues(alpha: 0.03),
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
                    AppColors.white.withValues(alpha: 0.02),
                    AppColors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.1, 0.8],
                ),
              ),
            ),
          ),

          Obx(
            () => IndexedStack(
              index: navContainer.selectedIndex,
              children: [
                HomeScreen(
                  onNavigateToOverview: () => navContainer.changeIndex(1),
                ),
                OverviewScreen(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddGroceryScreen()),
          );
        },
        backgroundColor: AppColors.primaryLime,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: AppColors.black, size: 30.r),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: AppColors.scaffoldBackground,
          selectedItemColor: AppColors.primaryLime,
          unselectedItemColor: AppColors.white.withValues(alpha: 0.5),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: navContainer.selectedIndex,
          onTap: navContainer.changeIndex,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Icon(Icons.home, size: 32.r),
              ),
              label: 'Start',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Icon(Icons.calendar_today_outlined, size: 28.r),
              ),
              label: 'Übersicht',
            ),
          ],
        ),
      ),
    );
  }
}
