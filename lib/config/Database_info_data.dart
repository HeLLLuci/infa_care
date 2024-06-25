import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireData {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserData() async {
    String? uid = auth.currentUser?.uid;
    if (uid != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await db.collection('Users').doc(uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data()!;
        String name = userData['name'];
        String address = userData['address'];
        String phoneNumber = userData['phoneNumber'];
        bool isSeller = userData['isSeller'];
        return {
          'name': name,
          'address': address,
          'phoneNumber': phoneNumber,
          'isSeller': isSeller,
        };
      } else {
        throw Exception("User data not found!");
      }
    } else {
      throw Exception("User not logged in!");
    }
  }
}
