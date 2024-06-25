import 'package:flutter/material.dart';
import 'package:infa_care/Firebase/FirebaseAuthService.dart';
import 'package:infa_care/config/Colors.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Container(
                color: Colors.black,
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 90.0
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35.0),
                    bottomRight: Radius.circular(35.0)
                  )
                ),
              ),
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 12
                    )
                  ],
                  gradient: LinearGradient(colors: [
                    ColorConfig.homeTopGradient2,
                    ColorConfig.homeTopGradient,
                  ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35.0),
                        bottomRight: Radius.circular(35.0)
                    )
                ),
                child: ElevatedButton(onPressed: (){FirebaseAuthService.logoutUser(context);}, child: Text("Logout")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
