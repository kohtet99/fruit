import 'package:assignment1/providers/auth_provider.dart';
import 'package:assignment1/screens/cart/cart_screen.dart';
import 'package:assignment1/screens/earthquake.dart';
import 'package:assignment1/screens/order/order_history_screen.dart';
import 'package:assignment1/screens/product/product_list_screen.dart';
import 'package:assignment1/screens/wishlist/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final topPadding = MediaQuery.of(context).padding.top;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: const Color(0xFF58211B),
              padding: EdgeInsets.only(top: topPadding, left: 16, right: 16, bottom: 20),
              width: double.infinity,
              child: Row(
                children: const [
                  Icon(Icons.menu, color: Colors.white),
                  SizedBox(width: 12),
                  Text("Main Menu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildSectionTitle("Categories"),
            _buildSection(context, items: [
              _DrawerItem(FontAwesomeIcons.carrot, "Vegetables", () {}),
              _DrawerItem(FontAwesomeIcons.appleAlt, "Fruits", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProductListScreen()));
              }),
              _DrawerItem(FontAwesomeIcons.drumstickBite, "Meats", () {}),
            ]),
            const SizedBox(height: 12),
            _buildSectionTitle("My Account"),
            _buildSection(context, items: [
              _DrawerItem(Icons.receipt_long, "Orders", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
              }),
              // _DrawerItem(Icons.location_on_outlined, "Shipping Address", () {}),
              // _DrawerItem(Icons.credit_card, "Payment Method", () {}),
              _DrawerItem(Icons.favorite_border, "Wishlist", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistScreen()));
              }),
              _DrawerItem(Icons.shopping_cart_outlined, "Cart", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
              }),
              _DrawerItem(Icons.waves, "Earthquake", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MyanmarEarthquakeScreen()));
              }),
            ]),
            const SizedBox(height: 12),
            _buildSectionTitle("Settings"),
            _buildSection(context, items: [
              _DrawerItem(Icons.settings, "App Settings", () {}),
            ]),
            const Spacer(),
            Divider(color: Colors.grey[400]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomIcon(Icons.info_outline, "About", () {}),
                  _BottomIcon(Icons.feedback_outlined, "Feedback", () {}),
                  _BottomIcon(Icons.logout, "Logout", () {
                    _confirmLogout(context, auth);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF58211B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required List<_DrawerItem> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[50],
        elevation: 1,
        child: Column(
          children: items.map((it) {
            return ListTile(
              leading: it.icon is IconData
                  ? Icon(it.icon, color: Colors.black87)
                  : FaIcon(it.icon as IconData, color: Colors.black87),
              title: Text(it.title, style: const TextStyle(fontSize: 15)),
              onTap: it.onTap,
              dense: true,
              visualDensity: const VisualDensity(vertical: -1),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, AuthProvider auth) async {
    final should = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF58211B),
        title: const Text("Log Out", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure you want to log out?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel", style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Log Out", style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
    if (should == true) {
      await auth.signOut();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }
}

class _DrawerItem {
  final dynamic icon;
  final String title;
  final VoidCallback onTap;
  _DrawerItem(this.icon, this.title, this.onTap);
}

class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _BottomIcon(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Color(0xFF58211B)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: Color(0xFF58211B), fontSize: 12)),
          ],
        ),
      );
}
