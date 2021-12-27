import 'package:flutter/material.dart';
import 'package:khoi_shop/models/cart_attr.dart';

class CartProvider with ChangeNotifier{
  Map<String, CartAttr> _cartItems = {};

  Map<String, CartAttr> get getCartItems {
    return {..._cartItems};
  }

  double get totalAmount{
    var total = 0.0;
    _cartItems.forEach((key, value) {total += value.price*value.quantity;});
    return total;
  }

  void addProductToCart(String id, String title, double price, String imageUrl){
    if(_cartItems.containsKey(id)){
      _cartItems.update(id, (exitingCartItem) => CartAttr(
          id: exitingCartItem.id,
          productId: exitingCartItem.productId,
          title: exitingCartItem.title,
          quantity: exitingCartItem.quantity+1,
          price: exitingCartItem.price,
          imageUrl: exitingCartItem.imageUrl
        )
      );
    } else {
      _cartItems.putIfAbsent(id, () => CartAttr(
        id: DateTime.now().toString(),
        title: title,
        productId: id,
        quantity: 1,
        price: price,
        imageUrl: imageUrl
        )
      );
    }
    notifyListeners();
  }

  void reduceItemByOne(String id){
    if(_cartItems.containsKey(id)){
      _cartItems.update(id, (exitingCartItem) => CartAttr(
          id: exitingCartItem.id,
          productId: exitingCartItem.productId,
          title: exitingCartItem.title,
          quantity: exitingCartItem.quantity-1,
          price: exitingCartItem.price,
          imageUrl: exitingCartItem.imageUrl
      )
      );
    }
    notifyListeners();
  }

  void removeItem(String productId){
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearCart(){
    _cartItems.clear();
    notifyListeners();
  }
}