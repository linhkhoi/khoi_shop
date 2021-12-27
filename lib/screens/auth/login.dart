import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khoi_shop/consts/colors.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/screens/forget_password.dart';
import 'package:khoi_shop/services/global_method.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  String _emailAddress = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() async{
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        await _auth.signInWithEmailAndPassword(email: _emailAddress.toLowerCase().trim(), password: _password.trim())
            .then((value) =>
        Navigator.canPop(context) ? Navigator.pop(context) : null);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          GlobalMethod.authErrorHandle('No user found for that email.', context);
        } else if (e.code == 'wrong-password') {
          GlobalMethod.authErrorHandle('Wrong password provided for that user.', context);
        }
      } catch (e) {
        print(e);
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [ColorsConsts.gradiendFStart, ColorsConsts.gradiendLStart],
                    [ColorsConsts.gradiendFEnd, ColorsConsts.gradiendLEnd],
                  ],
                  durations: [19440, 10800],
                  heightPercentages: [0.20, 0.25],
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 0,
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 80),
                height: 120.0,
                width: 120.0,
                decoration: BoxDecoration(
                  //  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://image.flaticon.com/icons/png/128/869/869636.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
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
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        key: ValueKey('password'),
                        validator: (value){
                          if(value!.isEmpty || value.length < 7){
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        focusNode: _passwordFocusNode,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            prefixIcon: Icon(MyAppIcons.keyboard),
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(_obscureText? MyAppIcons.eye: MyAppIcons.eyeHide),
                            ),
                            labelText: 'Password',
                            fillColor: Theme.of(context).backgroundColor
                        ),
                        onSaved: (value){
                          _password = value!;
                        },
                        onEditingComplete: _submitForm,
                        obscureText: _obscureText,
                      ),
                    ),
                    Align(
                       alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                        child: TextButton(
                            onPressed: (){
                              Navigator.pushNamed(context, ForgetPassword.routeName);
                            },
                            child: Text('Forget Password?',
                              style: TextStyle(
                                color: Theme.of(context).textSelectionColor,
                                decoration: TextDecoration.underline
                              ),
                            )
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        _isLoading ? CircularProgressIndicator(): ElevatedButton(
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
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
