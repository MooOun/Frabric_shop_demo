import 'package:fabricshopdemo/auth/customer_login_screen.dart';
import 'package:fabricshopdemo/auth/seller_register.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fabricshopdemo/auth/welcome_screen.dart';

import 'package:fabricshopdemo/main_screens/supplier_home.dart';
import 'package:fabricshopdemo/utils/snackbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SellerLoginScreen extends StatefulWidget {
  static const String routeName = 'SellerLoginScreen';
  @override
  _SellerLoginScreenState createState() => _SellerLoginScreenState();
}

class _SellerLoginScreenState extends State<SellerLoginScreen> {
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

        Navigator.pushReplacementNamed(context, SupplierHome.routeName);
      } else {
        setState(() {
          isLoading = false;
        });
        return ShowSnackBar(context, 'กรุณากรอกข้อมูลให้ครบทุกช่อง');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "ไม่มีบัญชีผู้ใช้นี้ในระบบ") {
        setState(() {
          isLoading = false;
        });
        return ShowSnackBar(context, e.code);
      } else if (e.code == 'บัญชีผู้ใช้หรือรหัสผ่านผิดพลาด') {
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
                        "ลงชื่อเข้าใช้งานบัญชีร้านค้า",
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกอีเมลของคุณ !';
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
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกรหัสผ่านของคุณ !';
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
                              : Icons.visibility, color: Colors.purple.shade600,
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
                      MediaQuery.of(context).size.width - 30,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'สมัครสมาชิกทั่วไป ?',
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
                      ),
                    ),
                  ],
                ),
                Text(
                      'หรือ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "เข้าสู่ระบบด้วยบัญชีทั่วไป ",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
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
                        ),
                      ),
                    ),
                  ],
                ),  SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    minimumSize: Size(double.infinity,50),
                    elevation: 0
                  ),
                  icon: FaIcon(FontAwesomeIcons.google , color: Colors.red,),
                  onPressed: () {},
                  label: Text('Login With Google'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    minimumSize: Size(double.infinity,50),
                    elevation: 0
                  ),
                  icon: FaIcon(FontAwesomeIcons.facebook , color: Colors.blue,),
                  onPressed: () {},
                  label: Text('Login With Facebook'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
