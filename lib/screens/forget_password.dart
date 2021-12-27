import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khoi_shop/consts/colors.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/services/global_method.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName = '/ForgetPassword';

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  String _emailAddress = '';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _submitForm() async{
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        await _auth.sendPasswordResetEmail(email: _emailAddress.trim().toLowerCase());
        Fluttertoast.showToast(
            msg: "An email has been send",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.canPop(context)?Navigator.pop(context): null;
      } on FirebaseAuthException catch (e) {
        GlobalMethod.authErrorHandle(e.code, context);
      } catch (e) {
        GlobalMethod.authErrorHandle(e.toString(), context);
      } finally{
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Forget Password',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                key: ValueKey('email'),
                validator: (value){
                  if(value!.isEmpty || !value.contains('@')){
                    return 'Please enter a valid email adress';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passwordFocusNode),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    prefixIcon: Icon(MyAppIcons.mail),
                    labelText: 'Email Address',
                    fillColor: Theme.of(context).backgroundColor
                ),
                onSaved: (value){
                  _emailAddress = value!;
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: _isLoading? CircularProgressIndicator(): ElevatedButton(
              style: ButtonStyle(
                shape:
                MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                          color: ColorsConsts.backgroundColor)),
                ),
              ),
              onPressed: _submitForm,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Reset Password',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(MyAppIcons.key, size: 18,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

