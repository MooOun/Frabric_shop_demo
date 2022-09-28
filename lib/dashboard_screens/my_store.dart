import 'package:flutter/material.dart';

class MyStore extends StatelessWidget {
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
          'ร้านของฉัน',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
