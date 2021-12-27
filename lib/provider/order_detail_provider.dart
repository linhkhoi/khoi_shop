import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/models/order_attr.dart';
import 'package:khoi_shop/models/order_detail_attr.dart';

class OrderDetailsProvider with ChangeNotifier {
  List<OrderDetailAttr> _orderDetails = [];
  List<OrderDetailAttr> get getOrderDetails {
    return [..._orderDetails];
  }

  Future<void> fetchOrderDetails(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('order_detail')
          .where('orderId', isEqualTo: orderId)
          .get()
          .then((QuerySnapshot ordersSnapshot) {
        _orderDetails.clear();
        ordersSnapshot.docs.forEach((element) {
          _orderDetails.add(OrderDetailAttr(
            orderId: element.get('orderId'),
            productId: element.get('productId'),
            title: element.get('title'),
            price: element.get('price').toString(),
            quantity: element.get('quantity').toString(),
            imageUrl: element.get('imageUrl'),
          ));
        });
      });
    } catch (error) {
      print('Printing error wwhile fetching order $error');
    }
    notifyListeners();
  }
}
