import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/product_models.dart';

class SubCategoryProducts extends StatelessWidget {
  final String subCategoryName;
  final String menCategoryName;

  const SubCategoryProducts(
      {super.key,
      required this.subCategoryName,
      required this.menCategoryName});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('subcategory', isEqualTo: subCategoryName)
        .where('maincategory', isEqualTo: menCategoryName)
        .snapshots();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            subCategoryName,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _productsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.purple.shade500,
                ),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'This Category \n\n has no items yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.purple.shade500,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.7,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: StaggeredGridView.countBuilder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                crossAxisCount: 1,
                itemBuilder: (context, index) {
                  return ProductModel(
                    products: snapshot.data!.docs[index],
                  );
                },
                staggeredTileBuilder: (context) => StaggeredTile.fit(1),
              ),
            );
          },
        ));
  }
}
