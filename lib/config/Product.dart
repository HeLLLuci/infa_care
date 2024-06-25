class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.id = '',
  });

  factory Product.fromMap(Map<String, dynamic> data) => Product(
    id: data['id'] ?? '',
    title: data['title'] ?? '',
    description: data['description'] ?? '',
    price: data['price'] ?? 0.0,
    imageUrl: data['imageUrl'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id' : id,
    'title': title,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
  };
}
