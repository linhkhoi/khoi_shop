import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/models/product.dart';
import 'package:khoi_shop/provider/products.dart';
import 'package:khoi_shop/widgets/feeds_product.dart';
import 'package:provider/provider.dart';

class CategoryFeedsScreen extends StatelessWidget {

  static const routeName = '/CategoryFeedsScreen';

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context, listen: false);
    final categoryName = ModalRoute.of(context)!.settings.arguments as String;
    final List<Product> productList = productProvider.findByCategory(categoryName);
    return Scaffold(
      body: productList.isEmpty?
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(MyAppIcons.database, size: 30,),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'No product in category',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                    ),
                  )
                ],
              ),
            ),
          )
          : Center(
          child: GridView.count(
            childAspectRatio: 240/320,
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
          )
      ),
    );
  }
}
