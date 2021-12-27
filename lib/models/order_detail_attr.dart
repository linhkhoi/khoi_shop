import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailAttr with ChangeNotifier {
  final String orderId;
  final String productId;
  final String title;
  final String price;
  final String quantity;
  final String imageUrl;

  OrderDetailAttr(  {required this.orderId, required this.productId,required this.title,
    required this.price, required this.quantity, required this.imageUrl,});
}
