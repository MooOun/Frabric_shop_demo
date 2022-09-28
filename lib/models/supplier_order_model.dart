import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class SupplierOrderModel extends StatelessWidget {
  const SupplierOrderModel({
    Key? key,
    required this.orderData,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> orderData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'ชื่อลูกค้า :  ${orderData['customerName']} ',
            style: TextStyle(
              fontSize: 11,
            ),
          ),
          Text(
            'เบอร์ติดต่อ :  ${orderData['phone']} ',
            style: TextStyle(
              fontSize: 11,
            ),
          ),
          Text(
            'อีเมล :  ${orderData['email']} ',
            style: TextStyle(
              fontSize: 11,
            ),
          ),
          Text(
            'ที่อยู่ในการจัดส่ง :  ${orderData['address']} ',
            style: TextStyle(
              fontSize: 11,
            ),
          ),
          Text(
            'สถาณะการจ่ายเงิน :  ${orderData['paymentStatus']} ',
            style: TextStyle(
              fontSize: 11,
            ),
          ),
          Row(
            children: [
              Text('สถาณะการขนส่ง'),
              SizedBox(
                width: 7,
              ),
              Text(
                '${orderData['deliverStatus']}',
                style: TextStyle(
                  color: Colors.cyan,
                ),
              )
            ],
          ),
          orderData['deliverStatus'] == 'shipping'
              ? Text(
                  'Estimated Delivery Date:  ${orderData['deliveryDate']} ',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                )
              : Text(''),
          Row(
            children: [
              Text(
                ' Order Date ',
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              Text(
                DateFormat('yyyy-MM-dd').format(
                  orderData['orderDate'].toDate(),
                ),
              ),
            ],
          ),
          orderData['deliverStatus'] == 'delivered'
              ? Text('This Order has been Delivered')
              : Row(
                  children: [
                    Text(
                      ' Change Delivery Status  ',
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                    orderData['deliverStatus'] == 'preparing'
                        ? TextButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  minTime: DateTime.now(),
                                  maxTime: DateTime.now().add(
                                    Duration(
                                      days: 365,
                                    ),
                                  ), onConfirm: (date) {
                                FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(orderData['orderId'])
                                    .update({
                                  'deliverStatus': 'shipping',
                                  'deliveryDate': date,
                                });
                              });
                            },
                            child: Text('ส่งขนส่งเเล้ว'),
                          )
                        : TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(orderData['orderId'])
                                  .update({
                                'deliverStatus': 'delivered',
                              });
                            },
                            child: Text('ส่งเรียบร้อยเเล้ว'))
                  ],
                ),
        ],
      ),
    );
  }
}
