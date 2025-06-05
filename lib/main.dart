import 'package:assignment1/models/order.dart';
import 'package:assignment1/models/product.dart';
import 'package:assignment1/providers/auth_provider.dart';
import 'package:assignment1/providers/cart_provider.dart';
import 'package:assignment1/providers/order_provider.dart';
import 'package:assignment1/providers/productfilter_provider.dart';
import 'package:assignment1/providers/review_provider.dart';
import 'package:assignment1/providers/wishlist_provider.dart';
import 'package:assignment1/screens/auth/login_screen.dart';
import 'package:assignment1/screens/auth/verification_screen.dart';
import 'package:assignment1/screens/product/product_list_screen.dart';
import 'package:assignment1/services/discount_service.dart';
import 'package:assignment1/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(OrderAdapter());
  // await Hive.deleteBoxFromDisk('products'); //reload deletebox
  // await Hive.deleteBoxFromDisk('orders');
  // await Hive.deleteBoxFromDisk('wishlist');
  await Hive.openBox<Product>('products');
  await Hive.openBox<Order>('orders');
  await Hive.openBox('wishlist');

  runApp(
    MultiProvider(
      providers: [
        FutureProvider<List<Product>>(
          create: (_) => ProductService().fetchProducts(),
          initialData: [],
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        StreamProvider<int>(
          create: (ctx) => ctx.read<CartProvider>().itemCountStream,
          initialData: 0,
        ),
        ProxyProvider<CartProvider, DiscountService>(
          update: (_, cart, __) => DiscountService(cart.totalPrice),
        ),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => ProductFilterProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => AuthWrapper(),
        '/login': (context) => LoginScreen(),
        '/products': (context) => const ProductListScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user != null) {
      if (authProvider.user!.emailVerified) {
        return ProductListScreen();
      } else {
        return VerificationScreen(email: authProvider.user!.email!);
      }
    } else {
      return LoginScreen();
    }
  }
}
