import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fabricshopdemo/models/supplier_order_model.dart';

class DeliveredScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('sellerUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where(
            'deliverStatus',
            isEqualTo: 'delivered',
          )
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
              color: Colors.purple,
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No Order Has been \n\n Delivered yet',
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
                              Text("${orderData['orderPrice'].toString()} บาท"),
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
                      'See More ....',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      orderData['deliverStatus'],
                      style: TextStyle(
                        color: Colors.purple.shade500,
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
                    child: SupplierOrderModel(orderData: orderData),
                  ),
                ],
              );
            });
      },
    ));
  }
}
