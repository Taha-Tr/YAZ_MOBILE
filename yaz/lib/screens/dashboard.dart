import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaz/bat_data_provider.dart';
import 'package:yaz/ble_left_data_provider.dart';
import 'package:yaz/ble_right_data_provider.dart';
import 'package:yaz/bluetooth_data_provider.dart';
import 'package:yaz/screens/bluetooth.dart';
import 'package:yaz/screens/parametres.dart';
import 'package:yaz/screens/loginsc.dart';
import 'package:yaz/screens/rapport.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Timer _timer;

  @override
  void initState() {
    // Initialize AwesomeNotifications
    AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
      ),
    ]);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // Start a periodic timer to check the condition every 30 seconds
    bool firstnotificationsentTemp = false;

    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      setState(() {
        // Access floatValue from the BluetoothDataProvider using Provider
        double floatValue = double.tryParse(
                Provider.of<BluetoothDataProvider>(context, listen: false)
                        .data ??
                    '') ??
            -1;

        // Check if floatValue is greater than 25.00
        if (floatValue > 25.00) {
          // Check if this is the first time crossing the threshold
          if (!firstnotificationsentTemp) {
            // Send the notification
            triggerNotificationsTemp();
            firstnotificationsentTemp = true;
          } else {
            // Send notification every 30 seconds
            triggerNotificationsTemp();
          }
        }
      });
    });

bool firstnotificationsentBat = false;
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
  setState(() {
    // Access floatValue from the BluetoothDataProvider using Provider
    double floatValue = double.tryParse(
            Provider.of<BLEbatdataprovider>(context, listen: false)
                    .data ??
                '') ??
        -1;

    // Check if floatValue is less than 20.00
    if (floatValue < 20.00 && floatValue > 0.00 ) {
      // Check if this is the first time crossing the threshold
      if (!firstnotificationsentBat) {
        // Send the notification
        triggerNotificationsBat();
        firstnotificationsentBat = true;
      } else {
        // Send notification every 30 seconds
        triggerNotificationsBat();
      }
    }
  });
});

    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  void triggerNotificationsTemp() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 25,
        channelKey: 'basic_channel',
        title: 'Attention !',
        body: 'Temperature supérieure à 25°C !',
      ),
    );
  }

    void triggerNotificationsBat() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 25,
        channelKey: 'basic_channel',
        title: 'Attention !',
        body: 'Batterie faible !',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey[200],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 7, 100, 143),
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 24.0,
                  height: 170.0,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color:  Colors.white,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<BluetoothDataProvider>(
                        builder: (context, bluetoothDataProvider, _) {
                          String? data = bluetoothDataProvider.data;
                          double floatValue = double.tryParse(data ?? '') ??
                              -1; // Convert string to double

                          // Determine icon color based on temperature value
                          Color iconColor = data != null
                              ? (floatValue > 25.00
                                  ? Colors.red
                                  : floatValue > 20.00 && floatValue < 25.00
                                      ? const Color.fromARGB(255, 247, 190, 2)
                                      : floatValue < 20.00 && floatValue > -1.00
                                          ? Colors.green
                                          : floatValue < -1.00
                                              ? Colors.blue
                                              : const Color.fromARGB(
                                                  255, 184, 184, 184))
                              : const Color.fromARGB(255, 184, 184, 184);

                          return Icon(
                            Icons.thermostat,
                            size: 50.0,
                            color: iconColor,
                          );
                        },
                      ),
                      const SizedBox(height: 10.0), // Spacer
                      Consumer<BluetoothDataProvider>(
                        builder: (context, bluetoothDataProvider, _) {
                          String? data = bluetoothDataProvider.data;
                          return Text(
                            data?.toString() ?? '- - -',
                            style: const TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 5, 60, 105)),
                          );
                        },
                      ),
                      const SizedBox(height: 10.0), // Spacer
                      const Text(
                        'Température',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    width: 16.0), // Small space between the containers
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 24.0,
                  height: 170.0,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon placeholder
                      Consumer<BLEbatdataprovider>(
                        builder: (context, batDataProvider, _) {
                          String? data = batDataProvider.data;
                          double floatValue = double.tryParse(data ?? '') ??
                              -1; // Convert string to double

                          // Determine icon color based on battery value
                          Color iconColor = data != null
                              ? (data == "Mis en CH"
                                  ? Colors.green
                                  : data == ""
                                      ? const Color.fromARGB(255, 184, 184, 184)
                                      : floatValue < 15.00 && floatValue > 0.00
                                          ? Colors.red
                                          : floatValue > 15.00 &&
                                                  floatValue < 50.00
                                              ? const Color.fromARGB(
                                                  255, 247, 190, 2)
                                              : floatValue > 50.00
                                                  ? Colors.green
                                                  : floatValue < -1.00
                                                      ? Colors.blue
                                                      : const Color.fromARGB(
                                                          255, 184, 184, 184))
                              : const Color.fromARGB(255, 184, 184, 184);

                          return Icon(
                            Icons.battery_full,
                            size: 50.0,
                            color: iconColor,
                          );
                        },
                      ),
                      const SizedBox(height: 10.0), // Spacer
                      Consumer<BLEbatdataprovider>(
                        builder: (context, batDataProvider, _) {
                          String? data = batDataProvider.data;
                          return Text(
                            data?.toString() ?? '- - -',
                            style: const TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 5, 60, 105)),
                          );
                        },
                      ),
                      const SizedBox(height: 10.0), // Spacer
                      const Text(
                        'Batterie',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0), // SizedBox
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 24.0,
                  height: 350.0,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/Insuline.png',
                        height: 80,
                      ),
                      const SizedBox(height: 50.0), // Spacer
                      Consumer<BLEleftDataProvider>(
                        builder: (context, leftDataProvider, _) {
                          String? data = leftDataProvider.data;
                          return Text(
                            data?.toString() ?? '- -',
                            style: const TextStyle(
                                fontSize: 50,
                                color: Color.fromARGB(255, 5, 60, 105)),
                          );
                        },
                      ),
                      const SizedBox(height: 50.0), // Spacer
                      const Text(
                        'Prises',
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    width: 16.0), // Small space between the containers
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 24.0,
                  height: 350.0,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon placeholder
                      Image.asset(
                        'images/Insuline.png',
                        height: 80,
                      ),
                      const SizedBox(height: 50.0), // Spacer
                      Consumer<BLErightDataProvider>(
                        builder: (context, rightDataProvider, _) {
                          String? data = rightDataProvider.data;
                          return Text(
                            data?.toString() ?? '- -',
                            style: const TextStyle(
                                fontSize: 50,
                                color: Color.fromARGB(255, 5, 60, 105)),
                          );
                        },
                      ),
                      const SizedBox(height: 50.0), // Spacer
                      const Text(
                        'Prises',
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // SizedBox
            TextButton(
              onPressed: _openMaps,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 62, 141, 65),
                ), // Define the background color
                minimumSize: MaterialStateProperty.all<Size>(
                  const Size(500.0, 70.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: const Text(
                "Pharmacies à proximité",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMaps() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double latitude = position.latitude;
    double longitude = position.longitude;

    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=pharmacy+near+$latitude,$longitude';
    try {
      // ignore: deprecated_member_use
      await launch(googleMapsUrl);
    } catch (e) {
      // ignore: avoid_print
      print('Error launching Google Maps: $e');
    }
  }
}
