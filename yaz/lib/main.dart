import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:yaz/Auth.dart';
import 'package:yaz/bat_data_provider.dart';
import 'package:yaz/ble_left_data_provider.dart';
import 'package:yaz/ble_right_data_provider.dart';
import 'package:yaz/bluetooth_data_provider.dart';
import 'package:yaz/param_data_provider.dart';
import 'package:yaz/screens/loginsc.dart';
import 'package:yaz/screens/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'notification channel for basic tests'),
    ],
    debug: true,
  );

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyA_5byjpAinwGd08YVX4C6630v0kVOQUhk",
            appId: "1:953098642168:android:429b0310081d8b096fd10d",
            messagingSenderId: "953098642168",
            projectId: "pfe-f88f3",
          ),
        )
      : await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(255, 7, 100, 143),

    //statusBarIconBrightness: Brightness.dark,
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BluetoothDataProvider>(
          create: (context) => BluetoothDataProvider(),
        ),
        ChangeNotifierProvider<BLEleftDataProvider>(
          create: (context) => BLEleftDataProvider(),
        ),
        ChangeNotifierProvider<BLErightDataProvider>(
          create: (context) => BLErightDataProvider(),
        ),
        ChangeNotifierProvider<BLEbatdataprovider>(
          create: (context) => BLEbatdataprovider(),
        ),
        ChangeNotifierProvider<TextFieldsControllerProvider>(
          create: (context) => TextFieldsControllerProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Auth(),
        routes: {
          'signupScreen': (context) => const RegisterScreen(),
          'loginscreen': (context) => const LoginScreen(),
        });
  }
}
