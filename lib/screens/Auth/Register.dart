import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../Firebase/FirebaseAuthService.dart';
import 'Login.dart';


class Register extends StatefulWidget {
  const Register({super.key});
  @override
  State<Register> createState() => _RegisterState();
}
class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopAddressController = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  bool isSeller = false;
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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 300,
                padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Form(
                    child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/images/face.png"),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelText: "Enter Your Name",
                          prefixIcon: Icon(Icons.person, color: Colors.grey,)
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelText: "Enter Phone Number",
                          prefixIcon: Icon(Icons.phone, color: Colors.grey,)
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelText: "Enter Your Address",
                          prefixIcon: Icon(Icons.location_on, color: Colors.grey,),
                      ),
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
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Register as seller"),
                        SizedBox(width: 10),
                        Checkbox(
                            value: isSeller,
                            onChanged: (bool? value){
                          setState(() {
                            isSeller = value!;
                            print(isSeller);
                          });
                        }),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    isSeller? Column(
                      children: [
                        TextFormField(
                          controller: shopNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              labelText: "Enter name of your shop",
                              prefixIcon: Icon(Icons.shopping_bag_outlined, color: Colors.grey,)
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: shopAddressController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              labelText: "Enter Address",
                              prefixIcon: Icon(Icons.location_on, color: Colors.grey,)
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                              }
                            },
                            child: Text("Register")
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ) :
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
                          }
                        },
                        child: Text("Register")
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                    }, child: Text("Already have account?"))
                  ],
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void onPress() async {
    FirebaseAuthService.registerUser(nameController.text, addressController.text, phoneController.text, emailController.text, passwordController.text,isSeller, shopNameController.text, shopAddressController.text, context);
  }
}
