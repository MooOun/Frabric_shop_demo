import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fabricshopdemo/minor_screens/visit_store_screen.dart';

import 'package:flutter/material.dart';


class StoresScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'ร้านค้า',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('sellers').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 2,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return VisitStore(
                            sellerUid: snapshot.data!.docs[index]['sellerUid'],
                          );
                        }));
                      },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Image.asset(
                                    'assets/images/inapp/store1.jpg'),
                              ),
                              Positioned(
                                  left: 10,
                                  bottom: 28,
                                  child: SizedBox(
                                    height: 48,
                                    width: 120,
                                    child: Image.network(
                                      snapshot.data!.docs[index]['storeImage'],
                                      fit: BoxFit.cover,
                                    ),
                                  ))
                            ],
                          ),
                          Text(snapshot.data!.docs[index]['storeName'])
                        ],
                      ),
                    );
                  });
            }

            return Center(
              child: Text('ไม่มีร้านค้าในขณะนี้'),
            );
          },
        ),
      ),
    );
  }
}
