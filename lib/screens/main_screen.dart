import 'package:flutter/material.dart';
import 'package:khoi_shop/screens/upload_product_form.dart';
import 'package:khoi_shop/screens/landing_page.dart';

import '../bottom_bar.dart';

class MainScreens extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [BottomBarScreen()],
    );
  }
}
