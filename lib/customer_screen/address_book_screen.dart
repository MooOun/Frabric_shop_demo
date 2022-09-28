import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fabricshopdemo/customer_screen/addAdress_screen.dart';

class AddressBookScreen extends StatefulWidget {
  @override
  _AddressBookScreenState createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  final Stream<QuerySnapshot> _addressStream = FirebaseFirestore.instance
      .collection('customers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'ที่อยู่',
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
                        color: Colors.cyan,
                      ),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'ไม่มีการเพิ่ม \n\n  ที่อยู่',
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
                      itemBuilder: (context, int index) {
                        final addressData = snapshot.data!.docs[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                for (var item in snapshot.data!.docs) {
                                  await FirebaseFirestore.instance
                                      .runTransaction((transaction) async {
                                    DocumentReference documentReference =
                                        FirebaseFirestore.instance
                                            .collection('customers')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection('address')
                                            .doc(item.id);

                                    transaction.update(
                                        documentReference, {'default': false});
                                  });
                                }

                                await FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentReference documentReference =
                                      FirebaseFirestore.instance
                                          .collection('customers')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection('address')
                                          .doc(addressData['addressId']);

                                  transaction.update(
                                      documentReference, {'default': true});
                                });

                                await FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentReference documentReference =
                                      FirebaseFirestore.instance
                                          .collection('customers')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid);

                                  transaction.update(
                                    documentReference,
                                    {
                                      'address': addressData['countryName'],
                                    },
                                  );
                                });
                                await FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentReference documentReference =
                                      FirebaseFirestore.instance
                                          .collection('customers')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid);

                                  transaction.update(
                                    documentReference,
                                    {
                                      'phone': addressData['phoneNumber'],
                                    },
                                  );
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Card(
                                  elevation: 2,
                                  color: Colors.purple.shade500,
                                  child: ListTile(
                                    trailing: addressData['default'] == true
                                        ? Icon(
                                            CupertinoIcons.location,
                                            color: Colors.white,
                                          )
                                        : Text(''),
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: SizedBox(
                                      height: 80,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'City/State   ${addressData['cityName']} ${addressData['StateName']}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            '${addressData['countryName']}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Material(
                borderRadius: BorderRadius.circular(
                  15,
                ),
                color: Colors.purple.shade500,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.60,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AddAdressScreen();
                    }));
                  },
                  child: Center(
                    child: Text(
                      'Add New Address',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
