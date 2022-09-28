import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fabricshopdemo/auth/customer_login_screen.dart';
import 'package:fabricshopdemo/customer_screen/address_book_screen.dart';
import 'package:fabricshopdemo/customer_screen/customer_orders.dart';
import 'package:fabricshopdemo/customer_screen/wishlist_screen.dart';
import 'package:fabricshopdemo/main_screens/cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../auth/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users =
      FirebaseFirestore.instance.collection('customers');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(_auth.currentUser!.uid).get(),
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
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Container(
                  height: 230,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.purple.shade800,
                      ],
                    ),
                  ),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      expandedHeight: 140,
                      flexibleSpace:
                          LayoutBuilder(builder: (context, constraints) {
                        return FlexibleSpaceBar(
                          title: AnimatedOpacity(
                            opacity: constraints.biggest.height <= 120 ? 1 : 0,
                            duration: Duration(
                              milliseconds: 200,
                            ),
                            child: Text(
                              'Account',
                            ),
                          ),
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple,
                                  Colors.purple.shade800,
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        NetworkImage('${data['image']}'),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '${data['fullname']}'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade500,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30)),
                                      ),
                                      child: TextButton(
                                        child: SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Center(
                                            child: Text(
                                              'Cart',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CartScreen()));
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.purple.shade500,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30)),
                                    ),
                                    child: TextButton(
                                      child: SizedBox(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Center(
                                          child: Text(
                                            'Order',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomerOrders()));
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.purple.shade500,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30)),
                                    ),
                                    child: TextButton(
                                      child: SizedBox(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Center(
                                          child: Text(
                                            'WishList',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WishListScreen()));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            child: Image.asset(
                              'assets/images/inapp/logo.jpg',
                            ),
                          ),
                          ProfileHeader(
                            headerTitle: "Account Info",
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              elevation: 3,
                              child: Container(
                                height: 260,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    RepeatedListTile(
                                      onPressed: () {},
                                      title: 'Email Address',
                                      subTitle: '${data['email']}',
                                      icon: Icons.email,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                      ),
                                      child: Divider(
                                        color: Colors.purple.shade500,
                                        thickness: 1,
                                      ),
                                    ),
                                    RepeatedListTile(
                                      onPressed: () {},
                                      title: 'Phone Number ',
                                      subTitle: data['phone'],
                                      icon: Icons.phone,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                      ),
                                      child: Divider(
                                        color: Colors.purple.shade500,
                                        thickness: 1,
                                      ),
                                    ),
                                    RepeatedListTile(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return AddressBookScreen();
                                        }));
                                      },
                                      title: 'Address',
                                      subTitle: data['address'] == ''
                                          ? 'Set your address'
                                          : data['address'],
                                      icon: CupertinoIcons.location,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ProfileHeader(
                            headerTitle: "  Account Settings ",
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              elevation: 3,
                              child: Container(
                                height: 260,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    RepeatedListTile(
                                      onPressed: () {},
                                      title: 'Edit Photo',
                                      subTitle: '',
                                      icon: Icons.edit,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                      ),
                                      child: Divider(
                                        color: Colors.purple.shade500,
                                        thickness: 1,
                                      ),
                                    ),
                                    RepeatedListTile(
                                      onPressed: () {},
                                      title: 'Change Password',
                                      subTitle: '',
                                      icon: CupertinoIcons.lock,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                      ),
                                      child: Divider(
                                        color: Colors.purple.shade500,
                                        thickness: 1,
                                      ),
                                    ),
                                    RepeatedListTile(
                                      onPressed: () async {
                                        await FirebaseAuth.instance.signOut();

                                        Navigator.pushReplacementNamed(
                                            context, CustomerLoginScreen.routeName);
                                      },
                                      title: 'Logout',
                                      icon: Icons.logout,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(color: Colors.purple.shade500),
        );
      },
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final VoidCallback onPressed;
  const RepeatedListTile({
    Key? key,
    required this.title,
    this.subTitle = '',
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        subtitle: Text(
          subTitle,
        ),
        leading: Icon(
          icon,
          color: Colors.purple.shade500,
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String headerTitle;
  const ProfileHeader({Key? key, required this.headerTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            headerTitle,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
