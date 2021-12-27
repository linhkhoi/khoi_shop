import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/screens/landing_page.dart';
import 'package:khoi_shop/screens/main_screen.dart';

import '../bottom_bar.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if(userSnapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (userSnapshot.connectionState == ConnectionState.active){
            if(userSnapshot.hasData){
              return BottomBarScreen();
            }else{
              return LandingPage();
            }
          } else if (userSnapshot.hasError){
            return Center(
              child: Text('Error occured'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }
}
