import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextFieldsControllerProvider extends ChangeNotifier {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController dateNaissanceController =TextEditingController();
  final TextEditingController emailMedecinController =TextEditingController();
  final TextEditingController numeroController = TextEditingController();

  // Method to update controllers with Firebase data
Future<void> updateControllersWithFirebaseData() async {
  // ignore: no_leading_underscores_for_local_identifiers
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DocumentSnapshot documentSnapshot = await _firestore
          .collection('users')
          .doc(user.uid) // Use the user's UID as the document ID
          .get();
      final data = documentSnapshot.data() as Map<String, dynamic>;
      nomController.text = data['nom'] ?? '';
      dateNaissanceController.text = data['date de naissance'] ?? '';
      emailMedecinController.text = data['email médecin'] ?? '';
      numeroController.text = data['numero']?.toString() ?? '';
      notifyListeners();
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error fetching data: $e');
  }
}


  void updateControllers({
    String? nom,
    String? dateNaissance,
    String? emailMedecin,
    String? numero,
  }) {
    nomController.text = nom ?? '';
    dateNaissanceController.text = dateNaissance ?? '';
    emailMedecinController.text = emailMedecin ?? '';
    numeroController.text = numero ?? '';
    notifyListeners();
  }
}
