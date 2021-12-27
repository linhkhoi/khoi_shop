import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:khoi_shop/consts/theme_data.dart';
import 'package:khoi_shop/inner_screens/brands_navigation_rail.dart';
import 'package:khoi_shop/inner_screens/category_feeds.dart';
import 'package:khoi_shop/inner_screens/product_detail.dart';
import 'package:khoi_shop/provider/order_detail_provider.dart';
import 'package:khoi_shop/provider/orders_provider.dart';
import 'package:khoi_shop/screens/admin/chart_screen.dart';
import 'package:khoi_shop/screens/forget_password.dart';
import 'package:khoi_shop/screens/orderDetails/order_detail.dart';
import 'package:khoi_shop/screens/orders/order.dart';
import 'package:khoi_shop/screens/update_product_form.dart';
import 'package:khoi_shop/screens/upload_product_form.dart';
import 'package:khoi_shop/provider/cart_provider.dart';
import 'package:khoi_shop/provider/dark_theme_provider.dart';
import 'package:khoi_shop/provider/favs_provider.dart';
import 'package:khoi_shop/provider/products.dart';
import 'package:khoi_shop/screens/auth/login.dart';
import 'package:khoi_shop/screens/auth/sign_up.dart';
import 'package:khoi_shop/screens/cart/cart.dart';
import 'package:khoi_shop/screens/feeds.dart';
import 'package:khoi_shop/screens/landing_page.dart';
import 'package:khoi_shop/screens/main_screen.dart';
import 'package:khoi_shop/screens/user_state.dart';
import 'package:khoi_shop/screens/wishlist/wishlist.dart';
import 'package:provider/provider.dart';

import 'bottom_bar.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51HyKMUIbLkWdqIr136PgqL3H2WmrZGBMUPccr8t3dbekCp24NCawyk4ufIztrJQCD1hOYpOWhY4DeqgehIygs6Tg00a9BeTFdy';
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themChangeProvider = DarkThemeProvider();



  void getCurrentAppTheme() async{
    themChangeProvider.darkTheme = await themChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError){
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error occured'),
              ),
            ),
          );
        }
        return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themChangeProvider;
              }),
              ChangeNotifierProvider(create: (_) {
                return Products();
              }),
              ChangeNotifierProvider(create: (_) {
                return CartProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return FavsProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return OrdersProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return OrderDetailsProvider();
              }),
            ],
            child: Consumer<DarkThemeProvider>(builder: (context, themeData, child) {
              return MaterialApp(
                title: 'Flutter Demo',
                theme: Styles.themeData(themChangeProvider.darkTheme, context),
                home: UserState(),
                routes:  {
                  //   '/': (ctx) => LandingPage(),
                  BrandNavigationRailScreen.routeName: (ctx) =>
                      BrandNavigationRailScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  FeedsScreen.routeName: (ctx) => FeedsScreen(),
                  WishlistScreen.routeName: (ctx) => WishlistScreen(),
                  ProductDetails.routeName: (ctx) => ProductDetails(),
                  CategoryFeedsScreen.routeName: (ctx)=> CategoryFeedsScreen(),
                  LoginScreen.routeName: (ctx)=> LoginScreen(),
                  SignUpScreen.routeName: (ctx)=> SignUpScreen(),
                  BottomBarScreen.routeName: (ctx)=> BottomBarScreen(),
                  UploadProductForm.routeName:(ctx)=> UploadProductForm(),
                  ForgetPassword.routeName:(ctx)=> ForgetPassword(),
                  OrderScreen.routeName:(ctx)=> OrderScreen(),
                  OrderDetailScreen.routeName:(ctx)=> OrderDetailScreen(),
                  ChartScreen.routeName:(ctx)=> ChartScreen(),
                  UpdateProductForm.routeName:(ctx)=> UpdateProductForm()
                },
                debugShowCheckedModeBanner: false,
              );
            }));
      }
    );
  }
}

