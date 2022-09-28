import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fabricshopdemo/detail/products_detail.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: CupertinoSearchTextField(
          onChanged: (String value) {
            setState(() {
              searchInput = value;
            });
          },
        ),
      ),
      body: searchInput == ""
          ? Center(
              child: Text(
                'ค้นหาสินค้าของคุณ',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 24,
                ),
              ),
            )
          : (StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Something went wrong'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Colors.cyan,
                      ),
                    ),
                  );
                }

                ;

                final result = snapshot.data!.docs.where((e) {
                  return e['productname'.toLowerCase()].contains(
                    searchInput.toLowerCase(),
                  );
                });
                return ListView(
                    children: result.map((e) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProductsDetails(productList: e);
                        }));
                      },
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              15,
                            )),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                height: 100,
                                width: 100,
                                child: Image.network(
                                  e['productimage'][0],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    e['productname'],
                                    style: TextStyle(
                                      color: Colors.cyan,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    e['price'].toStringAsFixed(2),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    e['productdescription'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList());
              })),
    );
  }
}
