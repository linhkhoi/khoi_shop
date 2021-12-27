import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/provider/order_detail_provider.dart';
import 'package:khoi_shop/provider/orders_provider.dart';
import 'package:khoi_shop/screens/cart/cart_empty.dart';
import 'package:provider/provider.dart';

import 'order_detail_full.dart';



class OrderDetailScreen extends StatelessWidget {
  static const routeName = '/OrderDetailScreen';

  @override
  Widget build(BuildContext context) {
    final orderDetailsProvider = Provider.of<OrderDetailsProvider>(context);
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder(
      future: orderDetailsProvider.fetchOrderDetails(orderId),
      builder: (context, snapshot){
        return orderDetailsProvider.getOrderDetails.isEmpty ?
        const Scaffold(
            body: CartEmpty()
        ) : Scaffold(
            appBar: AppBar(
              title: Text('Orders detail(${orderDetailsProvider.getOrderDetails.length})'),
            ),
            body: FutureBuilder(
                future: orderDetailsProvider.fetchOrderDetails(orderId),
                builder: (context, snapshot) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 70.0),
                    child: ListView.builder(
                      itemCount: orderDetailsProvider.getOrderDetails.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return ChangeNotifierProvider.value(
                          value: orderDetailsProvider.getOrderDetails[index],
                          child: OrderDetailFull(
                          ),
                        );
                      },
                    ),
                  );
                }
            )
        );
      },
    );
  }
}