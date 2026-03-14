import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddGroceryController extends GetxController {
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

  void setCategory(String category) {
    selectedCategory.value = category;
    update();
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
