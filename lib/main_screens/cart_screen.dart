import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fabricshopdemo/main_screens/custormer_home_screen.dart';
import 'package:fabricshopdemo/minor_screens/place_order_screen.dart';

import '../provider/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          'ตระกร้าสินค้า',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<Cart>().clearCart();
            },
            icon: Icon(
              Icons.delete_forever,
              color: Colors.black,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Provider.of<Cart>(context, listen: true).getItems.isNotEmpty
          ? Consumer<Cart>(
              builder: (context, cart, child) {
                return ListView.builder(
                    itemCount: cart.count,
                    itemBuilder: (context, index) {
                      final product = cart.getItems[index];
                      return Card(
                        child: SizedBox(
                          height: 140,
                          child: Row(children: [
                            SizedBox(
                              height: 100,
                              width: 120,
                              child: Image.network(cart
                                  .getItems[index].imagesUrl.first
                                  .toString()),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    cart.getItems[index].name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            product.price.toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.purple,
                                            ),
                                          ),
                                          Text('\t\tบาท', style: TextStyle(fontSize: 12),),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 35,
                                            
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                            child: Row(
                                              
                                              children: [
                                                product.quantity == 1
                                                    ? IconButton(
                                                        onPressed: () {
                                                          cart.removeItem(product);
                                                        },
                                                        icon: Icon(
                                                          FontAwesomeIcons.minus,
                                                          color: Colors.red,
                                                        ),
                                                      )
                                                    : IconButton(
                                                        onPressed: () {
                                                          cart.decreament(product);
                                                        },
                                                        icon: Icon(
                                                          FontAwesomeIcons.minus,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${product.quantity}',
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                IconButton(
                                                  onPressed: product.quantity ==
                                                          product.inStock
                                                      ? null
                                                      : () {
                                                          cart.increament(product);
                                                        },
                                                  icon: Icon(
                                                    FontAwesomeIcons.plus,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ]),
                        ),
                      );
                    });
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ขณะนี้ตระกร้าของคุณ',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'ไม่มีสินค้า !',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CyanButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return CustomHomeScreen();
                      }));
                    },
                    buttonTitle: 'เลือกซื้อสินค้าต่อไป',
                  )
                ],
              ),
            ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'ราคารวม : ',
            style: TextStyle(
              fontSize: 13,
            ),
          ),
          Text(
            Provider.of<Cart>(context, listen: true)
                .totalPrice
                .toStringAsFixed(2),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade500,
            ),
          ),
          Text('บาท' , style: TextStyle(fontSize: 18),),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.2, 35)),
                onPressed: Provider.of<Cart>(context, listen: true) == 0.0
                    ? null
                    : () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PlaceOrder();
                        }));
                      },
                child: Text(
                  'ชำระเงิน ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CyanButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onPressed;
  const CyanButton({
    required this.buttonTitle,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.purple.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: Size(MediaQuery.of(context).size.width * 0.6, 50)),
      onPressed: onPressed,
      child: Text(
        buttonTitle,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
    );
  }
}
