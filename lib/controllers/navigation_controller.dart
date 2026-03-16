import 'package:get/get.dart';

// Steuert den Wechsel zwischen Home und Übersicht
class NavigationController extends GetxController {
  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;

  void changeIndex(int index) {
    _selectedIndex.value = index;
  }
}
