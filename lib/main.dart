import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lifestyle/helper/helper_function.dart';
import 'package:lifestyle/pages/auth/login_page.dart';
import 'package:lifestyle/pages/home_page_admin.dart';
import 'package:lifestyle/services/database_service.dart';
import 'package:lifestyle/shared/constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: true,
      home: _isSignedIn ? const HomePageAdmin() : LogInPage(),
    );
  }
}
