import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infa_care/screens/Auth/Login.dart';
import 'package:infa_care/screens/common/Homescreen.dart';
import 'package:infa_care/screens/common/Intro.dart';
import 'package:infa_care/screens/shopping/admin/AddProduct.dart';
import 'package:infa_care/screens/shopping/admin/admin_homepage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  User? currentUser = FirebaseAuth.instance.currentUser;
  Widget initialScreen = currentUser != null ? AdminHomePage() : AnimateIntro();
  runApp(MyApp(initialScreen: initialScreen));
}
class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({Key? key, required this.initialScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Medio",
        primaryColor: Color(0xFFFFB0B0),
      ),
      home: initialScreen,
    );
  }
}

