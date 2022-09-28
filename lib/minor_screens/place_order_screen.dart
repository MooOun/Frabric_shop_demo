import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fabricshopdemo/customer_screen/addAdress_screen.dart';
import 'package:fabricshopdemo/minor_screens/payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../main_screens/cart_screen.dart';
import '../provider/cart_provider.dart';

class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final Stream<QuerySnapshot> _addressStream = FirebaseFirestore.instance
      .collection('customers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .where('default', isEqualTo: true)
      .limit(1)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'ยืนยันคำสั่งซื้อ',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _addressStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.purple.shade600,
                      ),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: CyanButton(
                            buttonTitle: 'เพิ่มที่อยู่ในการจัดส่งของคุณ', 
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AddAdressScreen();
                              }));
                            }));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, int index) {
                      final addressData = snapshot.data!.docs[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Card(
                              elevation: 2,
                              color: Colors.cyan,
                              child: ListTile(
                                title: SizedBox(
                                  height: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${addressData['firstName']}-${addressData['lastName']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        addressData['phoneNumber'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: SizedBox(
                                  height: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'City/State   ${addressData['cityName']} ${addressData['StateName']}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        '${addressData['countryName']}',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Consumer<Cart>(builder: (context, cart, child) {
                  return ListView.builder(
                      itemCount: cart.count,
                      itemBuilder: (context, index) {
                        final order = cart.getItems[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.network(
                                      order.imagesUrl.first,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        order.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 19),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text('ราคา : \t\t'),
                                                Text(
                                                  order.price.toStringAsFixed(2),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.purple.shade500,
                                                  ),
                                                ),
                                                Text('\t\tบาท'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('จำนวน :'),
                                                  Text(
                                                'x ${order.quantity.toString()}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                                ],
                                              ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: CyanButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return PaymentScreen();
                  }));
                },
                buttonTitle:
                    'ยืนยันสินค้า ราคา : ${context.watch<Cart>().totalPrice..toStringAsFixed(2)} บาท',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
