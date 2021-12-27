import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/inner_screens/product_detail.dart';
import 'package:khoi_shop/models/product.dart';
import 'package:khoi_shop/provider/cart_provider.dart';
import 'package:khoi_shop/provider/favs_provider.dart';
import 'package:provider/provider.dart';

class PopularProduct extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productsAttribute = Provider.of<Product>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favsProvider = Provider.of<FavsProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)
          )
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)
            ),
            onTap: (){
              Navigator.pushNamed(context, ProductDetails.routeName, arguments: productsAttribute.id);
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(productsAttribute.imageUrl),
                          fit: BoxFit.contain
                        )
                      ),
                    ),
                    Positioned(
                      right: 12,
                        top: 12,
                        child: Icon(MyAppIcons.star,
                          color: favsProvider.getFavsItems.containsKey(productsAttribute.id)
                              ? Colors.red
                              :Colors.grey.shade800,
                          size: 17,
                        )
                    ),
                    Positioned(
                        right: 6,
                        top: 7,
                        child: Icon(MyAppIcons.starOutline, color: Colors.white,
                        size: 26,)
                    ),
                    Positioned(
                      right: 12,
                      bottom: 32,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Theme.of(context).backgroundColor,
                        child: Text(
                          '\$ ${productsAttribute.price}',
                          style: TextStyle(
                            color: Theme.of(context).textSelectionColor
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productsAttribute.title,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              productsAttribute.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            flex: 5,
                          ),
                          Spacer(),
                          Expanded(
                            flex: 1,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: (){
                                  cartProvider.getCartItems.containsKey(productsAttribute.id)? (){} :
                                  cartProvider.addProductToCart(productsAttribute.id, productsAttribute.title, productsAttribute.price, productsAttribute.imageUrl);
                                },
                                borderRadius: BorderRadius.circular(30.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: cartProvider.getCartItems.containsKey(productsAttribute.id)?Icon(MyAppIcons.checkDouble,
                                  size: 25,
                                  color: Colors.black,): Icon(MyAppIcons.cartPlus,
                                    size: 25,
                                    color: Colors.black,),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
