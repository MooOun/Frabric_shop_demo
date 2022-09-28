import 'package:flutter/material.dart';
import 'package:fabricshopdemo/main_screens/cart_screen.dart';
import 'package:fabricshopdemo/main_screens/category.dart';
import 'package:fabricshopdemo/main_screens/home_screen.dart';
import 'package:fabricshopdemo/main_screens/profile_screen.dart';
import 'package:fabricshopdemo/main_screens/stores.dart';

class CustomHomeScreen extends StatefulWidget {
  static const String routeName = 'customerHomeScreen';
  @override
  _CustomHomeScreenState createState() => _CustomHomeScreenState();
}

class _CustomHomeScreenState extends State<CustomHomeScreen> {
  final List<Widget> _tabs = [
    HomeScreen(),
    Category(),
    StoresScreen(),
    CartScreen(),
    ProfileScreen(),
  ];
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.purple.shade600,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'หมวดหมู่',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'ร้านค้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            label: 'ตระกร้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'บัญชี',
          ),
        ],
      ),
      body: _tabs[pageIndex],
    );
  }
}
