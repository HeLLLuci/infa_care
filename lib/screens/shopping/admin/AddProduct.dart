import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../config/Product.dart';
import '../../../widgets/ProductCard.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final storageRef = storage.ref();

final picker = ImagePicker();

Future<File?> pickImage() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<String> uploadImage(File image) async {
  final imageRef = storageRef.child('products/${image.path.split('/').last}');
  String contentType;
  if (image.path.endsWith('.jpg') || image.path.endsWith('.jpeg')) {
    contentType = 'image/jpeg';
  } else if (image.path.endsWith('.png')) {
    contentType = 'image/png';
  } else {
    contentType = 'application/octet-stream';
  }
  final metadata = SettableMetadata(contentType: contentType);
  await imageRef.putFile(image, metadata);
  final downloadUrl = await imageRef.getDownloadURL();
  return downloadUrl;
}

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _price = 0.0;
  File? _pickedImage;

  Widget _displayImagePreview() {
    if (_pickedImage != null) {
      return ProductCard(
        title: titleController.text,
        description: descController.text,
        price: priceController.text,
        imagePath: _pickedImage!,
      );
    } else {
      return Text('No image selected');
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image for the product.'),
        ),
      );
      return;
    }

    final imageUrl = await uploadImage(_pickedImage!);
    final product = Product(
      title: _title,
      description: _description,
      price: _price,
      imageUrl: imageUrl,
    );
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('Shops').doc(uid).collection('ShopItems').doc(product.title).set(product.toMap());
    _formKey.currentState!.reset();
    setState(() {
      _pickedImage = null; // Clear image selection
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product added successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
                onSaved: (newValue) => _title = newValue!,
              ),
              TextFormField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
                onSaved: (newValue) => _description = newValue!,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
                onSaved: (newValue) => _price = double.parse(newValue!),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  final pickedImage = await pickImage();
                  if (pickedImage != null) {
                    setState(() {
                      _pickedImage = pickedImage;
                    });
                  }
                },
                child: Text('Pick Image'),
              ),
              SizedBox(height: 10.0),
              _displayImagePreview(),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
    );
  }
}
