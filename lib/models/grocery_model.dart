import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_grocery_tracker/core/app_colors.dart';

// Datenmodell für ein Lebensmittel
class GroceryModel {
  final String? id;
  final String name;
  final String category;
  final String amount;
  final DateTime expiryDate;

  GroceryModel({
    this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.expiryDate,
  });

  // Firestore Map -> Model
  factory GroceryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    DateTime date;
    if (data['expiryDate'] is Timestamp) {
      date = (data['expiryDate'] as Timestamp).toDate();
    } else if (data['expiryDate'] is String) {
      date = DateTime.tryParse(data['expiryDate']) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    return GroceryModel(
      id: doc.id,
      name: data['name'] ?? 'Unbekannt',
      category: data['category'] ?? 'Sonstiges',
      amount: data['amount'] ?? '1',
      expiryDate: date,
    );
  }

  // Model -> Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'amount': amount,
      'expiryDate': Timestamp.fromDate(expiryDate),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Status-Text generieren
  String get status {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = expiryDate.difference(today).inDays;

    if (difference < 0) return "Abgelaufen";
    if (difference < 3) return "Läuft bald ab";
    if (difference < 7) return "Gut";
    return "Sehr gut";
  }

  // Farbe basierend auf Haltbarkeit
  Color get statusColor {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = expiryDate.difference(today).inDays;

    if (difference < 0) return AppColors.statusExpired;
    if (difference < 3) return Colors.orangeAccent;
    if (difference < 7) return AppColors.statusGood;
    return AppColors.statusExcellent;
  }

  // Warnfarbe für den Kartenrand
  Color get borderColor {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = expiryDate.difference(today).inDays;

    if (difference < 3) return statusColor;
    return Colors.transparent;
  }
}
