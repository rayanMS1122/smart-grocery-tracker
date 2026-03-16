import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_grocery_tracker/controllers/groceries_controller.dart';
import 'package:smart_grocery_tracker/core/app_colors.dart';
import 'package:smart_grocery_tracker/screens/edit_grocery_screen.dart';
import 'package:smart_grocery_tracker/controllers/auth_controller.dart';
import 'package:smart_grocery_tracker/widgets/grocery_item_card.dart';

// Dashboard - Übersicht über alles Wichtige
class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToOverview;
  final GroceriesController groceriesController = Get.put(
    GroceriesController(),
  );

  HomeScreen({super.key, required this.onNavigateToOverview});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<GroceriesController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Obere Leiste mit Titel und Logout
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => AuthController.instance.logout(),
                      child: Icon(
                        Icons.login_outlined,
                        color: Colors.redAccent,
                        size: 28.r,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Obx(
                  () => SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats-Sektion
                        Text(
                          'Statistiken',
                          style: TextStyle(
                            color: AppColors.greyLight,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            _buildStatCard(
                              'Gesamt',
                              controller.totalItems.toString(),
                              AppColors.white,
                            ),
                            SizedBox(width: 12.w),
                            _buildStatCard(
                              'Kritisch', // Beinhaltet abgelaufene UND bald ablaufende Sachen
                              controller.expiredCount.toString(),
                              AppColors.statusExpired,
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            _buildStatCard(
                              'Sehr gut',
                              controller.excellentCount.toString(),
                              AppColors.statusExcellent,
                            ),
                            SizedBox(width: 12.w),
                            _buildStatCard(
                              'Gut',
                              controller.goodCount.toString(),
                              AppColors.statusGood,
                            ),
                          ],
                        ),

                        SizedBox(height: 32.h),

                        // Die neuesten Einträge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kürzlich hinzugefügt',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: onNavigateToOverview,
                              child: Text(
                                'Alle sehen',
                                style: TextStyle(color: AppColors.primaryLime),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        // Anzeige der letzten 5 Lebensmittel
                        if (controller.isLoading.value)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: const CircularProgressIndicator(
                                color: AppColors.primaryLime,
                              ),
                            ),
                          )
                        else if (controller.groceries.isEmpty)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Text(
                                'Noch nix da...',
                                style: TextStyle(color: AppColors.greyLight),
                              ),
                            ),
                          )
                        else
                          ...controller.groceries.reversed.take(5).map((
                            grocery,
                          ) {
                            final date = grocery.expiryDate;
                            final dateStr =
                                "${date.day}.${date.month}.${date.year}";
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: GroceryItemCard(
                                category: grocery.category,
                                title: grocery.name,
                                statusText: grocery.status,
                                statusColor: grocery.statusColor,
                                borderColor: grocery.borderColor,
                                amount: grocery.amount,
                                date: dateStr,
                                onDelete: () =>
                                    controller.removeGrocery(grocery),
                                onEdit: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditGroceryScreen(
                                        groceryToEdit: grocery,
                                        editIndex: controller.groceries.indexOf(
                                          grocery,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),

                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Widget für die Statistik-Boxen
  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: AppColors.greyLight, fontSize: 12.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
