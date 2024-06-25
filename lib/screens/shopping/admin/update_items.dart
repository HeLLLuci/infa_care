import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../widgets/fetched_product_card.dart';
import 'package:image_picker/image_picker.dart';

import 'AddProduct.dart';

class EditItems extends StatefulWidget {
  const EditItems({Key? key});

  @override
  State<EditItems> createState() => _EditItemsState();
}

class _EditItemsState extends State<EditItems> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    _user = _auth.currentUser;
    if (_user == null) {
      // Handle when user is not logged in
    }
  }

  Future<void> _updateProduct(DocumentSnapshot item) async {
    String updatedTitle = item['title'];
    String updatedDescription = item['description'];
    String updatedPrice = item['price'].toString();
    String updatedImageUrl = item['imageUrl'];

    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final storageRef = FirebaseStorage.instance.ref().child('products/${item.id}');
      final uploadTask = storageRef.putFile(File(pickedImage.path));
      await uploadTask.whenComplete(() async {
        updatedImageUrl = await storageRef.getDownloadURL();
      });
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Title', hintText: updatedTitle),
                  onChanged: (value) {
                    updatedTitle = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Description', hintText: updatedDescription),
                  onChanged: (value) {
                    updatedDescription = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Price', hintText: updatedPrice),
                  onChanged: (value) {
                    updatedPrice = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform update operation here
                await FirebaseFirestore.instance
                    .collection('Shops')
                    .doc(_user!.uid)
                    .collection('ShopItems')
                    .doc(item.id)
                    .update({
                  'title': updatedTitle,
                  'description': updatedDescription,
                  'price': double.parse(updatedPrice),
                  'imageUrl': updatedImageUrl,
                });
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () async {
                // Delete product and image from storage
                await FirebaseStorage.instance.ref().child('products/${item.id}').delete();
                // Delete product document from Firestore
                await FirebaseFirestore.instance
                    .collection('Shops')
                    .doc(_user!.uid)
                    .collection('ShopItems')
                    .doc(item.id)
                    .delete();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Items'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Shops')
            .doc(_user!.uid)
            .collection('ShopItems')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final documents = snapshot.data!.docs;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: documents.length,
            itemBuilder: (BuildContext ctx, index) {
              final item = documents[index];
              return GestureDetector(
                onTap: () => _updateProduct(item),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FetchedProductCard(
                    title: item['title'],
                    description: item['description'],
                    price: item['price'].toString(),
                    imageUrl: item['imageUrl'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
