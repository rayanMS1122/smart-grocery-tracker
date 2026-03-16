import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_grocery_tracker/models/grocery_model.dart';

// Logik für das Bearbeiten-Formular
class EditGroceryController extends GetxController {
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  final selectedCategory = 'Obst & Gemüse'.obs;
  final selectedDate = DateTime.now().add(const Duration(days: 7)).obs;

  final List<String> categories = [
    'Obst & Gemüse',
    'Milchprodukte',
    'Fleisch & Fisch',
    'Snacks',
    'Getränke',
    'Tiefkühl',
    'Vorratskammer',
    'Sonstiges',
  ];

  void initData(GroceryModel grocery) {
    nameController.text = grocery.name;
    amountController.text = grocery.amount;

    if (categories.contains(grocery.category)) {
      selectedCategory.value = grocery.category;
    }

    selectedDate.value = grocery.expiryDate;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  @override
  void onClose() {
    nameController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
