import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/my_icons.dart';

class GlobalMethod{
  static Future<void> showDialogg(String title, String subtitle, Function fct, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx){
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Icon(MyAppIcons.attention, color: Colors.red, size: 20,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title),
                )
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Cancel')),
              TextButton(onPressed: (){
                Navigator.pop(context);
                fct();
              }, child: Text('Ok')),
            ],
          );
        }
    );
  }

  static Future<void> authErrorHandle(String subtitle, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx){
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Icon(MyAppIcons.attention, color: Colors.red, size: 20,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error occured'),
                )
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Ok')),
            ],
          );
        }
    );
  }
}