import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/inner_screens/product_detail.dart';
import 'package:khoi_shop/models/product.dart';
import 'package:khoi_shop/screens/update_product_form.dart';
import 'package:khoi_shop/services/global_method.dart';
import 'package:provider/provider.dart';

import 'feeds_dialog.dart';

class FeedsProduct extends StatefulWidget {
  @override
  _FeedsProductState createState() => _FeedsProductState();
}

class _FeedsProductState extends State<FeedsProduct> {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _uid;
  String _role = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    setState(() {
      _role = userDoc.get('role');
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsAttribute = Provider.of<Product>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: productsAttribute.id);
        },
        child: Container(
          width: 250,
          height: 290,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Theme.of(context).backgroundColor,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                        width: double.infinity,
                        height: 190,
                        child: Image.network(
                          productsAttribute.imageUrl,
                          fit: BoxFit.contain,
                        )),
                  ),
                  Badge(
                    toAnimate: true,
                    shape: BadgeShape.square,
                    badgeColor: Colors.pink,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(8)),
                    badgeContent:
                        Text('New', style: TextStyle(color: Colors.white)),
                  ),
                  _role == 'admin'? Positioned(
                    right: 35,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () {
                          Navigator.pushNamed(context, UpdateProductForm.routeName,
                              arguments: productsAttribute.id);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Icon(
                                  MyAppIcons.update,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                        ),
                      ),
                    ),
                  ): Container(),
                  _role == 'admin'? Positioned(
                    right: 5,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () {
                          GlobalMethod.showDialogg(
                              'Are you sure', 'It \'s delete this product',
                                  () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(productsAttribute.id)
                                    .delete();
                                setState(() {
                                  isLoading = false;
                                });
                              }, context);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Icon(
                            MyAppIcons.times,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ): Container()
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                margin: EdgeInsets.only(left: 5, bottom: 2, right: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      productsAttribute.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '\$${productsAttribute.price}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity: ${productsAttribute.quantity}',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => FeedDialog(
                                        productId: productsAttribute.id,
                                      ));
                            },
                            borderRadius: BorderRadius.circular(18.0),
                            child: Icon(
                              MyAppIcons.ellipsisH,
                              color: Colors.grey,
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
    );
  }
}
