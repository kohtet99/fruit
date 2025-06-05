// class Product {
//   final String id;
//   final String name;
//   final double price;
//   final String imagePath;
  
//   const Product({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.imagePath,
//   });
// }

import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double price;
  @HiveField(3)
  final String imagePath;
  @HiveField(4)
  int quantity;
  @HiveField(5)
  String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
    required this.category,
  });

  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      name: name,
      price: price,
      imagePath: imagePath,
      quantity: quantity ?? this.quantity,
      category: category,
    );
  }
}