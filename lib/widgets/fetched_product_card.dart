import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FetchedProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imageUrl;

  const FetchedProductCard({
    Key? key,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => Image(image: NetworkImage(imageUrl)),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
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
