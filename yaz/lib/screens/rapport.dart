// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaz/param_data_provider.dart';
import 'package:yaz/screens/bluetooth.dart';
import 'package:yaz/screens/dashboard.dart';
import 'package:yaz/screens/loginsc.dart';
import 'package:intl/intl.dart';
import 'package:yaz/screens/parametres.dart';

final TextEditingController _commentController = TextEditingController();

final TextEditingController _TGR = TextEditingController();

final TextEditingController _ILMA = TextEditingController();
final TextEditingController _IRMA = TextEditingController();
final TextEditingController _TGMA = TextEditingController();
final TextEditingController _GMA = TextEditingController();

final TextEditingController _IRMI = TextEditingController();
final TextEditingController _TGMi = TextEditingController();
final TextEditingController _GMI = TextEditingController();

final TextEditingController _IRD = TextEditingController();
final TextEditingController _TGD = TextEditingController();
final TextEditingController _GD = TextEditingController();

final TextEditingController _ILS = TextEditingController();
final TextEditingController _TGS = TextEditingController();

final TextEditingController _TGN = TextEditingController();

class RapportScreen extends StatefulWidget {
  const RapportScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RapportScreenState createState() => _RapportScreenState();
}

class _RapportScreenState extends State<RapportScreen>
    with SingleTickerProviderStateMixin {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;
  bool _isExpanded4 = false;
  bool _isExpanded5 = false;
  bool _isExpanded6 = false;
  bool _isCommentEnabled = false;
  bool _isCommentChecked = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
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
        setState(() {
          _TGR.text= data['TGR']  ?? '';
          _ILMA.text = data['ILMA'] ?? '';
          _IRMA.text = data['IRMA'] ?? '';
          _TGMA.text = data['TGMA'] ?? '';
          _GMA.text = data['GMA'] ?? '';
          _IRMI.text = data['IRMI'] ?? '';
          _TGMi.text = data['TGMI'] ?? '';
          _GMI.text = data['GMI'] ?? '';
          _IRD.text = data['IRD'] ?? '';
          _TGD.text = data['TGD'] ?? '';
          _GD.text = data['GD'] ?? '';
          _ILS.text = data['ILS'] ?? '';
          _TGS.text = data['TGS'] ?? '';
          _TGN.text = data['TGN'] ?? '';
          _commentController.text = data['commentaire'] ?? '';
        });
      } else {
        // Display error message if user is not logged in
            const SnackBar(
          content: Text(
              'Utilisateur non connecté'),
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching data: $e');
    }
  }

  Future<void> updateData(BuildContext context) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid) // Use the user's UID as the document ID
            .update({
          'TGR': _TGR.text,
          'ILMA': _ILMA.text,
          'IRMA': _IRMA.text,
          'TGMA': _TGMA.text,
          'GMA': _GMA.text,
          'IRMI': _IRMI.text,
          'TGMI': _TGMi.text,
          'GMI': _GMI.text,
          'IRD': _IRD.text,
          'TGD': _TGD.text,
          'GD': _GD.text,
          'ILS': _ILS.text,
          'TGS': _TGS.text,
          'TGN': _TGN.text,
          'commentaire': _commentController.text,
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
          const Center(
            child: SnackBar(
              content: Text(
                'Utilisateur non connecté',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          ) as SnackBar,
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Échec de la mise à jour des données',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  DateTime _selectedDate = DateTime.now(); // Track the selected date

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(
                255, 7, 100, 143), // Change the primary color to blue
            colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(
                    255, 7, 100, 143)), // Change the color scheme to use blue
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 7, 100, 143),
        title: const Text('Rapport', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              // Implement logout functionality
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
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
                'Paramétres',
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
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  _selectDate(context); // Show date picker when tapped
                },
                child: Container(
                  height: 70,
                  width: 350,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 7, 100, 143),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('dd-MM-yyyy').format(_selectedDate),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded1 = !_isExpanded1;
                  });
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  width: 350,
                  height: _isExpanded1 ? 220 : 70,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 107, 157, 182),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Au Réveil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isExpanded1) ...[
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _TGR,
                                  decoration: const InputDecoration(
                                    labelText: 'Taux de glycémie g/L',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 162, 182, 199),
                                ), // Define the background color
                                minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 60),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                updateData(context);
                              },
                              child: const Text(
                                "Valider",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ))
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded2 = !_isExpanded2;
                  });
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  width: 350,
                  height: _isExpanded2 ? 450 : 70,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 107, 157, 182),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Le Matin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isExpanded2) ...[
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _ILMA,
                                  decoration: const InputDecoration(
                                    labelText: 'Insuline lente',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _IRMA,
                                  decoration: const InputDecoration(
                                    labelText: 'Insuline rapide',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _TGMA,
                                  decoration: const InputDecoration(
                                    labelText: 'Taux de glycémie g/L',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _GMA,
                                  decoration: const InputDecoration(
                                    labelText: 'Glucides',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 162, 182, 199),
                                ), // Define the background color
                                minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 60),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                updateData(context);
                              },
                              child: const Text(
                                "Valider",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ))
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded3 = !_isExpanded3;
                  });
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  width: 350,
                  height: _isExpanded3 ? 375 : 70,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 107, 157, 182),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Midi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isExpanded3) ...[
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _IRMI,
                                  decoration: const InputDecoration(
                                    labelText: 'Insuline rapide',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _TGMi,
                                  decoration: const InputDecoration(
                                    labelText: 'Taux de glycémie g/L',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _GMI,
                                  decoration: const InputDecoration(
                                    labelText: 'Glucides',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 162, 182, 199),
                                ), // Define the background color
                                minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 60),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                updateData(context);
                              },
                              child: const Text(
                                "Valider",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ))
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded4 = !_isExpanded4;
                  });
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  width: 350,
                  height: _isExpanded4 ? 375 : 70,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 107, 157, 182),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Dîner',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isExpanded4) ...[
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _IRD,
                                  decoration: const InputDecoration(
                                    labelText: 'Insuline rapide',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _TGD,
                                  decoration: const InputDecoration(
                                    labelText: 'Taux de glycémie g/L',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _GD,
                                  decoration: const InputDecoration(
                                    labelText: 'Glucides',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 162, 182, 199),
                                ), // Define the background color
                                minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 60),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                updateData(context);
                              },
                              child: const Text(
                                "Valider",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ))
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded5 = !_isExpanded5;
                  });
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  width: 350,
                  height: _isExpanded5 ? 300 : 70,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 107, 157, 182),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Le Soir',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isExpanded5) ...[
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _ILS,
                                  decoration: const InputDecoration(
                                    labelText: 'Insuline lente',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _TGS,
                                  decoration: const InputDecoration(
                                    labelText: 'Taux de glycémie g/L',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 162, 182, 199),
                                ), // Define the background color
                                minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 60),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                updateData(context);
                              },
                              child: const Text(
                                "Valider",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ))
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded6 = !_isExpanded6;
                  });
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  width: 350,
                  height: _isExpanded6 ? 220 : 70,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 107, 157, 182),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'La Nuit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isExpanded6) ...[
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _TGN,
                                  decoration: const InputDecoration(
                                    labelText: 'Taux de glycémie g/L',
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 162, 182, 199),
                                ), // Define the background color
                                minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 60),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                updateData(context);
                              },
                              child: const Text(
                                "Valider",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ))
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.green,
                      value: _isCommentChecked,
                      onChanged: (value) {
                        setState(() {
                          _isCommentChecked = value!;
                          _isCommentEnabled = value;
                        });
                      },
                    ),
                    const Text(
                      'Ajouter un commentaire',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              if (_isCommentEnabled) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        maxLines: 5,
                        controller: _commentController,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final textFieldsProvider =
                      Provider.of<TextFieldsControllerProvider>(
                    context,
                    listen: false,
                  );
                  await textFieldsProvider.updateControllersWithFirebaseData();
                  // ignore: use_build_context_synchronously
                  _sendEmail(context);
                },
                // ignore: sort_child_properties_last
                child: const Text(
                  "Envoyer",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(350, 60)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

void _sendEmail(BuildContext context) async {
  final textFieldsProvider = Provider.of<TextFieldsControllerProvider>(
    context,
    listen: false,
  );

  //Fetch data from Firebase and update controllers
  await textFieldsProvider.updateControllersWithFirebaseData();

  // Get data from controllers
  final nomController = textFieldsProvider.nomController.text;
  final dateNaissanceController =
      textFieldsProvider.dateNaissanceController.text;
  final emailMedecinController = textFieldsProvider.emailMedecinController.text;
  final numeroController = textFieldsProvider.numeroController.text;

  final TGR = _TGR.text;
  final ILMA = _ILMA.text;
  final IRMA = _IRMA.text;
  final TGMA = _TGMA.text;
  final GMA = _GMA.text;
  final IRMI = _IRMI.text;
  final TGMI = _TGMi.text;
  final GMI = _GMI.text;
  final IRD = _IRD.text;
  final TGD = _TGD.text;
  final GD = _GD.text;
  final ILS = _ILS.text;
  final TGS = _TGS.text;
  final TGN = _TGN.text;
  final CMNT = _commentController.text;

  // Prepare email body
  final body =
      "----------------------------------------------------------------\n"
      "* Nom du client :     $nomController\n"
      "* Date de naissance :     $dateNaissanceController\n"
      "* Numéro de téléphone:     $numeroController\n"
      "----------------------------------------------------------------\n"
      "* Réveil : \n"
      "- Taux de glycémie :  $TGR \n"
      "----------------------------------------------------------------\n"
      "* Le Matin : \n"
      "- Insuline lente :  $ILMA \n"
      "- Insuline rapide :  $IRMA \n"
      "-Taux de glycémie :  $TGMA \n"
      "-Glucides :  $GMA \n"
      "----------------------------------------------------------------\n"
      "* Midi : \n"
      "- Insuline rapide :  $IRMI \n"
      "- Taux de glycémie:  $TGMI \n"
      "- Glucides :  $GMI \n"
      "----------------------------------------------------------------\n"
      "* Dîner : \n"
      "- Insuline rapide :  $IRD \n"
      "- Taux de glycémie:  $TGD \n"
      "- Glucides :  $GD \n"
      "----------------------------------------------------------------\n"
      "*Le Soir: \n"
      "- Insuline lente :  $ILS \n"
      "- Taux de glycémie:  $TGS \n"
      "----------------------------------------------------------------\n"
      "*La Nuit: \n"
      "- Taux de glycémie :  $TGN \n"
      "----------------------------------------------------------------\n"
      "*Commentaire : \n"
      "- $CMNT \n"
      "----------------------------------------------------------------\n";

  // Prepare email URI
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: emailMedecinController,
    query: 'subject=test&body=$body',
  );

  try {
    // Launch email
    // ignore: deprecated_member_use
    await launch(emailUri.toString());
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Un erreur est survenu: $e'),
      ),
    );
  }
}
