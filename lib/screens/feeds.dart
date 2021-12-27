import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/colors.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/models/product.dart';
import 'package:khoi_shop/provider/cart_provider.dart';
import 'package:khoi_shop/provider/favs_provider.dart';
import 'package:khoi_shop/provider/products.dart';
import 'package:khoi_shop/screens/cart/cart.dart';
import 'package:khoi_shop/screens/upload_product_form.dart';
import 'package:khoi_shop/screens/wishlist/wishlist.dart';
import 'package:khoi_shop/widgets/feeds_product.dart';
import 'package:provider/provider.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = '/Feeds';

  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {

  Future<void> _getProductsOnRefresh() async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {

    final popular = ModalRoute.of(context)!.settings.arguments ;
    final productProvider = Provider.of<Products>(context);
    productProvider.fetchProducts();
    List<Product> productList = productProvider.products;

    if(popular=='popular'){
      productList = productProvider.popularProducts;
    }

    final cartProvider = Provider.of<CartProvider>(context);
    final favsProvider = Provider.of<FavsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Feeds', style: TextStyle(color: Theme.of(context).textSelectionColor),),
        actions: [
          Consumer<FavsProvider>(
            builder: (_, favs, ch)=> Badge(
              badgeColor: ColorsConsts.cartBadgeColor,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 5, end: 7),
              badgeContent: Text(favsProvider.getFavsItems.length.toString(),
                style: TextStyle(color: Colors.white),),
              child: IconButton(
                icon: Icon(
                  MyAppIcons.wishlist,
                  color: ColorsConsts.favColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(WishlistScreen.routeName);
                },
              ),
            ),
          ),
          Consumer<CartProvider>(
            builder: (_, cart, ch)=> Badge(
              badgeColor: ColorsConsts.cartBadgeColor,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              position: BadgePosition.topEnd(top: 5, end: 7),
              badgeContent: Text(cartProvider.getCartItems.length.toString(),
                style: TextStyle(color: Colors.white),),
              child: IconButton(
                icon: Icon(
                  MyAppIcons.cart,
                  color: ColorsConsts.cartColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ),
          IconButton(
              icon: Icon(
                MyAppIcons.upload,
                color: ColorsConsts.cartColor,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(UploadProductForm.routeName);
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _getProductsOnRefresh,
        child: GridView.count(
          childAspectRatio: 240/420,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          crossAxisCount: 2,
          children: List.generate(productList.length, (index) {
            return ChangeNotifierProvider.value(
              value: productList[index],
              child: FeedsProduct(
              ),
            );
          }),
        ),
      ),
    );
  }
}

