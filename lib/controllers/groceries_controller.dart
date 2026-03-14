import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:smart_grocery_tracker/models/grocery_model.dart';

class GroceriesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<GroceryModel> groceries = <GroceryModel>[].obs;
  RxBool isLoading = true.obs;

  RxString selectedFilter = 'Alle'.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    _bindGroceriesStream();
  }

  void _bindGroceriesStream() {
    isLoading.value = true;

    String? uid = _auth.currentUser?.uid;

    if (uid == null) {
      isLoading.value = false;
      groceries.clear();
      return;
    }

    Stream<List<GroceryModel>> stream = _firestore
        .collection('users')
        .doc(uid)
        .collection('groceries')
        .orderBy('expiryDate', descending: false)
        .snapshots()
        .map((snapshot) {
          List docs = snapshot.docs;

          List<GroceryModel> groceryList = [];

          for (var doc in docs) {
            GroceryModel grocery = GroceryModel.fromFirestore(doc);

            groceryList.add(grocery);
          }

          isLoading.value = false;

          return groceryList;
        });

    groceries.bindStream(stream);
  }

  List<GroceryModel> get filteredGroceries {
    List<GroceryModel> results = groceries;

    if (selectedFilter.value != "Alle") {
      results = results
          .where((item) => item.category == selectedFilter.value)
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      results = results
          .where(
            (item) => item.name.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ),
          )
          .toList();
    }

    return results;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  int get totalItems => groceries.length;

  int get expiredCount {
    return groceries.where((item) => item.status == "Abgelaufen").length;
  }

  int get excellentCount {
    return groceries.where((item) => item.status == "Sehr gut").length;
  }

  int get goodCount {
    return groceries.where((item) => item.status == "Gut").length;
  }

  Future<void> addGrocery(GroceryModel grocery) async {
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groceries')
          .add(grocery.toFirestore());
    }
  }

  Future<void> removeGrocery(GroceryModel grocery) async {
    String? uid = _auth.currentUser?.uid;
    if (uid != null && grocery.id != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groceries')
          .doc(grocery.id)
          .delete();
    }
  }

  Future<void> updateGrocery(GroceryModel grocery) async {
    String? uid = _auth.currentUser?.uid;
    if (uid != null && grocery.id != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groceries')
          .doc(grocery.id)
          .update(grocery.toFirestore());
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
