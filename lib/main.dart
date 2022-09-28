import 'package:fabricshopdemo/auth/customer_login_screen.dart';
import 'package:fabricshopdemo/auth/seller_login_screen.dart';
import 'package:fabricshopdemo/auth/seller_register.dart';
import 'package:fabricshopdemo/main_screens/custormer_home_screen.dart';
import 'package:fabricshopdemo/main_screens/supplier_home.dart';
import 'package:fabricshopdemo/provider/cart_provider.dart';
import 'package:fabricshopdemo/provider/wishlist_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'auth/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) {
      return Cart();
    }),
    ChangeNotifierProvider(create: (_) {
      return WishList();
    })
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Kanit-Bold",
        primarySwatch: Colors.blue,
      ),
      initialRoute: WelcomeScreen.routeName,
      routes: {
        WelcomeScreen.routeName: (context) => WelcomeScreen(),
        CustomHomeScreen.routeName: (context) => CustomHomeScreen(),
        SupplierHome.routeName: (context) => SupplierHome(),
        CustomerLoginScreen.routeName: (context) => CustomerLoginScreen(),
        SellerRegisterScreen.routeName: (context) => SellerRegisterScreen(),
        SellerLoginScreen.routeName: (context) => SellerLoginScreen()
      },
    );
  }
}
