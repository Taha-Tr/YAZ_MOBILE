// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verifyPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _verifyPasswordController.dispose();
    super.dispose();
  }

  void signup() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _verifyPasswordController.text.isEmpty) {
      // Display error popup for empty fields
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Rounded corners
            ),
            backgroundColor: Colors.red, // Red background color
            title: const Text(
              "Erreur",
              style: TextStyle(color: Colors.white), // White text color
            ),
            content: const Text(
              "Veuillez remplir tous les champs.",
              style: TextStyle(color: Colors.white), // White text color
            ),
            actions: [
              TextButton(
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white), // White text color
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (_passwordController.text != _verifyPasswordController.text) {
      // Display error popup for password mismatch
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Rounded corners
            ),
            backgroundColor: Colors.red, // Red background color
            title: const Text(
              "Erreur",
              style: TextStyle(color: Colors.white), // White text color
            ),
            content: const Text(
              "Les mots de passe ne correspondent pas.",
              style: TextStyle(color: Colors.white), // White text color
            ),
            actions: [
              TextButton(
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white), // White text color
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      // Show loading circle
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 56, 85, 109),
              strokeWidth: 7,
              backgroundColor: Color.fromARGB(255, 204, 222, 255),
            ),
          );
        },
      );

      // Register with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Create additional fields in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'nom': '',
        'date de naissance' : '',
        'numero' : '',
        'email médecin': '',
        'TGR': '',
        'ILMA': '',
        'IRMA': '',
        'TGMA': '',
        'GMA': '',
        'IRMI': '',
        'TGMI': '',
        'GMI': '',
        'IRD': '',
        'TGD': '',
        'GD': '',
        'ILS': '',
        'TGS': '',
        'TGN': '',
        'commentaire': '',
      });

      // Hide loading circle
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      // Display success popup
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Rounded corners
            ),
            backgroundColor: Colors.green, // Green background color
            title: const Text(
              "Succès",
              style: TextStyle(color: Colors.white), // White text color
            ),
            content: const Text(
              "Votre compte a été créé avec succès!",
              style: TextStyle(color: Colors.white), // White text color
            ),
            actions: [
              TextButton(
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white), // White text color
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushReplacementNamed('loginscreen');
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle registration failure
      // Hide loading circle
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      // Display error popup
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Rounded corners
            ),
            backgroundColor: Colors.red, // Red background color
            title: const Text(
              "Erreur",
              style: TextStyle(color: Colors.white), // White text color
            ),
            content: const Text(
              "Une erreur est survenue",
              style: TextStyle(color: Colors.white), // White text color
            ),
            actions: [
              TextButton(
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white), // White text color
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //image
                Image.asset(
                  'images/register.png',
                  height: 150,
                ),
                const SizedBox(height: 20),
                //title
                Text(
                  'S’inscrire',
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
                //subtitle
                Text(
                  'Créer un compte',
                  style: GoogleFonts.robotoCondensed(fontSize: 18),
                ),
                const SizedBox(height: 50),

                //emailTextfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                //passwordTextfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Mot de passe",
                          border: InputBorder.none,
                          hintText: 'Mot de passe',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                //verify passwordTextfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _verifyPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Vérifier le mot de passe",
                          border: InputBorder.none,
                          hintText: 'Vérifier le mot de passe',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                //sign up button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: signup,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 7, 100, 143),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'S\'inscrire',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                //text: sign in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous avez déjà un compte?',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('loginscreen');
                      },
                      child: Text(
                        ' se connecter',
                        style: GoogleFonts.roboto(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
