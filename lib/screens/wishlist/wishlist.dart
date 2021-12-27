import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/provider/favs_provider.dart';
import 'package:khoi_shop/screens/wishlist/wishlist_empty.dart';
import 'package:khoi_shop/screens/wishlist/wishlist_full.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/WishlistScreen';

  @override
  Widget build(BuildContext context) {
    final favsProvider = Provider.of<FavsProvider>(context);

    return favsProvider.getFavsItems.isEmpty? Scaffold(
          body: WishlistEmpty()
      ): Scaffold(
    appBar: AppBar(
    title: Text('Wishlist (${favsProvider.getFavsItems.length})'),
    ),
    body: ListView.builder(
    itemCount: favsProvider.getFavsItems.length,
    itemBuilder: (BuildContext ctx, int index) {
    return ChangeNotifierProvider.value(
      value: favsProvider.getFavsItems.values.toList()[index],
        child: WishlistFull(productId: favsProvider.getFavsItems.keys.toList()[index],)
    );
    },
    ));
  }
}
