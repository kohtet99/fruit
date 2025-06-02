import 'package:assignment1/models/product.dart';
import 'package:hive_flutter/adapters.dart';

class ProductService {
  final Box<Product> _productsBox = Hive.box('products');

  Future<List<Product>> fetchProducts() async {
    if (_productsBox.isNotEmpty) {
      return _productsBox.values.toList();
    }

    await Future.delayed(const Duration(seconds: 2));

   var mockProducts = [
      Product(
        id: 'p1',
        name: 'Apple',
        price: 1500,
        imagePath: 'assets/fruits/apple.jpg',
      ),
      Product(
        id: 'p2',
        name: 'Banana',
        price: 500,
        imagePath: 'assets/fruits/banana.jpg',
      ),
      Product(
        id: 'p3',
        name: 'Orange',
        price: 1000,
        imagePath: 'assets/fruits/orange.jpg',
      ),
      Product(
        id: 'p4',
        name: 'Mango',
        price: 300,
        imagePath: 'assets/fruits/Mango.jpg',
      ),
      Product(
        id: 'p5',
        name: 'Strawberry',
        price: 3000,
        imagePath: 'assets/fruits/strawbarry.jpg',
      ),
    ];
    await _productsBox.clear();

    for (final product in mockProducts) {
      await _productsBox.put(product.id, product);
    }

    return mockProducts;
  }
}
