import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/provider/orders_provider.dart';
import 'package:khoi_shop/screens/cart/cart_empty.dart';
import 'package:provider/provider.dart';

import 'order_full.dart';


class OrderScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return FutureBuilder(
      future: ordersProvider.fetchOrders(),
      builder: (context, snapshot){
        return ordersProvider.getOrders.isEmpty ?
        const Scaffold(
            body: CartEmpty()
        ) : Scaffold(
            appBar: AppBar(
              title: Text('Orders(${ordersProvider.getOrders.length})'),
              actions: [
                IconButton(
                    onPressed: () {
                      // GlobalMethod.showDialogg(
                      //     'Are you sure', 'It \'s delete all item in cart',
                      //         () => cartProvider.clearCart(), context
                      // );
                    },
                    icon: Icon(MyAppIcons.delete, color: Colors.red,)
                )
              ],
            ),
            body: FutureBuilder(
                future: ordersProvider.fetchOrders(),
                builder: (context, snapshot) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 70.0),
                    child: ListView.builder(
                      itemCount: ordersProvider.getOrders.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return ChangeNotifierProvider.value(
                          value: ordersProvider.getOrders[index],
                          child: OrderFull(
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