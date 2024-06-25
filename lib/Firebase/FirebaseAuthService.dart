import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infa_care/screens/Auth/Login.dart';
import 'package:infa_care/screens/common/Homescreen.dart';
import 'package:infa_care/screens/shopping/admin/admin_homepage.dart';

class FirebaseAuthService {
  static Future<void> loginUser(String email, String password,
      BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot userDoc = await db.collection('Users').doc(
          auth.currentUser?.uid).get();
      bool isSeller = userDoc.exists
          ? (userDoc.data() as Map<String, dynamic>)['isSeller'] ?? false
          : false;
      isSeller ? Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homescreen()))
          : Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AdminHomePage()));
      Fluttertoast.showToast(msg: "Login Successful");
    } catch (e) {
      print('Error: #e');
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(msg: "User not found");
        } else if (e.code == 'invalid-credentials') {
          Fluttertoast.showToast(msg: "Incorrect password");
        } else {
          Fluttertoast.showToast(
            msg: "Something went wrong please try again",
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong please try again",
        );
      }
    }
  }

  static Future<void> registerUser(
      String name,
      String Address,
      String phoneNumber,
      String email,
      String password,
      bool isSeller,
      String shopName,
      String shopAddress,
      BuildContext context,
      ) async {
    Map<String, dynamic> shopData() => {
      'Owner Name': name,
      'Shop Name': shopName,
      'Shop Address': shopAddress,
    };
    Map<String, dynamic> userData() => {
      'Name': name,
      'Email': email,
      'Phone Number': phoneNumber,
      'Address': Address,
      'isSeller': isSeller,
    };

    final shopsCollection = FirebaseFirestore.instance.collection('Shops');
    final usersCollection = FirebaseFirestore.instance.collection('users');

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String? userId = userCredential.user?.uid;

      if (userId != null) {
        await usersCollection.doc(userId).set(userData());

        if (isSeller) {
          await shopsCollection.doc(userId).set(shopData());
          Fluttertoast.showToast(
            msg: "Registered as Shop Owner"
          );
        }
        else{
          Fluttertoast.showToast(
              msg: "Registered user"
          );
        }
      }
    } catch (e) {
      print('Error: #e');
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(msg: "User not found");
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(msg: "Incorrect password");
        } else if (e.code == 'invalid-email') {
          Fluttertoast.showToast(msg: "Please check your email");
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: "User already exists, try with another email",
          );
        } else if (e.code == 'weak-password') {
          Fluttertoast.showToast(
            msg: "Please enter more than 6 character password",
          );
        } else {
          Fluttertoast.showToast(
            msg: "Something went wrong please try again",
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong please try again",
        );
      }
    }
  }


  static Future<void> logoutUser(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      auth.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
      Fluttertoast.showToast(msg: "Log out Successful");
    } catch (e) {
      Fluttertoast.showToast(msg: "Log out failed Failed.${e}");
    }
  }
}
