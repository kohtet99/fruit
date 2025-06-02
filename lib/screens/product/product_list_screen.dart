import 'package:assignment1/models/product.dart';
import 'package:assignment1/providers/cart_provider.dart';
import 'package:assignment1/providers/wishlist_provider.dart';
import 'package:assignment1/screens/product/product_detail_screen.dart';
import 'package:assignment1/widgets/app_drawer.dart';
import 'package:assignment1/widgets/cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<List<Product>>();
    final cartProv = context.read<CartProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Fruites',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF58211B),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [CartIcon(), SizedBox(width: 16)],
      ),
      drawer: const AppDrawer(),
      body:
          products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, i) {
                    final product = products[i];
                    final isFav = context
                        .watch<WishlistProvider>()
                        .isInWishlist(product);

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    product.imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        final wishlist =
                                            context.read<WishlistProvider>();
                                        if (isFav) {
                                          wishlist.removeFromWishlist(
                                            product.id,
                                          );
                                        } else {
                                          wishlist.addToWishlist(product);
                                        }
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white70,
                                        radius: 16,
                                        child: Icon(
                                          isFav
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.redAccent,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${product.price.toStringAsFixed(0)} kyat",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      cartProv.add(product);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${product.name} added to cart",
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      radius: 16,
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => const CartScreen()),
      //   ),
      //   child: const Icon(Icons.shopping_cart),
      // ),
    );
  }
}
