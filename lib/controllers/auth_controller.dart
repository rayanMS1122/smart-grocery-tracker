import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_grocery_tracker/screens/main_screen.dart';
import 'package:smart_grocery_tracker/screens/sign_in_screen.dart';

// Auth-Logik für Firebase
class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  // Controller für die Login-Eingaben
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    // Stream für automatische Weiterleitung bei Login/Logout
    _user.bindStream(auth.authStateChanges());
    ever(_user, _initialScreen);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Navigation je nach Auth-Status
  void _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => MainScreen());
    }
  }

  // E-Mail/Passwort Login
  void login() async {
    try {
      isLoading.value = true;
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar('Fehler', 'Daten fehlen');
        return;
      }
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      Get.snackbar('Fehler', 'Check mal deine Logindaten');
    } finally {
      isLoading.value = false;
    }
  }

  // Account erstellen + Firestore Profil anlegen
  void register() async {
    try {
      isLoading.value = true;
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar('Fehler', 'Alle Felder ausfüllen');
        return;
      }
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'email': emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'uid': credential.user!.uid,
        });
      }
    } catch (e) {
      Get.snackbar('Fehler', 'Registrierung hat nicht geklappt');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async => await auth.signOut();
}
