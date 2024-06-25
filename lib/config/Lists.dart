import 'package:flutter/material.dart';
import 'package:infa_care/screens/Auth/Login.dart';
import 'package:infa_care/screens/shopping/admin/Orders.dart';
import 'package:infa_care/screens/shopping/admin/update_items.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../screens/shopping/admin/AddProduct.dart';

class ListsOfThings{
  static PageDecoration pageDecoration = PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Colors.white,
    imagePadding: EdgeInsets.zero,
  );
  static void onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }
  static final List<PageViewModel> pages = [
    PageViewModel(
      title: "Welcome to a world of giggles, cuddles, and endless love!",
      body:
      "Your journey into parenthood begins here, where every moment is a tiny miracle. Let's cherish the joy of growing together.",
      image: Image.asset("assets/images/baby intro1.png"),
      decoration: ListsOfThings.pageDecoration,
    ),
    PageViewModel(
      image: Image.asset("assets/images/baby intro2.png"),
      title: "Get ready for a sprinkle of joy, a dash of laughter, and a whole lot of love!",
      body:
      "Our baby care app is here to make every parenting adventure a delightful one. Let the cuddles commence!",
      decoration: ListsOfThings.pageDecoration,
    ),
  ];
  static final List<Widget> adminScreens = [
    Orders(),
    EditItems(),
    AddProduct(),
  ];
  static final List<IconData> bottomNavIconList = [
    Icons.home,
    Icons.edit,
    Icons.settings
  ];
}