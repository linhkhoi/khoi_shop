import 'package:backdrop/app_bar.dart';
import 'package:backdrop/backdrop.dart';
import 'package:backdrop/scaffold.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/colors.dart';
import 'package:khoi_shop/inner_screens/brands_navigation_rail.dart';
import 'package:khoi_shop/provider/products.dart';
import 'package:khoi_shop/screens/feeds.dart';
import 'package:khoi_shop/widgets/backlayer.dart';
import 'package:khoi_shop/widgets/carousel.dart';
import 'package:khoi_shop/widgets/category.dart';
import 'package:khoi_shop/widgets/popular_product.dart';
import 'package:khoi_shop/widgets/swiper_brands.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    productsData.fetchProducts();
    final popularItems = productsData.popularProducts;
    return Scaffold(
      body: Center(
        child: BackdropScaffold(
            headerHeight: MediaQuery.of(context).size.height*0.25,
            appBar: BackdropAppBar(
              title: Text("Home"),
              leading: BackdropToggleButton(
                icon: AnimatedIcons.menu_home,
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [ColorsConsts.starterColor,ColorsConsts.endColor]
                    )
                ),
              ),
              actions: <Widget>[
                IconButton(
                    iconSize: 15,
                    padding: EdgeInsets.all(10),
                    onPressed: (){},
                    icon: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundImage: NetworkImage('https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                      ),
                    )
                )
              ],
            ),
            backLayer: BackLayerMenu(),
            frontLayer: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselWidget(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext ctx, int index){
                          return CategoryWidget(index);
                        },
                      itemCount: 7,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Popular Brands',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20
                          ),
                        ),
                        Spacer(),
                        FlatButton(
                            onPressed: (){
                              Navigator.of(context).pushNamed(
                                  BrandNavigationRailScreen.routeName,
                                  arguments: {
                                  7,
                                  },);
                            },
                            child: Text(
                              'View all...',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                color: Colors.red
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  SwiperBrands(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Popular Products',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20
                          ),
                        ),
                        Spacer(),
                        FlatButton(
                            onPressed: (){
                              Navigator.pushNamed(context, FeedsScreen.routeName, arguments: 'popular');
                            },
                            child: Text(
                              'View all...',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: Colors.red
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 285,
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularItems.length,
                      itemBuilder: (BuildContext ctx, int index){
                        return ChangeNotifierProvider.value(
                          value: popularItems[index],
                          child: PopularProduct(
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}



