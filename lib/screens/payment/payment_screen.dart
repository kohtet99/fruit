import 'package:assignment1/models/order.dart';
import 'package:assignment1/models/product.dart';
import 'package:assignment1/providers/cart_provider.dart';
import 'package:assignment1/providers/order_provider.dart';
import 'package:assignment1/screens/order/order_confirmation_screen.dart';
import 'package:assignment1/services/discount_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<void> _handlePayment() async {
    final ordersProvider = context.read<OrdersProvider>();
    final cartProvider = context.read<CartProvider>();
    final cartTotal = context.read<CartProvider>().totalPrice;
    final discount = context.read<DiscountService>().discountAmount;
    final grandTotal = cartTotal - discount;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: List<Product>.from(cartProvider.items),
        total: grandTotal,
        date: DateTime.now(),
      );

      await ordersProvider.addOrder(order);
      cartProvider.clearCart();

      if (!mounted) return;
      Navigator.of(context).pop(); 
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(order: order),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartTotal = context.select<CartProvider, double>(
      (cart) => cart.totalPrice,
    );
    final discount = context.select<DiscountService, double>(
      (disc) => disc.discountAmount,
    );
    final grandTotal = cartTotal - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF58211B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('Subtotal', '${cartTotal.toStringAsFixed(2)} kyat'),
            _buildSummaryRow('Discount', '-${discount.toStringAsFixed(2)} kyat', isDiscount: true),
            const Divider(height: 30),
            _buildSummaryRow('Total Amount', '${grandTotal.toStringAsFixed(2)} kyat', isTotal: true),
            const SizedBox(height: 30),
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethod(
              iconWidget: const Icon(Icons.credit_card, color: Color(0xFF58211B)),
              title: 'Credit/Debit Card',
              isSelected: true,
            ),
            _buildPaymentMethod(
              iconWidget: Image.asset('assets/logo/kpay.png', width: 24, height: 24),
              title: 'KBZ Pay',
            ),
            _buildPaymentMethod(
              iconWidget: Image.asset('assets/logo/ayapay.png', width: 24, height: 24),
              title: 'AYA Pay',
            ),
            _buildPaymentMethod(
              iconWidget: const Icon(Icons.money, color: Color(0xFF58211B)),
              title: 'Cash on Delivery',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handlePayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF58211B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified, size: 20, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'CONFIRM PAYMENT',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isTotal ? Colors.black : Colors.grey[700],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isDiscount
                  ? Colors.red
                  : isTotal
                      ? Colors.black
                      : Colors.green[800],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod({
    required String title,
    bool isSelected = false,
    Widget? iconWidget,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? const Color(0xFF58211B) : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: iconWidget,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing:
            isSelected ? const Icon(Icons.check_circle, color: Color(0xFF58211B)) : null,
        onTap: () {},
      ),
    );
  }
}
