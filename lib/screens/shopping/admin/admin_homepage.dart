import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infa_care/config/Lists.dart';
import 'package:infa_care/screens/Auth/Login.dart';

class AdminHomePage extends StatefulWidget {

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {
              _bottomNavIndex = 2;
            });
          },
      backgroundColor: Colors.black54,
        child: Center(
          child: Icon(
            Icons.add_rounded,
            color: Colors.orange,
            size: 30,
          ),
        ),
        shape: CircleBorder(),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: Colors.orange,
          leftCornerRadius: 15.0,
          backgroundColor: Colors.black54,
          gapLocation: GapLocation.end,
          inactiveColor: Colors.white,
          icons: ListsOfThings.bottomNavIconList,
          activeIndex: _bottomNavIndex,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
            });
          }
      ),
      appBar: AppBar(
        title: Text("Shop Space"),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  signOutUser();
                },
                child: ListTile(leading: Icon(Icons.logout),title: Text("Logout"),),
              )
            ],
          ),
        ),
      ),
      body: ListsOfThings.adminScreens[_bottomNavIndex]
    );
  }

  Future<void> signOutUser() async{
    FirebaseAuth.instance.signOut().whenComplete((){
      Fluttertoast.showToast(msg: "User logged out");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    });
  }
}
