import 'package:flutter/material.dart';
import 'package:khoi_shop/inner_screens/category_feeds.dart';
import 'package:khoi_shop/screens/feeds.dart';

class CategoryWidget extends StatefulWidget {
  int index;


  CategoryWidget(this.index, {Key? key}) : super(key: key);


  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {

  List<Map<String,Object>> categories = [
    {
      'categoryName': 'Phones',
      'categoryImagePath': 'assets/images/CatPhones.png'
    },
    {
      'categoryName': 'Clothes',
      'categoryImagePath': 'assets/images/CatClothes.jpg'
    },
    {
      'categoryName': 'Shoes',
      'categoryImagePath': 'assets/images/CatShoes.jpg'
    },
    {
      'categoryName': 'Beauty&Health',
      'categoryImagePath': 'assets/images/CatBeauty.jpg'
    },
    {
      'categoryName': 'Laptops',
      'categoryImagePath': 'assets/images/CatLaptops.png'
    },
    {
      'categoryName': 'Furniture',
      'categoryImagePath': 'assets/images/CatFurniture.jpg'
    },
    {
      'categoryName': 'Watches',
      'categoryImagePath': 'assets/images/CatWatches.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: (){
            Navigator.of(context).pushNamed(CategoryFeedsScreen.routeName, arguments: '${categories[widget.index]['categoryName']}');
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                    image: AssetImage(categories[widget.index]['categoryImagePath'] as String),
                    fit: BoxFit.cover
                )
            ),
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            width: 150,
            height: 150,
          ),
        ),
        Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Theme.of(context).backgroundColor,
              child: Text(
                categories[widget.index]['categoryName'] as String,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textSelectionColor
                ),
              ),
            )
        )
      ],
    );
  }
}
