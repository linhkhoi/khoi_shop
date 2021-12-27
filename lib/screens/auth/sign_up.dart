import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khoi_shop/consts/colors.dart';
import 'package:khoi_shop/consts/my_icons.dart';
import 'package:khoi_shop/services/global_method.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';


final cloudinary = CloudinaryPublic('linhkhoi', 'clinic', cache: false);

class SignUpScreen extends StatefulWidget {
  static const routeName = '/SignUpScreen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  bool _obscureText = true;
  String _emailAddress = '';
  String _password = '';
  String _fullName = '';
  late int _phoneNumber;
  final _formKey = GlobalKey<FormState>();
  String localImage = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  late String url;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() async{
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formatDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {

        if(localImage==''||localImage == null){
          GlobalMethod.authErrorHandle('Please add photo', context);
        }else{

          try {
            CloudinaryResponse response = await cloudinary.uploadFile(
              CloudinaryFile.fromFile(localImage, resourceType: CloudinaryResourceType.Image),
            );

            url = response.secureUrl;
          } on CloudinaryException catch (e) {
            print(e.message);
            print(e.request);
          }
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailAddress,
              password: _password
          );
          final User? user = _auth.currentUser;
          final _uid = user!.uid;
          user.updateProfile(photoURL: url, displayName: _fullName);
          user.reload();
          FirebaseFirestore.instance.collection('users').doc(_uid).set({
            'id': _uid,
            'name': _fullName,
            'email': _emailAddress,
            'phoneNumber': _phoneNumber,
            'imageUrl': url,
            'joinedAt': formatDate,
            'createAt': Timestamp.now()
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }


      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          GlobalMethod.authErrorHandle('This password is weak', context);
        } else if (e.code == 'email-already-in-use') {
          GlobalMethod.authErrorHandle('The account already exists for that email.', context);
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

  void _pickImageFromCamera() async{
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);
    // final pickedImageFile = File(pickedImage!.path);
    setState(() {
      localImage = pickedImage!.path;
    });
    Navigator.pop(context);
  }

  void _pickImageFromGallery() async{
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    // final pickedImageFile = File(pickedImage!.path);
    setState(() {
      localImage = pickedImage!.path;
    });
    Navigator.pop(context);
  }

  void _removeImage(){
    setState(() {
      localImage = '';
    });
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
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: CircleAvatar(
                        radius: 71,
                        backgroundColor: ColorsConsts.gradiendLEnd,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage: localImage == '' ? null : FileImage(File(localImage)) ,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      left: 120,
                      child: RawMaterialButton(
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text(
                                    'Choose option',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ColorsConsts.gradiendLStart
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            _pickImageFromCamera();
                                          },
                                          splashColor: Colors.blueAccent,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(MyAppIcons.cameraRetro, color: Colors.blueAccent,),
                                              ),
                                              Text(
                                                'Camera',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: ColorsConsts.title,
                                                  fontWeight: FontWeight.w500
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            _pickImageFromGallery();
                                          },
                                          splashColor: Colors.blueAccent,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(MyAppIcons.gallery, color: Colors.blueAccent,),
                                              ),
                                              Text(
                                                'Gallery',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: ColorsConsts.title,
                                                    fontWeight: FontWeight.w500
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            _removeImage();
                                          },
                                          splashColor: Colors.blueAccent,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(MyAppIcons.remove, color: Colors.red,),
                                              ),
                                              Text(
                                                'Remove',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w500
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                        elevation: 10,
                        fillColor: ColorsConsts.gradiendLEnd,
                        child: Icon(MyAppIcons.camera),
                        padding: EdgeInsets.all(15),
                        shape: CircleBorder(),
                      ),
                    )
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          key: ValueKey('name'),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Name can\'t null';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onEditingComplete: ()=> FocusScope.of(context).requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: true,
                              prefixIcon: Icon(MyAppIcons.mail),
                              labelText: 'Full name',
                              fillColor: Theme.of(context).backgroundColor
                          ),
                          onSaved: (value){
                            _fullName = value!;
                          },
                        ),
                      ),
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
                          focusNode: _emailFocusNode,
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
                          onEditingComplete: ()=>FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
                          obscureText: _obscureText,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          key: ValueKey('phone number'),

                          focusNode: _phoneNumberFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          textInputAction: TextInputAction.next,
                          onEditingComplete: _submitForm,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              filled: true,
                              prefixIcon: Icon(MyAppIcons.phone),
                              labelText: 'Phone number',
                              fillColor: Theme.of(context).backgroundColor),
                          onSaved: (value) {
                            _phoneNumber = int.parse(value!);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          _isLoading?CircularProgressIndicator():  ElevatedButton(
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
                                  'Sign up',
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
          ),
        ],
      ),
    );
  }
}
