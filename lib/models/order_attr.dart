import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersAttr with ChangeNotifier {
  final String orderId;
  final String userId;
  final String orderTotal;
  final Timestamp orderDate;

  OrdersAttr( {required this.orderId, required this.userId,required this.orderTotal,
     required this.orderDate});
}
