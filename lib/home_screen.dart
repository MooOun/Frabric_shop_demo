import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            color: Colors.black,
          ),
          Text(
            'WELCOME',
          )
        ],
      ),
    );
  }
}
