import 'package:assignment1/models/product.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WishlistProvider with ChangeNotifier {
  final Box _wishlistBox = Hive.box('wishlist');

  List<Product> get iteams {
    return _wishlistBox.values.cast<Product>().toList();
  }

  bool isInWishlist(Product product) {
    return _wishlistBox.containsKey(product.id);
  }

  void addToWishlist(Product product) {
    _wishlistBox.put(product.id, product);
    notifyListeners();
  }

  void removeFromWishlist(String productId) {
    _wishlistBox.delete(productId);
    notifyListeners();
  }
}
