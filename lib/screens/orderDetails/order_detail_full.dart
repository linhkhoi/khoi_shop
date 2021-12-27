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
import 'package:khoi_shop/services/global_method.dart';
import 'package:khoi_shop/services/payment.dart';
import 'package:provider/provider.dart';

class OrderDetailFull extends StatefulWidget {

  @override
  _OrderDetailFullState createState() => _OrderDetailFullState();
}

class _OrderDetailFullState extends State<OrderDetailFull> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    final orderDetailAttr = Provider.of<OrderDetailAttr>(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: orderDetailAttr.productId);
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
            Container(
              width: 130,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          orderDetailAttr.imageUrl),
                      fit: BoxFit.contain)),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            orderDetailAttr.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    Row(
                      children: [
                        Text('Price: '),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${orderDetailAttr.price}\$',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text('Quantity:'),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          orderDetailAttr.quantity,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(child: Text('Order Id:')),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Text(
                            orderDetailAttr.orderId,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
                          ),
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
