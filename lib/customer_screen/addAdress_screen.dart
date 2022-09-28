import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fabricshopdemo/main_screens/cart_screen.dart';
import 'package:fabricshopdemo/utils/snackbar.dart';
import 'package:uuid/uuid.dart';

class AddAdressScreen extends StatefulWidget {
  @override
  _AddAdressState createState() => _AddAdressState();
}

class _AddAdressState extends State<AddAdressScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String phone;
  late String countryValue = 'Choose Country';
  late String stateValue = 'Choose State';
  late String cityValue = 'Choose State';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มที่อยู่ในการจัดส่ง',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'กรุณากรอกชื่อจริงของคุณ';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'ชื่อจริงของคุณ',
                          hintText: 'กรอกชื่อจริงของคุณ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              25,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          firstName = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'กรุณากรอกนามสกุลของคุณ';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'นามสกุลของคุณ',
                          hintText: 'กรอกนามสกุลของคุณ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              25,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          lastName = value!;
                        },
                      ),
                    ),SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'กรุณากรอกเบอร์ติดต่อของคุณ';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'เบอร์โทรศัพท์',
                          hintText: 'กรอกเบอร์โทรศัพท์ของคุณ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              25,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          phone = value!;
                        },
                      ),
                    ),SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                SelectState(
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                ),
                Center(
                  child: CyanButton(
                    buttonTitle: 'เพิ่มที่อยู่ของคุณ',
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        if (countryValue != 'choose Country' &&
                            stateValue != 'Choose State' &&
                            cityValue != 'Choose City') {
                          _formkey.currentState!.save();

                          CollectionReference addressRef = FirebaseFirestore
                              .instance
                              .collection('customers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('address');

                          final addressId = Uuid().v4();

                          await addressRef.doc(addressId).set({
                            'addressId': addressId,
                            'firstName': firstName,
                            'lastName': lastName,
                            'phoneNumber': phone,
                            'countryName': countryValue,
                            'StateName': stateValue,
                            'cityName': cityValue,
                            'default': true,
                          }).whenComplete(() {
                            Navigator.pop(context);
                          });
                        } else {
                          ShowSnackBar(
                              context, 'กรุณากรอกที่อยู่ให้ครบทุกช่อง');
                        }
                      } else {
                        ShowSnackBar(
                            context, 'กรุณากรอกที่อยู่ให้ครบทุกช่อง');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
