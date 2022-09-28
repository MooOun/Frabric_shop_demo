import 'package:fabricshopdemo/models/products.dart';
import 'package:flutter/material.dart';


class WishList extends ChangeNotifier {
  final List<Product> _list = [];

  List<Product> get getWishItem {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  Future<void> addWishItem(
    String name,
    double price,
    int quantity,
    int inStock,
    List imagesUrl,
    String documentId,
    String sellerUid,
  ) async {
    final products = Product(
        name: name,
        price: price,
        quantity: quantity,
        inStock: inStock,
        imagesUrl: imagesUrl,
        documentId: documentId,
        sellerUid: sellerUid);

    _list.add(products);

    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWishList() {
    _list.clear();

    notifyListeners();
  }

  removeThis(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }
}
