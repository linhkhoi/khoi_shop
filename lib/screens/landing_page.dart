import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khoi_shop/bottom_bar.dart';
import 'package:khoi_shop/consts/colors.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/screens/auth/login.dart';
import 'package:khoi_shop/screens/auth/sign_up.dart';
import 'package:khoi_shop/services/global_method.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with TickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation<double> _animation;
  List<String> images = [
    'https://media.istockphoto.com/photos/man-at-the-shopping-picture-id868718238?k=6&m=868718238&s=612x612&w=0&h=ZUPCx8Us3fGhnSOlecWIZ68y3H4rCiTnANtnjHk0bvo=',
    'https://thumbor.forbes.com/thumbor/fit-in/1200x0/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fdam%2Fimageserve%2F1138257321%2F0x0.jpg%3Ffit%3Dscale',
    'https://e-shopy.org/wp-content/uploads/2020/08/shop.jpeg',
    'https://e-shopy.org/wp-content/uploads/2020/08/shop.jpeg',
  ];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    images.shuffle();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.linear)
    ..addListener(() {
      setState(() {

      });
    })..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _animationController.reset();
        _animationController.forward();
      }
      });
    _animationController.forward();
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loginWithGoogle() async{
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formatDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";

    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await _auth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));

          FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set({
            'id': authResult.user!.uid,
            'name': authResult.user!.displayName,
            'email': authResult.user!.email,
            'phoneNumber': authResult.user!.phoneNumber,
            'imageUrl': authResult.user!.photoURL,
            'joinedAt': formatDate,
            'createAt': Timestamp.now()
          });

        } catch (error) {
          GlobalMethod.authErrorHandle(error.toString(), context);
        }
      }
    }
  }

  void _loginAsAnonymous() async{

      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInAnonymously();
      } on FirebaseAuthException catch (e) {
          GlobalMethod.authErrorHandle(e.code, context);
      } catch (e) {
        print(e);
      } finally{
        setState(() {
          _isLoading = false;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
               images[0],
            // placeholder: (context, url) => Image.network(
            //     'https://image.flaticon.com/icons/png/128/564/564619.png',
            //     fit: BoxFit.contain),
            errorWidget: (context, url, error) => Icon(MyAppIcons.attention),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'This is Khoi Shop',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 26),
                  ),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                  color: ColorsConsts.backgroundColor)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(MyAppIcons.user, size: 18,)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pink.shade400),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                  color: ColorsConsts.backgroundColor)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(MyAppIcons.userPlus, size: 18,)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  )),
                  Text(
                    'Or continued with',
                    style: TextStyle(color: Colors.black),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  )),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlineButton(
                    onPressed: _loginWithGoogle,
                    shape: StadiumBorder(),
                    highlightedBorderColor: Colors.red.shade200,
                    borderSide: BorderSide(width: 2, color: Colors.red),
                    child: Text('Google +'),
                  ),
                  _isLoading ? CircularProgressIndicator(): OutlineButton(
                    onPressed: () {
                     _loginAsAnonymous();
                    },
                    shape: StadiumBorder(),
                    highlightedBorderColor: Colors.deepPurple.shade200,
                    borderSide: BorderSide(width: 2, color: Colors.deepPurple),
                    child: Text('Sign in as a guest'),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          )
        ],
      ),
    );
  }
}
