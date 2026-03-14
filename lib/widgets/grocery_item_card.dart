import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_grocery_tracker/core/app_colors.dart';

class GroceryItemCard extends StatelessWidget {
  final String category;
  final String title;
  final String statusText;
  final Color statusColor;
  final Color borderColor;
  final String amount;
  final String date;
  final Color statusTextColor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const GroceryItemCard({
    super.key,
    required this.category,
    required this.title,
    required this.statusText,
    required this.statusColor,
    required this.borderColor,
    required this.amount,
    required this.date,
    this.statusTextColor = AppColors.black,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: borderColor, width: 1.5.w),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(
              0.15,
            ),
            blurRadius: 15.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          color: AppColors.greyLight,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusText == 'Abgelaufen'
                          ? AppColors.white
                          : statusTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit?.call();
                    } else if (value == 'delete') {
                      onDelete?.call();
                    }
                  },
                  icon: Icon(
                    Icons.more_horiz,
                    color: AppColors.white,
                    size: 24.r,
                  ),
                  color: AppColors.cardBackground,
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: AppColors.primaryLime,
                            size: 20.r,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Bearbeiten',
                            style: TextStyle(color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                            size: 20.r,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Löschen',
                            style: TextStyle(color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: AppColors.white.withOpacity(0.24), height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.format_list_bulleted,
                      color: AppColors.greyLight,
                      size: 20.r,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Anzahl: ',
                      style: TextStyle(
                        color: AppColors.greyLight,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      amount,
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.greyLight,
                      size: 20.r,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Datum: ',
                      style: TextStyle(
                        color: AppColors.greyLight,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
