import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fabricshopdemo/provider/wishlist_provider.dart';

import '../provider/cart_provider.dart';

class WishListScreen extends StatelessWidget {
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
          'Wishlist',
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
      body: context.watch<WishList>().getWishItem.isNotEmpty
          ? WishListItems()
          : CartEmpty(),
    );
  }
}

class CartEmpty extends StatelessWidget {
  const CartEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'คุณไม่มีรายการที่ถูกใจ',
            style: TextStyle(
              fontSize: 30,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class WishListItems extends StatelessWidget {
  const WishListItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WishList>(
      builder: (context, wish, child) {
        return ListView.builder(
            itemCount: wish.count,
            itemBuilder: (context, index) {
              final product = wish.getWishItem[index];
              return Card(
                child: SizedBox(
                  height: 100,
                  child: Row(children: [
                    SizedBox(
                      height: 100,
                      width: 120,
                      child: Image.network(
                          wish.getWishItem[index].imagesUrl.first.toString()),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            wish.getWishItem[index].name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                product.price.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                              Text('\tบาท'),
                              Row( mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<WishList>()
                                          .removeItem(product);
                                    },
                                    icon: Icon(
                                      Icons.delete_forever,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.add_shopping_cart,
                                    ),
                                  ),
                                ],
                              )
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
