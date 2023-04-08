import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:frontend/constants.dart';

import 'package:frontend/menu/homeScreen.dart';
import 'package:frontend/menu/myPlantsScreen.dart';
import 'package:frontend/menu/profileScreen.dart';
import 'package:frontend/menu/searchScreen.dart';
import 'package:frontend/service/googleSignIn.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:frontend/service/httpService.dart';

import '../logins/loginScreen.dart';

class FirstScreen extends StatefulWidget {
  final String? username;

  const FirstScreen({Key? key, this.username}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  File? image;
  final ImagePicker picker = ImagePicker();

  int _bottomNavigationIdx = 0;

  List<IconData> screenIconsList = [
    Icons.home,
    Icons.list,
    Icons.search,
    Icons.person
  ];

  List<String> screenTitleList = ['Home', 'My Plants', 'Search', 'Profile'];

  Future takePhoto() async {
    try {
      final image = await picker.pickImage(source: ImageSource.camera);
      File rotatedImg =
          await FlutterExifRotation.rotateImage(path: image!.path);
      final imgTmp = File(rotatedImg.path);
      setState(() {
        this.image = imgTmp;
      });
    } on PlatformException catch (e) {
      print('error taking picture because of $e');
    }
  }

  void presentLoader(BuildContext context,
      {String text = 'Aguarde...',
      bool barrierDismissible = false,
      bool willPop = true}) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (c) {
          return WillPopScope(
            onWillPop: () async {
              return willPop;
            },
            child: AlertDialog(
              content: Container(
                child: Row(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      text,
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> presentAlert(BuildContext context,
      {String title = '', String message = '', Function()? ok}) {
    return showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text('$title'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text('$message'),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: ok ?? Navigator.of(context).pop,
                child: const Text(
                  'OK',
                  // style: greenText,
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeScreen(
        username: widget.username,
      ),
      MyPlants(),
      SearchScreen(),
      MyProfile()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              screenTitleList[_bottomNavigationIdx],
              style: TextStyle(
                color: Consts.lessBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        actions: [
          TextButton(
              onPressed: () async {
                if (widget.username == null) {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logOut();
                  await Future.delayed(const Duration(seconds: 3));
                }
                if (!mounted){
                  return;
                }
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const Login(),
                          type: PageTransitionType.bottomToTop));
              },
              child: const Text('Logout'))
        ],
      ),
      body: IndexedStack(
        index: _bottomNavigationIdx,
        children: screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await takePhoto();
          if (image != null) {
            // rotate picture
            if (!mounted) {
              return;
            }
            // show loader
            presentLoader(context, text: 'Sending image...');
            // calling with http
            var responseDataHttp = await uploadPhoto(image!.path);
            // hide loader
            Navigator.of(context).pop();
            // showing alert dialogs
          }
        },
        backgroundColor: Consts.primaryColor,
        child: Image.asset(
          'assets/camera.png',
          height: 40.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashColor: Consts.primaryColor,
        activeColor: Consts.primaryColor,
        inactiveColor: Consts.lessBlack.withOpacity(.5),
        icons: screenIconsList,
        activeIndex: _bottomNavigationIdx,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) {
          setState(() {
            _bottomNavigationIdx = index;
          });
        },
      ),
    );
  }
}
