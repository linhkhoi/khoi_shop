import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/colors.dart';
import 'package:khoi_shop/provider/dark_theme_provider.dart';
import 'package:provider/provider.dart';

import '../feeds.dart';

class CartEmpty extends StatelessWidget {
  const CartEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/emptycart.png')
              )
            ),
          ),
          Text(
            'Your Cart Is Empty',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              color: Theme.of(context).textSelectionColor,
              fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Looks Like You Didn\'t \n Add Anything To Your Cart Yet',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 26,
                color: themeChange.darkTheme?Theme.of(context).disabledColor:ColorsConsts.subTitle,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.height*0.1,
            child: RaisedButton(
                onPressed: (){
                  Navigator.pushNamed(context, FeedsScreen.routeName);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.red),
                ),
                color: Colors.redAccent,
                child: Text(
                  'Shop Now'.toUpperCase(),
                   style: TextStyle(
                       fontSize: 26,
                       color: Theme.of(context).textSelectionColor,
                       fontWeight: FontWeight.w600
                   ),
                )
            ),
          )
        ],
      ),
    );
  }
}
