import 'package:assignment1/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<int>(
      builder:
          (_, count, __) => IconButton(
            icon: Badge(
              label: count > 0 ? Text('$count') : null,
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
    );
  }
}
