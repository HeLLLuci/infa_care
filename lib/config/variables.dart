import 'package:firebase_auth/firebase_auth.dart';

class Variables{
  static String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
  static String userID = FirebaseAuth.instance.currentUser?.uid ?? '';
}