import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gowiide_broadband_app/screens/bottom_navigation/bottom_navigation_screen.dart';
import 'package:gowiide_broadband_app/screens/complaints_screen.dart';
import 'package:gowiide_broadband_app/screens/login_screen1.dart';
import 'package:gowiide_broadband_app/services/firebase_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyDN4eEXl_PyZtxUMTGc-b5J6fmYlrl_7qk',
            appId: '1:382828921459:android:2c684422da1d0d561fe006',
            messagingSenderId: '382828921459',
            projectId: 'gowideuser',
            storageBucket: 'gowideuser.appspot.com',
          ),
        )
      : await Firebase.initializeApp();

  final String? userId = await getUserIdFromSharedPreferences();
  await FirebaseApi().initNotifications();
  runApp(MyApp(userId: userId));
}

Future<String?> getUserIdFromSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

class MyApp extends StatelessWidget {
  final String? userId;

  const MyApp({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => userId != null
            ? BottomNavigationScreen(userId: userId.toString())
            : const LoginScreen1(),
        '/complaint': (context) => ComplaintsScreen(
            userId: userId.toString()), // Define route for complaint screen
      },
      initialRoute: '/', // Set the initial route
    );
  }
}
