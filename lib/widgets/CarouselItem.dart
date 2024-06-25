import 'package:flutter/material.dart';

class CarouselItem extends StatelessWidget {
  final Color carouselFirstColor;
  final Color carouselSecondColor;
  // final String imageAsset;
  // final String title;
  // final String description;
  const CarouselItem({super.key, required this.carouselFirstColor, required this.carouselSecondColor, /*required this.imageAsset, required this.title, required this.description*/});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,

      children: [
        Image.asset("assets/images/baby intro1.png"),
        Container(
        height: 300,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1, 1)
            )
          ],
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            colors: [
            carouselFirstColor,
            carouselSecondColor,
          ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),
      ),
      ],
    );
  }
}
