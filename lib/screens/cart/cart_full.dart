import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/colors.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/inner_screens/product_detail.dart';
import 'package:khoi_shop/models/cart_attr.dart';
import 'package:khoi_shop/provider/cart_provider.dart';
import 'package:khoi_shop/provider/dark_theme_provider.dart';
import 'package:khoi_shop/services/global_method.dart';
import 'package:khoi_shop/services/payment.dart';
import 'package:provider/provider.dart';

class CartFull extends StatefulWidget {

  final String productId;

  CartFull({required this.productId});

  @override
  _CartFullState createState() => _CartFullState();
}

class _CartFullState extends State<CartFull> {

  @override
  Widget build(BuildContext context) {

    final themeChane = Provider.of<DarkThemeProvider>(context);
    final cartAttr = Provider.of<CartAttr>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    double subTotal = cartAttr.price * cartAttr.quantity;
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, ProductDetails.routeName, arguments: widget.productId);
      },
      child: Container(
        height: 135,
        margin: const EdgeInsets.all(10),
        decoration:  BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(16.0),
              topRight: Radius.circular(16.0)
          ),
          color: Theme.of(context).backgroundColor
        ),
        child: Row(
          children: [
            Container(
              width: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(cartAttr.imageUrl),
                  fit: BoxFit.contain
                )
              ),
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
                            cartAttr.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                            onTap: (){
                              GlobalMethod.showDialogg('Are you sure', 'It \'s delete all', () => cartProvider.removeItem(widget.productId), context);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Icon(MyAppIcons.times, color: Colors.red,size: 22,),
                            ),
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    Row(
                      children: [
                        Text('Price: '),
                        SizedBox(width: 5.0,),
                        Text(
                          '${cartAttr.price}\$ ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text('Sub Total: '),
                        SizedBox(width: 5.0,),
                        Text(
                          '${subTotal.toStringAsFixed(2)} \$',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            color: themeChane.darkTheme? Colors.brown.shade900: Theme.of(context).accentColor
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Free Ship',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: themeChane.darkTheme? Colors.brown.shade900: Theme.of(context).accentColor
                          ),
                        ),
                        Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4.0),
                            onTap: (){
                              cartAttr.quantity < 2 ? GlobalMethod.showDialogg('Are you sure', 'It \'s delete all', () => cartProvider.removeItem(widget.productId), context)
                              : cartProvider.reduceItemByOne(widget.productId);
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(MyAppIcons.minus, color: Colors.red,size: 22,),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 12,
                          color: Colors.transparent,
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.12,
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  ColorsConsts.gradiendLStart,
                                  ColorsConsts.gradiendLEnd
                                ],
                                stops: [0.0,0.7],
                              ),
                            ),
                            child: Text(cartAttr.quantity.toString(), textAlign: TextAlign.center,),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4.0),
                            onTap: (){
                              cartProvider.addProductToCart(widget.productId, cartAttr.title, cartAttr.price, cartAttr.imageUrl);
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(MyAppIcons.plus, color: Colors.green,size: 22,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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
