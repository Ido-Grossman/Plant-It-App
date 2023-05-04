import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:frontend/constants.dart';

import 'package:frontend/menu/home_screen.dart';
import 'package:frontend/menu/my_plants_screen.dart';
import 'package:frontend/menu/profile_screen.dart';
import 'package:frontend/menu/search_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:frontend/service/http_service.dart';

class MainScreen extends StatefulWidget {
  final String? username;
  final String? token;
  final String email;

  const MainScreen(
      {Key? key, this.username, required this.token, required this.email})
      : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ValueNotifier<bool> _myPlantsRefreshNotifier = ValueNotifier<bool>(false);
  late Future<Map<String, dynamic>> responseBody;
  File? image;
  final ImagePicker picker = ImagePicker();

  int _bottomNavigationIdx = 0;
  int myPlantIndex = 1;

  List<IconData> screenIconsList = [
    Icons.home,
    Icons.list,
    Icons.search,
    Icons.person
  ];

  List<String> screenTitleList = ['Home', 'My Plants', 'Search', 'Profile'];

  late String profileImg;

  @override
  void initState() {
    super.initState();
    responseBody = getUserDetails(widget.token, widget.email);
  }

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
            title: Text(title),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(message),
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
    ThemeData currentTheme = Theme.of(context);
    Color activeColor = currentTheme.brightness == Brightness.light
        ? Consts.primaryColor
        : Consts.lessBlack;
    Color inactiveColor = currentTheme.brightness == Brightness.light
        ? Consts.lessBlack.withOpacity(.5)
        : Colors.white;
    Color? backgroundColor = currentTheme.brightness == Brightness.light
        ? null
        : Consts.lessBlack.withOpacity(0.5);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              screenTitleList[_bottomNavigationIdx],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Consts.primaryColor,
        elevation: 0.0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: responseBody,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error getting user details'),
              );
            } else {
              profileImg = snapshot.data!['profile_picture'];
              List<Widget> screens = [
                HomeScreen(
                  username: widget.username,
                ),
                MyPlants(
                  refreshNotifier: _myPlantsRefreshNotifier,
                  token: widget.token,
                  email: widget.email,
                  onNavigateAway: () {
                    _myPlantsRefreshNotifier.value = false;
                  },),
                SearchScreen(
                  email: widget.email,
                  token: widget.token,),
                MyProfile(
                  token: widget.token,
                  username: snapshot.data!['username'],
                  profileImg: profileImg,
                  email: widget.email,
                )
              ];
              return IndexedStack(
                index: _bottomNavigationIdx,
                children: screens,
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        heroTag: 'main_fab',
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
        backgroundColor: backgroundColor,
        splashColor: activeColor,
        activeColor: Consts.primaryColor,
        inactiveColor: inactiveColor,
        icons: screenIconsList,
        activeIndex: _bottomNavigationIdx,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) {
          setState(() {
            _bottomNavigationIdx = index;
            if (index == myPlantIndex) {
              _myPlantsRefreshNotifier.value = !_myPlantsRefreshNotifier.value;
            }
          });
        },
      ),
    );
  }
}
