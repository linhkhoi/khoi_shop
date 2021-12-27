import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/screens/cart/cart.dart';
import 'package:khoi_shop/screens/feeds.dart';
import 'package:khoi_shop/screens/home.dart';
import 'package:khoi_shop/screens/search.dart';
import 'package:khoi_shop/screens/user_info.dart';


class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  List? _pages ;

  // var _pages;
  int _selectedIndex = 0;

  @override
  void initState() {
    _pages = [
      HomeScreen(),
      FeedsScreen(),
      Search(),
      CartScreen(),
      UserScreen(),
    ];
    super.initState();
  }

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages![_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        notchMargin: 3,
        clipBehavior: Clip.antiAlias,
        // elevation: 5,
        shape: const CircularNotchedRectangle(),
        child: Container(
          // height: kBottomNavigationBarHeight * 0.8,
          decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5),
              )),
          child: BottomNavigationBar(
            onTap: _selectedPage,
            backgroundColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(context).textSelectionColor,
            selectedItemColor: Colors.blue.shade400,
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(MyAppIcons.home),
                tooltip: 'Home',
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(MyAppIcons.rss),
                tooltip: 'Feeds',
                label: 'Feeds',
              ),
              const BottomNavigationBarItem(
                activeIcon: null,
                icon: Icon(null), // Icon(
                //   Icons.search,
                //   color: Colors.transparent,
                // ),
                tooltip: 'Search',
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(MyAppIcons.bag),
                tooltip: 'Cart',
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(MyAppIcons.user),
                tooltip: 'User',
                label: 'User',
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade400,
        tooltip: 'Search',
        elevation: 5,
        child: (Icon(MyAppIcons.search)),
        onPressed: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
    );
  }
}
