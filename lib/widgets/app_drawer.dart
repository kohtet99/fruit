import 'package:assignment1/providers/auth_provider.dart';
import 'package:assignment1/screens/cart/cart_screen.dart';
import 'package:assignment1/screens/earthquake.dart';
import 'package:assignment1/screens/order/order_history_screen.dart';
import 'package:assignment1/screens/product/product_list_screen.dart';
import 'package:assignment1/screens/settings/about_screen.dart';
import 'package:assignment1/screens/settings/feedback_screen.dart';
import 'package:assignment1/screens/settings/settings_screen.dart';
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
              padding: EdgeInsets.only(
                top: topPadding,
                left: 16,
                right: 16,
                bottom: 20,
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: const [
                    Icon(Icons.menu, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "Main Menu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildSectionTitle("Categories"),
            _buildSection(
              context,
              items: [
                _DrawerItem(FontAwesomeIcons.carrot, "Vegetables", () {}),
                // ignore: deprecated_member_use
                _DrawerItem(FontAwesomeIcons.appleAlt, "Fruits", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductListScreen()),
                  );
                }),
                _DrawerItem(FontAwesomeIcons.drumstickBite, "Meats", () {}),
              ],
            ),
            const SizedBox(height: 12),
            _buildSectionTitle("My Account"),
            _buildSection(
              context,
              items: [
                _DrawerItem(Icons.receipt_long, "Orders", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrderHistoryScreen(),
                    ),
                  );
                }),
                // _DrawerItem(Icons.location_on_outlined, "Shipping Address", () {}),
                // _DrawerItem(Icons.credit_card, "Payment Method", () {}),
                _DrawerItem(Icons.favorite_border, "Wishlist", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WishlistScreen()),
                  );
                }),
                _DrawerItem(Icons.shopping_cart_outlined, "Cart", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                }),
                _DrawerItem(Icons.waves, "Earthquake", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyanmarEarthquakeScreen(),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 12),
            _buildSectionTitle("Settings"),
            _buildSection(
              context,
              items: [
                _DrawerItem(Icons.settings, "App Settings", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                }),
              ],
            ),
            const Spacer(),
            Divider(color: Colors.grey[400]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomIcon(Icons.info_outline, "About", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AboutScreen()),
                    );
                  }),
                  _BottomIcon(Icons.feedback_outlined, "Feedback", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FeedbackScreen()),
                    );
                  }),
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

  Widget _buildSection(
    BuildContext context, {
    required List<_DrawerItem> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[50],
        elevation: 1,
        child: Column(
          children:
              items.map((it) {
                return ListTile(
                  leading:
                      it.icon is IconData
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
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.logout, size: 48, color: Color(0xFF58211B)),
                const SizedBox(height: 16),
                const Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF58211B),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Are you sure you want to log out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF58211B)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Color(0xFF58211B)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF58211B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Log Out",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldLogout == true) {
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
