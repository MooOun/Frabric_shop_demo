import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class CustomerOrders extends StatefulWidget {
  @override
  State<CustomerOrders> createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  late double rate;
  late String comment;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        title: Text(
          'คำสั่งซื้อของคุณ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('cid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.purple.shade500,
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'คุณยังไม่ได้ \n\n สั่งสิน้คา',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.purple.shade500,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.7,
                ),
              ),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final orderData = snapshot.data!.docs[index];
                return ExpansionTile(
                  title: Row(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 60,
                          maxWidth: 80,
                        ),
                        child: Image.network(
                          orderData['orderImage'],
                        ),
                      ),
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderData['orderName'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${orderData['orderPrice'].toString()} บาท "),
                                Text(
                                  "X ${orderData['orderQuantity'].toString()}",
                                  style: TextStyle(
                                    color: Colors.purple.shade500,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ดูเพิ่มเติม ....',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        orderData['deliverStatus'],
                        style: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'ชื่อลูกค้า :  ${orderData['customerName']} ',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'เบอร์โทรศัพท์ :  ${orderData['phone']} ',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'อีเมล :  ${orderData['email']} ',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'ที่อยู่ :  ${orderData['address']} ',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'สถานะการชำระเงิน :  ${orderData['paymentStatus']} ',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'สถานะการขนส่ง :  ${orderData['deliverStatus']} ',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            orderData['deliverStatus'] == 'shipping'
                                ? Row(
                                    children: [
                                      Text(
                                        'Estimated Delivery Date',
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        DateFormat('yyyy-MM-dd').format(
                                          orderData['orderDate'].toDate(),
                                        ),
                                      )
                                    ],
                                  )
                                : Text(''),
                            orderData['deliverStatus'] == 'delivered' &&
                                    orderData['orderReview'] == false
                                ? TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Material(
                                              color: Colors.white,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    RatingBar.builder(
                                                      initialRating: 1,
                                                      minRating: 1,
                                                      allowHalfRating: true,
                                                      itemBuilder:
                                                          (context, int) {
                                                        return Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        );
                                                      },
                                                      onRatingUpdate: (value) {
                                                        rate = value;
                                                      },
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: TextField(
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'เพิ่มการรีวิว',
                                                          labelText:
                                                              'ยืนยันการรีวิว',
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              10,
                                                            ),
                                                          ),
                                                        ),
                                                        onChanged: (value) {
                                                          comment = value;

                                                          print(comment);
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Material(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors.purple.shade500,
                                                            child:
                                                                MaterialButton(
                                                              minWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.45,
                                                              onPressed: () {},
                                                              child: Text(
                                                                'Cancel',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Material(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors.purple.shade500,
                                                            child:
                                                                MaterialButton(
                                                              minWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.45,
                                                              onPressed:
                                                                  () async {
                                                                CollectionReference reference = FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'products')
                                                                    .doc(orderData[
                                                                        'productId'])
                                                                    .collection(
                                                                        'reviews');

                                                                await reference
                                                                    .doc(FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid)
                                                                    .set({
                                                                  'name': orderData[
                                                                      'customerName'],
                                                                  'email':
                                                                      orderData[
                                                                          'email'],
                                                                  'profileImage':
                                                                      orderData[
                                                                          'orderImage'],
                                                                  'rate': rate,
                                                                  'comment':
                                                                      comment,
                                                                }).whenComplete(
                                                                        () async {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'orders')
                                                                      .doc(orderData[
                                                                          'orderId'])
                                                                      .update({
                                                                    'orderReview':
                                                                        true,
                                                                  });
                                                                }).whenComplete(
                                                                        () {
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              },
                                                              child: Text(
                                                                'OK',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Text(
                                      'Write Review',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : Text(''),
                            orderData['deliverStatus'] == 'delivered' &&
                                    orderData['orderReview'] == true
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      Text(
                                        'Review Added',
                                      ),
                                    ],
                                  )
                                : Text(''),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              });
        },
      ),
    );
  }
}
