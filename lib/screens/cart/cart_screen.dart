import 'package:assignment1/providers/cart_provider.dart';
import 'package:assignment1/services/discount_service.dart';
import 'package:assignment1/screens/payment/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<CartProvider>().items;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF58211B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                items.isEmpty
                    ? const Center(
                      child: Text(
                        'Your cart is empty!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF58211B),
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: items.length,
                      itemBuilder: (_, index) {
                        final product = items[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    product.imagePath,
                                    width: screenWidth * 0.25,
                                    height: screenWidth * 0.25,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Product Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${product.price} kyat',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.red[300],
                                      ),
                                      onPressed:
                                          () => context
                                              .read<CartProvider>()
                                              .remove(product),
                                    ),
                                    Text(
                                      '${product.quantity}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.green[300],
                                      ),
                                      onPressed:
                                          () => context
                                              .read<CartProvider>()
                                              .add(product),
                                    ),
                                  ],
                                ),
                                // Remove Button
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    color: Colors.red[300],
                                  ),
                                  onPressed:
                                      () => context.read<CartProvider>()..removeItem(product),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
          // Total Section
          if (items.isNotEmpty) ...[
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  // Subtotal
                  _buildTotalRow(
                    context,
                    label: 'Subtotal',
                    value: context.select<CartProvider, double>(
                      (cart) => cart.totalPrice,
                    ),
                  ),
                  // Discount
                  _buildTotalRow(
                    context,
                    label: 'Discount',
                    value: context.select<DiscountService, double>(
                      (disc) => disc.discountAmount,
                    ),
                    isDiscount: true,
                  ),
                  const Divider(height: 30),
                  // Grand Total
                  _buildTotalRow(
                    context,
                    label: 'Grand Total',
                    value:
                        context.select<CartProvider, double>(
                          (cart) => cart.totalPrice,
                        ) -
                        context.select<DiscountService, double>(
                          (disc) => disc.discountAmount,
                        ),
                    isTotal: true,
                  ),
                  const SizedBox(height: 15),
                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text(
                        'CHECKOUT',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    BuildContext context, {
    required String label,
    required double value,
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color:
                  isTotal ? Theme.of(context).primaryColor : Colors.grey[700],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)} kyat',
            style: TextStyle(
              fontSize: 16,
              color:
                  isDiscount
                      ? Colors.red
                      : isTotal
                      ? Theme.of(context).primaryColor
                      : Colors.green[800],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
