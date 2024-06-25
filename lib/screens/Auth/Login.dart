import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infa_care/Firebase/FirebaseAuthService.dart';
import 'package:infa_care/screens/Auth/Register.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class Login extends StatefulWidget {
  

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  bool isPassVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color(0xFFfbc2eb),
              Color(0xFFa6c1ee),
        ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 300,
            height: 380,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Form(child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/images/face.png"),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: "Enter Email",
                      prefixIcon: Icon(Icons.email, color: Colors.grey,)
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isPassVisible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: "Enter Password",
                      prefixIcon: Icon(Icons.key, color: Colors.grey,),
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          isPassVisible = !isPassVisible;
                        });
                      }, icon: isPassVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility))
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RoundedLoadingButton(
                    color: Color(0xFFFFB0B0),
                      controller: _btnController,
                      successIcon: Icons.done,
                      failedIcon: Icons.close,
                      onPressed: (){
                        if(emailController.text.isEmpty||passwordController.text.isEmpty){
                          Fluttertoast.showToast(msg: "Both Email and Password is required");
                        }
                        else{
                          onPress();
                          _btnController.start();
                          Future.delayed(Duration(seconds: 3), (){
                            _btnController.reset();
                          });
                        }
                      },
                      child: Text("Login")
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                  }, child: Text("Signup"))
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
  void onPress() async {
    FirebaseAuthService.loginUser(emailController.text, passwordController.text, context);
  }
}
