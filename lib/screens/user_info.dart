import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:khoi_shop/consts/colors.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/provider/dark_theme_provider.dart';
import 'package:khoi_shop/screens/admin/chart_screen.dart';
import 'package:khoi_shop/screens/cart/cart.dart';
import 'package:khoi_shop/screens/orders/order.dart';
import 'package:khoi_shop/screens/wishlist/wishlist.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late ScrollController _scrollController;
  var top = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String _uid;
  String _name='Guest';
  String _email='';
  String _joinedAt='';
  int _phoneNumber=0;
  String _imgUrl ='';
  String _role ='';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    getData();
  }

  void getData() async{
    User? user = _auth.currentUser;
    _uid = user!.uid;
    if(user.isAnonymous){
      return;
    }else{
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      setState(() {
        _name = userDoc.get('name');
        _email = userDoc.get('email');
        _joinedAt = userDoc.get('joinedAt');
        _phoneNumber = userDoc.get('phoneNumber');
        _imgUrl = userDoc.get('imageUrl');
        _role = userDoc.get('role');
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return _uid == ''? Center(child: CircularProgressIndicator(),):Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 4,
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  top = constraints.biggest.height;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            ColorsConsts.starterColor,
                            ColorsConsts.endColor,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      centerTitle: true,
                      title: Row(
                        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: top <= 110.0 ? 1.0 : 0,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Container(
                                  height: kToolbarHeight / 1.8,
                                  width: kToolbarHeight / 1.8,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          _imgUrl!=''?_imgUrl:'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  // 'top.toString()',
                                  _name,
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      background: Image(
                        image: NetworkImage(
                            _imgUrl!=''?_imgUrl:'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                }),
              ),
              SliverToBoxAdapter(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: userTile('User Bag')),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(WishlistScreen.routeName);
                        },
                        splashColor: Theme.of(context).splashColor,
                        child: ListTile(
                          title: Text('Wishlist'),
                          trailing: Icon(MyAppIcons.chevronRight),
                          leading: Icon(MyAppIcons.wishlist),
                        ),
                      )),
                  Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(CartScreen.routeName);
                        },
                        splashColor: Theme.of(context).splashColor,
                        child: ListTile(
                          title: Text('Cart'),
                          trailing: Icon(MyAppIcons.chevronRight),
                          leading: Icon(MyAppIcons.cart),
                        ),
                      )),
                  Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(OrderScreen.routeName);
                        },
                        splashColor: Theme.of(context).splashColor,
                        child: ListTile(
                          title: Text('My Orders'),
                          trailing: Icon(MyAppIcons.chevronRight),
                          leading: Icon(MyAppIcons.bag),
                        ),
                      )),
                  _role == 'admin' ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ChartScreen.routeName);
                        },
                        splashColor: Theme.of(context).splashColor,
                        child: ListTile(
                          title: Text('Chart'),
                          trailing: Icon(MyAppIcons.chevronRight),
                          leading: Icon(MyAppIcons.chartPie),
                        ),
                      )): Container(),
                  Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: userTile('User Information')),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  userListTile('mail', _email, MyAppIcons.mail, context),
                  userListTile('phone', _phoneNumber.toString(), MyAppIcons.phone, context),
                  userListTile('shipping', '', MyAppIcons.truck, context),
                  userListTile('join date', _joinedAt, MyAppIcons.clock, context),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: userTile('Settings'),
                  ),
                  Divider(
                    thickness: 1.0,
                    color: Colors.grey,
                  ),
                  ListTileSwitch(
                    value: themeChange.darkTheme,
                    leading: Icon(FontAwesome5.moon),
                    onChanged: (value) {
                      setState(() {
                        themeChange.darkTheme = value;
                      });
                    },
                    visualDensity: VisualDensity.comfortable,
                    switchType: SwitchType.cupertino,
                    switchActiveColor: Colors.indigo,
                    title: Text('Dark Mode'),
                  ),
                  Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async{
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx){
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 6.0),
                                        child: Icon(MyAppIcons.logout, color: Colors.red, size: 20,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Sign Out'),
                                      )
                                    ],
                                  ),
                                  content: Text('Do you wanna signout'),
                                  actions: [
                                    TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Cancel')),
                                    TextButton(onPressed: () async{
                                      
                                      await _auth.signOut().then((value) => Navigator.pop(context));
                                    }, child: Text('Ok')),
                                  ],
                                );
                              }
                          );

                        },
                        splashColor: Theme.of(context).splashColor,
                        child: ListTile(
                          title: Text('Logout'),
                          leading: Icon(MyAppIcons.logout),
                        ),
                      ))
                ],
              ))
            ],
          ),
          _buildFab()
        ],
      ),
    );
  }

  Widget _buildFab() {
    //starting fab position
    final double defaultTopMargin = 200.0 - 4.0;
    //pixels from top where scaling should start
    final double scaleStart = 160.0;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          heroTag: "btn1",
          onPressed: () {},
          child: Icon(Icons.camera_alt_outlined),
        ),
      ),
    );
  }

  Widget userListTile(
      String title, String subtitle, IconData icon, BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Theme.of(context).splashColor,
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            leading: Icon(icon),
          ),
        ));
  }

  Widget userTile(String title) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
