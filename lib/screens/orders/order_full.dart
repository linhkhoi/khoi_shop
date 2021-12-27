import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/colors.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/inner_screens/product_detail.dart';
import 'package:khoi_shop/models/cart_attr.dart';
import 'package:khoi_shop/models/order_attr.dart';
import 'package:khoi_shop/models/order_detail_attr.dart';
import 'package:khoi_shop/provider/cart_provider.dart';
import 'package:khoi_shop/provider/dark_theme_provider.dart';
import 'package:khoi_shop/screens/orderDetails/order_detail.dart';
import 'package:khoi_shop/services/global_method.dart';
import 'package:khoi_shop/services/payment.dart';
import 'package:provider/provider.dart';

class OrderFull extends StatefulWidget {

  @override
  _OrderFullState createState() => _OrderFullState();
}

class _OrderFullState extends State<OrderFull> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    final ordersAttr = Provider.of<OrdersAttr>(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, OrderDetailScreen.routeName,
            arguments: ordersAttr.orderId);
      },
      child: Container(
        height: 135,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(16.0),
                topRight: Radius.circular(16.0)),
            color: Theme.of(context).backgroundColor),
        child: Row(
          children: [
            // Container(
            //   width: 130,
            //   decoration: BoxDecoration(
            //       image: DecorationImage(
            //           image: NetworkImage(
            //               ordersAttr.imageUrl),
            //           fit: BoxFit.contain)),
            // ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            ordersAttr.orderId,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16.0),
                            onTap: () {
                              GlobalMethod.showDialogg(
                                  'Are you sure',
                                  'It \'s delete all',
                                  () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                   await FirebaseFirestore.instance.collection('orders')
                                      .doc(ordersAttr.orderId).delete();
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }, context);

                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: isLoading?CircularProgressIndicator(): Icon(
                                MyAppIcons.times,
                                color: Colors.red,
                                size: 22,
                              ),
                            ),
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    Row(
                      children: [
                        Text('Order Total: '),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${ordersAttr.orderTotal}\$',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(child: Text('Order Date:')),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          ordersAttr.orderDate.toDate().toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
