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
        category: 'Fruits',
      ),
      Product(
        id: 'p2',
        name: 'Banana',
        price: 500,
        imagePath: 'assets/fruits/banana.jpg',
        category: 'Fruits',
      ),
      Product(
        id: 'p3',
        name: 'Orange',
        price: 1000,
        imagePath: 'assets/fruits/orange.jpg',
        category: 'Fruits',
      ),
      Product(
        id: 'p4',
        name: 'Mango',
        price: 300,
        imagePath: 'assets/fruits/Mango.jpg',
        category: 'Fruits',
      ),
      Product(
        id: 'p5',
        name: 'Strawberry',
        price: 3000,
        imagePath: 'assets/fruits/strawbarry.jpg',
        category: 'Fruits',
      ),
      Product(
        id: 'p6',
        name: 'Beef',
        price: 20000,
        imagePath: 'assets/meats/Beef.png',
        category: 'Meats',
      ),
      Product(
        id: 'p7',
        name: 'Chicken Poultry',
        price: 10000,
        imagePath: 'assets/meats/Chickenpoultry.png',
        category: 'Meats',
      ),
      Product(
        id: 'p8',
        name: 'Fishfillet',
        price: 10000,
        imagePath: 'assets/meats/Fishfillet.png',
        category: 'Meats',
      ),
      Product(
        id: 'p9',
        name: 'pork',
        price: 15000,
        imagePath: 'assets/meats/pork.png',
        category: 'Meats',
      ),
      Product(
        id: 'p10',
        name: 'Cauliflower',
        price: 15000,
        imagePath: 'assets/vegetable/Cauliflower.png',
        category: 'Vegetables',
      ),
      Product(
        id: 'p11',
        name: 'Garlic',
        price: 3000,
        imagePath: 'assets/vegetable/garlic.png',
        category: 'Vegetables',
      ),
      Product(
        id: 'p12',
        name: 'Kale',
        price: 1000,
        imagePath: 'assets/vegetable/Kale.png',
        category: 'Vegetables',
      ),
      Product(
        id: 'p13',
        name: 'Lettuce',
        price: 1000,
        imagePath: 'assets/vegetable/Lettuce.png',
        category: 'Vegetables',
      ),
      Product(
        id: 'p14',
        name: 'Cauliflower',
        price: 3000,
        imagePath: 'assets/vegetable/Onion.png',
        category: 'Vegetables',
      ),
      Product(
        id: 'p15',
        name: 'Patato',
        price: 5000,
        imagePath: 'assets/vegetable/Potato.png',
        category: 'Vegetables',
      ),
      Product(
        id: 'p16',
        name: 'Tomato',
        price: 3000,
        imagePath: 'assets/vegetable/Tomato.png',
        category: 'Vegetables',
      ),
    ];
    await _productsBox.clear();

    for (final product in mockProducts) {
      await _productsBox.put(product.id, product);
    }

    return mockProducts;
  }
}
