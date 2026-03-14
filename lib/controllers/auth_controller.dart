import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_grocery_tracker/screens/main_screen.dart';
import 'package:smart_grocery_tracker/screens/sign_in_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.authStateChanges());
    ever(_user, _initialScreen);
  }

  void _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => MainScreen());
    }
  }

  void login() async {
    try {
      isLoading.value = true;

      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar('Fehler', 'E-Mail und Passwort dÃ¼rfen nicht leer sein');
        return;
      }
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Ein unbekannter Fehler ist aufgetreten.';
      if (e.code == 'user-not-found') {
        errorMessage = 'Es existiert kein Benutzer mit dieser E-Mail.';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = 'Falsches Passwort oder E-Mail.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Die E-Mail-Adresse ist ungÃ¼ltig.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      Get.snackbar('Fehler', errorMessage);
    } catch (e) {
      Get.snackbar('Fehler', 'Etwas ist schief gelaufen');
    } finally {
      isLoading.value = false;
    }
  }

  void register() async {
    try {
      isLoading.value = true;

      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar('Fehler', 'E-Mail und Passwort dÃ¼rfen nicht leer sein');
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
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Ein unbekannter Fehler ist aufgetreten.';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Diese E-Mail wird bereits verwendet.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Das Passwort ist zu schwach (min. 6 Zeichen).';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Die E-Mail-Adresse ist ungÃ¼ltig.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      Get.snackbar('Fehler', errorMessage);
    } catch (e) {
      Get.snackbar('Fehler', 'Etwas ist schief gelaufen');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await auth.signOut();
  }
}
