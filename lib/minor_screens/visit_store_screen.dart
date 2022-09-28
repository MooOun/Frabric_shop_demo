import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fabricshopdemo/models/product_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class VisitStore extends StatefulWidget {
  final sellerUid;

  const VisitStore({super.key, required this.sellerUid});
  @override
  _VisitStoreState createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  CollectionReference users = FirebaseFirestore.instance.collection('sellers');

  bool following = false;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sellerUid', isEqualTo: widget.sellerUid)
        .snapshots();
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.sellerUid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.purple.shade500,
                toolbarHeight: 100,
                elevation: 1,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      data['storeName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    data['sellerUid'] == FirebaseAuth.instance.currentUser!.uid
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.32,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              color: Colors.purple.shade500,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  following = !following;
                                });
                              },
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ปรับเเต่ง',
                                    ),
                                    // IconButton(
                                    //   onPressed: () {},
                                    //   icon: Icon(Icons.edit),
                                    // )
                                  ],
                                ),
                              )),
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.32,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              color: Colors.purple.shade500,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  following = !following;
                                });
                              },
                              child: Center(
                                child: following == true
                                    ? Text('ติดตาม',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ))
                                    : Text(
                                        'ติดตามเเล้ว',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                              ),
                            ),
                          )
                  ],
                ),
                centerTitle: true,
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: _productsStream,
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
                        color: Colors.purple.shade500,
                      ),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'This Category \n\n has no items yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.purple.shade500,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      crossAxisCount: 1,
                      itemBuilder: (context, index) {
                        return ProductModel(
                          products: snapshot.data!.docs[index],
                        );
                      },
                      staggeredTileBuilder: (context) => StaggeredTile.fit(1),
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: Icon(FontAwesomeIcons.whatsapp),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(
              color: Colors.purple.shade500,
            ),
          );
        },
      ),
    );
  }
}
