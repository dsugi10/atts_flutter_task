class Product {
  final String id;
  final String image;
  final String name;
  final double price;
  final double tax;
  final double discount;
  int count;
  final String category;

  Product({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.tax,
    required this.discount,
    this.count = 0,
    required this.category
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'name': name,
        'price': price,
        'tax': tax,
        'discount': discount,
        'category': category
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        image: json['image'],
        name: json['name'],
        price: (json['price'] as num).toDouble(),
        tax: (json['gst'] as num).toDouble(),
        discount: (json['gst'] as num).toDouble(),
        category: json['category']
      );
}
