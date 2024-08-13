import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  int get cartItemCount {
    int count = 0;
    for (var item in _cartItems) {
      count += item['quantity'] as int; // Cast quantity to int
    }
    return count;
  }

  void addItem(Map<String, dynamic> product, int quantity) {
    int index = _cartItems.indexWhere((item) =>
        item['product']['productName'] == product['productName'] &&
        item['product']['vendorId'] ==
            product['vendorId']); // Check vendorId as well
    if (index != -1) {
      _cartItems[index]['quantity'] =
          (_cartItems[index]['quantity'] as int) + quantity;
    } else {
      _cartItems.add({'product': product, 'quantity': quantity});
    }
    notifyListeners();
  }

  void updateItemQuantity(Map<String, dynamic> product, int quantity) {
    int index = _cartItems.indexWhere((item) =>
        item['product']['productName'] == product['productName'] &&
        item['product']['vendorId'] ==
            product['vendorId']); // Check vendorId as well
    if (index != -1) {
      _cartItems[index]['quantity'] = quantity;
      notifyListeners();
    }
  }

  void removeItem(Map<String, dynamic> product) {
    _cartItems.removeWhere((item) =>
        item['product']['productName'] == product['productName'] &&
        item['product']['vendorId'] ==
            product['vendorId']); // Check vendorId as well
    notifyListeners();
  }

  // Method to clear the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
