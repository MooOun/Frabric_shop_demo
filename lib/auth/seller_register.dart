import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fabricshopdemo/auth/customer_login_screen.dart';
import 'package:fabricshopdemo/auth/seller_login_screen.dart';
import 'package:fabricshopdemo/auth/welcome_screen.dart';

import 'package:fabricshopdemo/utils/snackbar.dart';

class SellerRegisterScreen extends StatefulWidget {
  static const String routeName = 'SellerRegisterScreen';
  @override
  _SellerRegisterScreenState createState() => _SellerRegisterScreenState();
}

class _SellerRegisterScreenState extends State<SellerRegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _storeNameController = TextEditingController();
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
    String storeImage = await snapshot.ref.getDownloadURL();
    return storeImage;
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

          String storeImage = await uploadImageToStorage();

          await _firestore
              .collection('sellers')
              .doc(_auth.currentUser!.uid)
              .set({
            'storeName': _storeNameController.text,
            'email': _emailController.text,
            'storeImage': storeImage,
            'phone': '',
            'address': '',
            'sellerUid': _auth.currentUser!.uid,
          });
          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });

          Navigator.pushReplacementNamed(context, SellerLoginScreen.routeName);
        } else {
          setState(() {
            isLoading = false;
          });
          return ShowSnackBar(context, 'กรุณาเลือกรูปภาพของคุณ');
        }
        print(' ผิดพลาด');
      } else {
        setState(() {
          isLoading = false;
        });
        return ShowSnackBar(context, 'กรุณากรอกข้อมูลให้ครบทุกช่อง');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "รหัสผ่านอ่อนแอเกินไป") {
        setState(() {
          isLoading = false;
        });
        return ShowSnackBar(context, e.code);
      } else if (e.code == 'อีเมลมีอยู่ในระบบเเล้ว') {
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
                        "สร้างบัญชีร้านค้าของคุณ",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.shopping_cart,
                          size: 40,
                          color: Colors.purple.shade600,
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
                    controller: _storeNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกชื่อร้านค้าของคุณ';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'ชื่อร้านค้า',
                      hintText: 'กรอกชื่อร้านค้าของคุณ',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
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
                  padding: const EdgeInsets.all(10.0),
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
                      MediaQuery.of(context).size.width - 30,
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
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'คุณมีบัญชีร้านค้าอยู่เเล้ว ?',
                      style: TextStyle(
                        fontSize: 13,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "ต้องสร้างบัญชีทั่วไป ? ",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
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
