import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_grocery_tracker/controllers/edit_grocery_controller.dart';
import 'package:smart_grocery_tracker/controllers/groceries_controller.dart';
import 'package:smart_grocery_tracker/core/app_colors.dart';
import 'package:smart_grocery_tracker/models/grocery_model.dart';

class EditGroceryScreen extends StatefulWidget {
  final GroceryModel groceryToEdit;
  final int editIndex;

  const EditGroceryScreen({
    super.key,
    required this.groceryToEdit,
    required this.editIndex,
  });

  @override
  State<EditGroceryScreen> createState() => _EditGroceryScreenState();
}

class _EditGroceryScreenState extends State<EditGroceryScreen> {
  late EditGroceryController formController;
  final GroceriesController groceriesController = Get.find();

  @override
  void initState() {
    super.initState();
    formController = Get.put(
      EditGroceryController(),
      tag: 'edit_screen_${widget.editIndex}',
    );

    formController.initData(widget.groceryToEdit);
  }

  @override
  void dispose() {
    Get.delete<EditGroceryController>(tag: 'edit_screen_${widget.editIndex}');
    super.dispose();
  }

  Future<void> _updateGrocery(BuildContext context) async {
    if (formController.nameController.text.trim().isEmpty ||
        formController.amountController.text.trim().isEmpty) {
      Get.snackbar('Fehler', 'Bitte fülle alle Felder aus.');
      return;
    }

    try {
      final updatedGrocery = GroceryModel(
        id: widget.groceryToEdit.id,
        name: formController.nameController.text.trim(),
        category: formController.selectedCategory.value,
        amount: formController.amountController.text.trim(),
        expiryDate: formController.selectedDate.value,
      );

      await groceriesController.updateGrocery(updatedGrocery);

      Get.back();
      Get.snackbar('Erfolg', 'Lebensmittel aktualisiert!');
    } catch (e) {
      Get.snackbar('Fehler', 'Konnte nicht aktualisiert werden: $e');
    }
  }

  String _getMonthName(int month) {
    const months = [
      "Januar",
      "Februar",
      "März",
      "April",
      "Mai",
      "Juni",
      "Juli",
      "August",
      "September",
      "Oktober",
      "November",
      "Dezember",
    ];
    return months[month - 1];
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: formController.selectedDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      formController.setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          _buildBackgroundGlows(),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10.h),
                          _buildLabel('Name'),
                          SizedBox(height: 8.h),
                          _buildTextField(
                            controller: formController.nameController,
                            hint: 'z.B. Apfel',
                            borderColor: AppColors.primaryLime,
                          ),
                          SizedBox(height: 20.h),
                          _buildLabel('Kategorie'),
                          SizedBox(height: 8.h),
                          _buildDropdown(),
                          SizedBox(height: 20.h),
                          _buildLabel('Menge'),
                          SizedBox(height: 8.h),
                          _buildTextField(
                            controller: formController.amountController,
                            hint: 'z.B. 5',
                            borderColor: AppColors.primaryLime,
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 20.h),
                          _buildLabel('Ablaufdatum'),
                          SizedBox(height: 8.h),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: _buildDateDisplay(),
                          ),
                          SizedBox(height: 40.h),
                          _buildSaveButton(context),
                          SizedBox(height: 16.h),
                          _buildCancelButton(context),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGlows() {
    return Stack(
      children: [
        Positioned(top: -120.h, left: -150.w, child: _glow(450.w, 0.04)),
        Positioned(top: -80.h, right: -110.w, child: _glow(410.w, 0.03)),
        Positioned(
          top: 310.h,
          left: -110.w,
          right: -110.w,
          child: _glow(600.w, 0.02),
        ),
      ],
    );
  }

  Widget _glow(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.white.withOpacity(opacity),
            AppColors.white.withOpacity(0.0),
          ],
          stops: const [0.0, 0.8],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
              size: 24.r,
            ),
          ),
          Text(
            'Lebensmittel bearbeiten',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        color: AppColors.white.withOpacity(0.7),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Color borderColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.white.withOpacity(0.1), width: 1.w),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: AppColors.white, fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.greyMedium),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 16.w,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.white.withOpacity(0.1), width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<String>(
            value: formController.selectedCategory.value,
            dropdownColor: AppColors.cardBackground,
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primaryLime),
            style: TextStyle(color: AppColors.white, fontSize: 14.sp),
            isExpanded: true,
            items: formController.categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) formController.setCategory(newValue);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.white.withOpacity(0.1), width: 1.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            final date = formController.selectedDate.value;
            return Text(
              '${date.day}. ${_getMonthName(date.month)} ${date.year}',
              style: TextStyle(color: AppColors.white, fontSize: 14.sp),
            );
          }),
          Icon(
            Icons.calendar_today_outlined,
            color: AppColors.primaryLime,
            size: 20.r,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _updateGrocery(context),
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
        'Aktualisieren',
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Get.back(),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.statusExpired,
        foregroundColor: AppColors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        elevation: 0,
      ),
      child: Text(
        'Abbrechen',
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
