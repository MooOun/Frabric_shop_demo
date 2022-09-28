import 'package:fabricshopdemo/models/products.dart';
import 'package:flutter/material.dart';


class Cart extends ChangeNotifier {
  final List<Product> _list = [];

  List<Product> get getItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;

    for (var item in _list) {
      total += item.price * item.quantity;
    }
    return total;
  }

  int? get count {
    return _list.length;
  }

  void addItem(
    String name,
    double price,
    int quantity,
    int inStock,
    List imagesUrl,
    String documentId,
    String sellerUid,
  ) {
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

  void increament(Product product) {
    product.increaseCart();
    notifyListeners();
  }

  void decreament(Product product) {
    product.decreaseCart();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();

    notifyListeners();
  }
}
