import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/colors.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/provider/cart_provider.dart';
import 'package:khoi_shop/services/global_method.dart';
import 'package:khoi_shop/services/payment.dart';
import 'package:khoi_shop/screens/cart/cart_full.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'cart_empty.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/CartScreen';

  @override
  Widget build(BuildContext context) {

    

    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty?
    const Scaffold(
          body: CartEmpty()
      ): Scaffold(
        bottomSheet: checkoutSection(context, cartProvider.totalAmount),
        appBar: AppBar(
          title: Text('Items In Cart: ${cartProvider.getCartItems.length}'),
          actions: [
            IconButton(
                onPressed: (){
                  GlobalMethod.showDialogg('Are you sure', 'It \'s delete all item in cart', () => cartProvider.clearCart(), context);
                },
                icon: Icon(MyAppIcons.delete, color: Colors.red,)
            )
          ],
        ),
          body: Container(
            margin: EdgeInsets.only(bottom: 70.0),
            child: ListView.builder(
              itemCount: cartProvider.getCartItems.length,
              itemBuilder: (BuildContext ctx, int index) {
                return ChangeNotifierProvider.value(
                  value: cartProvider.getCartItems.values.toList()[index],
                  child: CartFull(
                    productId: cartProvider.getCartItems.keys.toList()[index],
                  ),
                );
              },
            ),
          )
      );
  }

  Widget checkoutSection(BuildContext context, double subTotal){
    final cartProvider = Provider.of<CartProvider>(context);
    var uuid = Uuid();
    final StripeService stripeService = StripeService();
    final FirebaseAuth auth = FirebaseAuth.instance;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5)
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      ColorsConsts.gradiendLStart,
                      ColorsConsts.gradiendLEnd
                    ],
                    stops: [0.0,0.7],
                  ),
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async{
                    bool result = await stripeService.makePayment(context,(subTotal*100).toStringAsFixed(0));
                     if(result){
                       final User? user = auth.currentUser;
                       final uid = user!.uid;
                       try{
                      final orderId = uuid.v4();
                      await FirebaseFirestore
                          .instance
                          .collection('orders')
                          .doc(orderId).set({
                        'orderId': orderId,
                        'userId': uid,
                        'orderTotal': subTotal,
                        'orderDate': Timestamp.now()
                      });
                       cartProvider.getCartItems.forEach((key, value) async{
                           await FirebaseFirestore
                               .instance
                               .collection('order_detail')
                               .doc(uuid.v4()).set({
                             'orderId': orderId,
                             'productId': value.productId,
                             'title': value.title,
                             'price': value.price,
                             'quantity': value.quantity,
                             'imageUrl': value.imageUrl,
                           });
                       });
                         }catch (e){
                           print('error is: $e');
                         }
                       cartProvider.clearCart();
                     } else{

                     }



                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Checkout',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Text(
              'Total',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18
              ),
            ),
            Text(
              'US \$${subTotal.toStringAsFixed(2)} ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 18
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
    );
  }
}
