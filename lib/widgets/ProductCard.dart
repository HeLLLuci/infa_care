import 'dart:io';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final File imagePath;
  const ProductCard({
    Key? key,
    required this.title,
    required this.description,
    required this.price,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 180,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: FileImage(imagePath),
            radius: 45,
          ),
          SizedBox(height: 10.0),
          Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Text(
            description,
          ),
          Text(
            "₹ $price",
          ),
        ],
      ),
    );
  }
}
