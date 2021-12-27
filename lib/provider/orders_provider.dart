import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/models/order_attr.dart';

class OrdersProvider with ChangeNotifier {
  List<OrdersAttr> _orders = [];
  List<OrdersAttr> get getOrders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? _user = _auth.currentUser;
    var _uid = _user!.uid;
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: _uid)
          .get()
          .then((QuerySnapshot ordersSnapshot) {
        _orders.clear();
        ordersSnapshot.docs.forEach((element) {
          _orders.add(
              OrdersAttr(
                orderId: element.get('orderId'),
                userId: element.get('userId'),
                orderTotal: element.get('orderTotal').toString(),
                orderDate: element.get('orderDate'),
              ));
        });
      });
    } catch (error) {
      print('Printing error wwhile fetching order $error');
    }
    notifyListeners();
  }
}