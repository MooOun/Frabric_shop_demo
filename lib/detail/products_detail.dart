import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';
import 'package:fabricshopdemo/main_screens/cart_screen.dart';
import 'package:fabricshopdemo/minor_screens/full_image_screen.dart';
import 'package:fabricshopdemo/minor_screens/visit_store_screen.dart';
import 'package:fabricshopdemo/models/product_models.dart';
import 'package:fabricshopdemo/provider/wishlist_provider.dart';
import 'package:fabricshopdemo/utils/snackbar.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../provider/cart_provider.dart';

class ProductsDetails extends StatefulWidget {
  final dynamic productList;

  const ProductsDetails({super.key, required this.productList});
  @override
  _ProductsDetailsState createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  late List<dynamic> imageList = widget.productList['productimage'];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _reviewsStream = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productList['productid'])
        .collection('reviews')
        .snapshots();

    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincategory', isEqualTo: widget.productList['maincategory'])
        .where('subcategory', isEqualTo: widget.productList['subcategory'])
        .snapshots();
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: InkWell(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Swiper(
                          pagination: SwiperPagination(
                              builder: SwiperPagination.fraction),
                          itemBuilder: (BuildContext buildContext, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return FullImageScreen(imagesList: imageList);
                                }));
                              },
                              child: Image(
                                image: NetworkImage(
                                  imageList[index],
                                ),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          itemCount: imageList.length,
                        ),
                      ),
                      Text(
                        widget.productList['productname'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row( 
                              children: [
                                Text(
                              'ราคา : \t',
                              style: TextStyle(
                                color: Colors.purple.shade600,
                                fontSize: 20,
                              ),
                            ),
                                Text(
                                  widget.productList['price'].toStringAsFixed(2),
                                  style: TextStyle(
                                    color: Colors.purple.shade500,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                              '\t\tบาท ',
                              style: TextStyle(
                                color: Colors.purple.shade600,
                                fontSize: 20,
                              ),
                            ),
                              ],
                            ),
                            widget.productList['sellerUid'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      context
                                                  .read<WishList>()
                                                  .getWishItem
                                                  .firstWhereOrNull((product) =>
                                                      product.documentId ==
                                                      widget.productList[
                                                          'productid']) !=
                                              null
                                          ? context.read<WishList>().removeThis(
                                              widget.productList['productid'])
                                          : context
                                              .read<WishList>()
                                              .addWishItem(
                                                  widget.productList[
                                                      'productname'],
                                                  widget.productList['price'],
                                                  1,
                                                  widget.productList['instock'],
                                                  widget.productList[
                                                      'productimage'],
                                                  widget
                                                      .productList['productid'],
                                                  widget.productList[
                                                      'sellerUid']);
                                    },
                                    icon: Provider.of<WishList>(context,
                                                    listen: true)
                                                .getWishItem
                                                .firstWhereOrNull((product) =>
                                                    product.documentId ==
                                                    widget.productList[
                                                        'productid']) !=
                                            null
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : Icon(Icons.favorite_border_outlined),
                                  ),
                          ],
                        ),
                      ),
                      Text(
                        '${widget.productList['instock'].toString()} ชิ้นนี้อยู่ในรายการถูกใจของคุณเเล้ว',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ProductDetailsHeaderLabel(
                        headerLabel: 'รายละเอียดสินค้า',
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '${widget.productList['productdescription'].toString()} ',
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey.shade600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      review(_reviewsStream),
                      ProductDetailsHeaderLabel(
                        headerLabel: 'สินค้าอื่นๆ',
                      ),
                      SizedBox(
                        child: SingleChildScrollView(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _productsStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('เกิดข้อผิดพลาดบางอย่าง'),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.purple.shade300,
                                  ),
                                );
                              }

                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text(
                                    'ในหมวดหมู่นี้ \n\n ไม่มีสินค้า',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.purple.shade300,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.7,
                                    ),
                                  ),
                                );
                              }

                              return StaggeredGridView.countBuilder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                crossAxisCount: 1,
                                itemBuilder: (context, index) {
                                  return ProductModel(
                                    products: snapshot.data!.docs[index],
                                  );
                                },
                                staggeredTileBuilder: (context) =>
                                    StaggeredTile.fit(1),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  Positioned(
                    top: 15,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return VisitStore(
                          sellerUid: widget.productList['sellerUid']);
                    }));
                  },
                  icon: Icon(
                    Icons.store,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CartScreen();
                    }));
                  },
                  icon: Badge(
                    showBadge: Provider.of<Cart>(context).getItems.isEmpty
                        ? false
                        : true,
                    toAnimate: true,
                    badgeColor: Colors.purple,
                    badgeContent: Text(
                      Provider.of<Cart>(context, listen: true)
                          .getItems
                          .length
                          .toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CyanButton(
                    onPressed: () {
                      context.read<Cart>().getItems.firstWhereOrNull(
                                  (product) =>
                                      product.documentId ==
                                      widget.productList['productid']) !=
                              null
                          ? ShowSnackBar(
                              context, 'สินค้าชิ้นนี้อยู่ในตระกร้าของคุณเเล้ว')
                          : context.read<Cart>().addItem(
                              widget.productList['productname'],
                              widget.productList['price'],
                              1,
                              widget.productList['instock'],
                              widget.productList['productimage'],
                              widget.productList['productid'],
                              widget.productList['sellerUid']);
                    },
                    buttonTitle: 'เพิ่มลงในตระกร้า',
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

class ProductDetailsHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const ProductDetailsHeaderLabel({
    required this.headerLabel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          width: 50,
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        Text(
          headerLabel,
          style: TextStyle(
            color: Colors.purple,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 40,
          width: 50,
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

Widget review(var _reviewsStream) {
  return ExpandablePanel(
      header: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'รีวิว',
          style: TextStyle(
            color: Colors.purple.shade500,
            fontSize: 24,
          ),
        ),
      ),
      collapsed: Text(
        'Newly uploaded',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      expanded: reviewAll(_reviewsStream));
}

Widget reviewAll(var _reviewsStream) {
  return (StreamBuilder<QuerySnapshot>(
    stream: _reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.hasError) {
        return Center(
          child: Text('เกิดข้อผิดพลาดบางอย่าง'),
        );
      }

      if (snapshot2.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.purple,
          ),
        );
      }

      if (snapshot2.data!.docs.isEmpty) {
        return Center(
          child: Text(
            'ไม่มีรีวิว \n ของสิน้คานี้',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Colors.purple.shade100,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.7,
            ),
          ),
        );
      }
      return ListView.builder(
          itemCount: snapshot2.data!.docs.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final reviews = snapshot2.data!.docs[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(reviews['profileImage']),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reviews['name'],
                  ),
                  Row(
                    children: [
                      Text(
                        reviews['rate'].toString(),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      )
                    ],
                  )
                ],
              ),
              subtitle: Text(
                reviews['comment'],
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                ),
              ),
            );
          });
    },
  ));
}
