import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:yaz/param_data_provider.dart';
import 'package:yaz/screens/bluetooth.dart';
import 'package:yaz/screens/dashboard.dart';
import 'package:yaz/screens/rapport.dart';

class Parametres extends StatefulWidget {
  const Parametres({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ParametresState createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _dateNaissanceController =
      TextEditingController();
  final TextEditingController _emailMedecinController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      // récuperer l'id de l'utilisateur connecté
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final DocumentSnapshot documentSnapshot = await _firestore
            .collection('users')
            .doc(user.uid) // Utiliser l'id de l'utilisateur
            .get();
        final data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _nomController.text = data['nom'] ?? '';
          _dateNaissanceController.text = data['date de naissance'] ?? '';
          _emailMedecinController.text = data['email médecin'] ?? '';
          _numeroController.text = data['numero']?.toString() ?? '';
        });
      } else {
        // afficher un erreur si l'utilisateur n'est pas connecté
        const SnackBar(
          content: Text('Utilisateur non connecté'),
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      const SnackBar(
        content: Text('Utilisateur non connecté'),
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> updateData(BuildContext context) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Update the document corresponding to the current user
        await _firestore
            .collection('users')
            .doc(user.uid) // Use the user's UID as the document ID
            .update({
          'nom': _nomController.text,
          'date de naissance': _dateNaissanceController.text,
          'email médecin': _emailMedecinController.text,
          'numero': int.tryParse(_numeroController.text) ?? 0,
        });

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Données mises à jour avec succès',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Display error message if user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Utilisateur non connecté',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Utilisateur non connecté',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Paramètres',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 7, 100, 143),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 7, 100, 143),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.white),
              title: const Text(
                'Dashboard',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bluetooth, color: Colors.white),
              title: const Text(
                'Appareil',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BluetoothScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_accessibility_rounded,
                  color: Colors.white),
              title: const Text(
                'Paramètres',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Parametres()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_rounded, color: Colors.white),
              title: const Text(
                'Rapport',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RapportScreen()),
                );
              },
            ),
            // Add more list tiles as needed
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          "Informations Personnelles",
                          style: TextStyle(
                              color: Color.fromARGB(255, 7, 100, 143),
                              fontSize: 23),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nomController,
                        decoration: InputDecoration(
                          labelText: 'Nom et Prénom',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _dateNaissanceController,
                        decoration: InputDecoration(
                          labelText: 'Date de naissance "jj/mm/aaaa"',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _numeroController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Numéro de téléphone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir un numéro de téléphone';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Veuillez saisir un numéro de téléphone valide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          final textFieldsProvider =
                              Provider.of<TextFieldsControllerProvider>(
                            context,
                            listen: false,
                          );
                          textFieldsProvider.updateControllers(
                            nom: _nomController.text,
                            dateNaissance: _dateNaissanceController.text,
                            emailMedecin: _emailMedecinController.text,
                            numero: _numeroController.text,
                          );
                          updateData(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 7, 100, 143),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'MAJ',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Envoyer courrier à",
                        style: TextStyle(
                            color: Color.fromARGB(255, 7, 100, 143),
                            fontSize: 23),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailMedecinController,
                        decoration: InputDecoration(
                          labelText: 'Email Médecin',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir une adresse e-mail';
                          }
                          if (!value.contains('@')) {
                            return 'Veuillez saisir une adresse e-mail valide';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
