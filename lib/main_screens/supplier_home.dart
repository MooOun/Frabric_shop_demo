import 'package:fabricshopdemo/main_screens/category.dart';
import 'package:fabricshopdemo/main_screens/dashboard.dart';
import 'package:fabricshopdemo/main_screens/home_screen.dart';
import 'package:fabricshopdemo/main_screens/stores.dart';
import 'package:fabricshopdemo/main_screens/upload_products.dart';
import 'package:flutter/material.dart';


class SupplierHome extends StatefulWidget {
  static const String routeName = 'supplierHomeScreen';
  @override
  _SupplierHomeState createState() => _SupplierHomeState();
}

class _SupplierHomeState extends State<SupplierHome> {
  final List<Widget> _tabs = [
    HomeScreen(),
    Category(),
    StoresScreen(),
    DashboardScreen(),
    UploadProductScreen(),
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
        unselectedItemColor: Colors.purple.shade500,
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
            label: 'แดชบอร์ด',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.upload,
            ),
            label: 'เพิ่มสินค้า',
          ),
        ],
      ),
      body: _tabs[pageIndex],
    );
  }
}
