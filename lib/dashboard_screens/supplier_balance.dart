import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SupplierBalance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('sellerUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.purple.shade500,
              ),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'ไม่มีสินค้า \n\n ขนส่ง',
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

        double totalPrice = 0.0;

        for (var item in snapshot.data!.docs) {
          totalPrice += item['orderQuantity'] * item['orderPrice'];
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            elevation: 0,
            title: Text(
              'ยอดรวมของร้านค้า',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StaticModel(
                  title: 'ยอดรวมทั้งหมด ',
                  value: totalPrice.toStringAsFixed(
                    2,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.10,
                ),
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.80,
                  decoration: BoxDecoration(
                      color: Colors.purple.shade500,
                      borderRadius: BorderRadius.circular(
                        15,
                      )),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text(
                      'โอนเงินเข้าบัญชี !',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}

// class AnimatedCounter extends StatefulWidget {
//   @override
//   _AnimatedCounterState createState() => _AnimatedCounterState();
// }

// class _AnimatedCounterState extends State<AnimatedCounter>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;

//   late Animation _animation;

//   @override
//   void initState() {
//     _controller =
//         AnimationController(vsync: this, duration: Duration(seconds: 3));
//     _animation = _controller;

//     setState(() {
//       _animation = Tween(begin: _animation.value, end: 45).animate(_controller);
//     });

//     _controller.forward();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Text(_animation.value.toString());
//       },
//     );
//   }
// }

class StaticModel extends StatelessWidget {
  final String title;
  final dynamic value;
  const StaticModel({
    required this.title,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                25,
              ),
              topRight: Radius.circular(
                25,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                25,
              ),
              bottomRight: Radius.circular(
                25,
              ),
            ),
          ),
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                color: Colors.purple.shade500,
                fontSize: 40,
                letterSpacing: 3,
              ),
            ),
          ),
        )
      ],
    );
  }
}
