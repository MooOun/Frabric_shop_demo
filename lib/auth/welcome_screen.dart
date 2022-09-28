import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fabricshopdemo/auth/customer_login_screen.dart';
import 'package:fabricshopdemo/auth/seller_register.dart';
import 'package:fabricshopdemo/main_screens/custormer_home_screen.dart';
import 'package:fabricshopdemo/utils/snackbar.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = 'welcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  bool isLoading = false;
  bool passwordInvisable = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  XFile? _imageFile;
  dynamic _pickedImageError;
  void _pickImageFromCamera() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 95,
      );

      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e.toString();
      });
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 95,
      );

      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
    }
  }

  uploadImageToStorage() async {
    Reference ref = _firebaseStorage
        .ref()
        .child('profilePics')
        .child('${_emailController.text}.jpg');

    UploadTask uploadTask = ref.putFile(File(_imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    String profileImage = await snapshot.ref.getDownloadURL();
    return profileImage;
  }

  void signUp() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        if (_imageFile != null) {
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

          String profileImage = await uploadImageToStorage();

          await _firestore
              .collection('customers')
              .doc(_auth.currentUser!.uid)
              .set({
            'name': _fullNameController.text,
            'email': _emailController.text,
            'profilePic': profileImage,
            'phone': '',
            'address': '',
            'cid': _auth.currentUser!.uid,
          });
          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });

          Navigator.pushReplacementNamed(
              context, CustomerLoginScreen.routeName);
        } else {
          setState(() {
            isLoading = false;
          });
          return ShowSnackBar(context, 'โปรดเลือกรูปภาพ');
        }
        print(' ผิดพลาด');
      } else {
        setState(() {
          isLoading = false;
        });
        return ShowSnackBar(context, 'กรุณากรอกให้ครบทุกช่อง');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "รหัสผ่านอ่อนแอเกินไป") {
        setState(() {
          isLoading = false;
        });
        return ShowSnackBar(context, e.code);
      } else if (e.code == 'อิีเมลลนี้มีผู้ใช้งานอยู่เเล้ว') {
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
                        "สร้างบัญชีผู้ใช้งาน",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.person,
                          size: 40,
                          color: Colors.purple.shade300,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 40,
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.purple.shade500,
                        backgroundImage: _imageFile == null
                            ? null
                            : FileImage(File(_imageFile!.path)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.purple.shade600,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(
                                      15,
                                    ))),
                            child: IconButton(
                              onPressed: _pickImageFromCamera,
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.purple.shade600,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(
                                      15,
                                    ))),
                            child: IconButton(
                              onPressed: _pickImageFromGallery,
                              icon: Icon(
                                Icons.photo,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _fullNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณาใส่ชื่อของคุณ';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'ชื่อ - นามสกุล',
                      hintText: 'กรอกชื่อเเละนามสกุล',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณาใส่อีเมลที่ถูกต้อง';
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
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณาใส่รหัสผ่านของคุณ';
                      } else {
                        return null;
                      }
                    },
                    obscureText: passwordInvisable,
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      hintText: 'กรอกรหัสผ่านของคุณ',
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
                    signUp();
                  },
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'สมัครสมาชิก',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'มีบัญชีผู้ใช้งานอยู่เเล้วใช่ไหม ?',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, CustomerLoginScreen.routeName);
                        },
                        child: Text(
                          'เข้าสู่ระบบ',
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
                      "สร้างบัญชีร้านค้าของคุณ ? ",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, SellerRegisterScreen.routeName);
                      },
                      child: Text(
                        'สร้างบัญชี',
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
