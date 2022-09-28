import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fabricshopdemo/auth/seller_login_screen.dart';
import 'package:fabricshopdemo/auth/seller_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fabricshopdemo/auth/welcome_screen.dart';
import 'package:fabricshopdemo/main_screens/custormer_home_screen.dart';
import 'package:fabricshopdemo/utils/snackbar.dart';

class CustomerLoginScreen extends StatefulWidget {
  static const String routeName = 'CustomerLoginScreen';
  @override
  _CustomerLoginScreenState createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  bool passwordInvisable = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void login() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        _formKey.currentState!.reset();

        Navigator.pushReplacementNamed(context, CustomHomeScreen.routeName);
      } else {
        setState(() {
          isLoading = false;
        });
        return ShowSnackBar(context, 'กรุณากรอกข้อมูลให้ครบทุกช่อง');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "ไม่มีผู้ใช้นี้อยู่ในระบบ") {
        setState(() {
          isLoading = false;
        });
        return ShowSnackBar(context, e.code);
      } else if (e.code == 'ผู้ใช้หรือรหัสผ่านผิดพลาด !') {
        setState(() {
          isLoading = false;
        });
        return ShowSnackBar(context, e.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "ลงชื่อเข้าใช้",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.person,
                          size: 40,
                          color: Colors.purple.shade600,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณาใส่อีเมลของคุณ';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'อีเมล',
                      hintText: 'กรอกอีเมลของคุณ',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกรหัสผ่านของคุณ';
                      } else {
                        return null;
                      }
                    },
                    obscureText: passwordInvisable,
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      hintText: 'ใส่รหัสผ่านของคุณ',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordInvisable = !passwordInvisable;
                          });
                        },
                        icon: Icon(
                          passwordInvisable
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width - 70,
                      40,
                    ),
                  ),
                  onPressed: () {
                    login();
                  },
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ยังไม่มีบัญชีผู้ใช้งานใช่ไหม ?',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, WelcomeScreen.routeName);
                        },
                        child: Text(
                          'ลงทะเบียน',
                          style: TextStyle(
                            color: Colors.purple.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ],
                ),
                Text(
                  'หรือ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "เข้าสู่ระบบด้วยบัญชีร้านค้าของคุณ ",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, SellerLoginScreen.routeName);
                      },
                      child: Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(
                          color: Colors.purple.shade600,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
