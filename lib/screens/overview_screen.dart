import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_grocery_tracker/controllers/groceries_controller.dart';
import 'package:smart_grocery_tracker/core/app_colors.dart';
import 'package:smart_grocery_tracker/screens/edit_grocery_screen.dart';
import 'package:smart_grocery_tracker/controllers/auth_controller.dart';
import 'package:smart_grocery_tracker/widgets/grocery_item_card.dart';

class OverviewScreen extends StatelessWidget {
  final GroceriesController groceriesController = Get.find();

  OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Text(
                  'Ãœbersicht',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        AuthController.instance.logout();
                      },
                      child: Icon(
                        Icons.logout_outlined,
                        color: Colors.redAccent,
                        size: 28.r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.1),
                  width: 1.w,
                ),
              ),
              child: TextField(
                onChanged: (value) => groceriesController.setSearchQuery(value),
                style: TextStyle(color: AppColors.white, fontSize: 14.sp),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.primaryLime,
                    size: 20.r,
                  ),
                  hintText: 'Nach Lebensmittel suchen...',
                  hintStyle: TextStyle(color: AppColors.greyMedium),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 16.w,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Obx(() {
              final categories = [
                'Alle',
                'Obst & GemÃ¼se',
                'Milchprodukte',
                'Fleisch & Fisch',
                'Snacks',
                'GetrÃ¤nke',
                'TiefkÃ¼hl',
                'Vorratskammer',
                'Sonstiges',
              ];

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: categories.map((category) {
                    return Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: _buildFilterButton(
                        category,
                        AppColors.primaryLime,
                        groceriesController.selectedFilter.value == category,
                        () => groceriesController.setFilter(category),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(() {
                if (groceriesController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryLime,
                    ),
                  );
                }

                final filteredItems = groceriesController.filteredGroceries;

                if (filteredItems.isEmpty) {
                  return Center(
                    child: Text(
                      'Keine Artikel gefunden',
                      style: TextStyle(
                        color: AppColors.greyLight,
                        fontSize: 16.sp,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(top: 10.h, bottom: 80.h),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final grocery = filteredItems[index];
                    final date = grocery.expiryDate;
                    final dateStr = "${date.day}.${date.month}.${date.year}";
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: GroceryItemCard(
                        category: grocery.category,
                        title: grocery.name,
                        statusText: grocery.status,
                        statusColor: grocery.statusColor,
                        borderColor: grocery.borderColor,
                        amount: grocery.amount,
                        date: dateStr,
                        onDelete: () =>
                            groceriesController.removeGrocery(grocery),
                        onEdit: () {
                          final originalIndex = groceriesController.groceries
                              .indexOf(grocery);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditGroceryScreen(
                                groceryToEdit: grocery,
                                editIndex: originalIndex,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    String label,
    Color color,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isActive ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isActive ? color : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isActive
                  ? Colors.white.withValues(alpha: 0.5)
                  : color.withValues(alpha: 0.3),
              width: 1.5.w,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive
                  ? AppColors.black
                  : AppColors.white.withValues(alpha: 0.7),
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}
