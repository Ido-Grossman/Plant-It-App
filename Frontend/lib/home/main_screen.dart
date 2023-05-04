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
import 'package:frontend/models/PlantDetails.dart';
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
  var diseaseName;
  String? username;

  int _bottomNavigationIdx = 0;
  int myPlantIndex = 1;

  List<IconData> screenIconsList = [
    Icons.home,
    Icons.list,
    Icons.search,
    Icons.person
  ];

  List<String> screenTitleList = ['Home', 'My Plants', 'Search', 'Profile'];
  List<String> userPlants = [];

  late String profileImg;
  String? _selectedPlant;

  @override
  void initState() {
    super.initState();
    responseBody = getUserDetails(widget.token, widget.email);
  }

  void updateUsername(String newUsername) {
    setState(() {
      username = newUsername;
    });
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildDialogContent(context),
        );
      },
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    Color accentColor = currentTheme.colorScheme.secondary;

    return SingleChildScrollView(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Display the user's photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    image!,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  diseaseName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                SizedBox(height: 16),
                const Text(
                  'Disease Care',
                  // Replace with the actual disease care instructions
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                // Roll down menu of the user's plants
                DropdownButton<String>(
                  value: _selectedPlant,
                  items: userPlants
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPlant = newValue;
                    });
                  },
                  hint: const Text('Select a plant'),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Button
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    // Save Button
                    ElevatedButton(
                      onPressed: () {
                        // Add your save functionality here
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Consts.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
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
              username ??= snapshot.data!['username'];
              profileImg = snapshot.data!['profile_picture'];
              List<Widget> screens = [
                HomeScreen(
                  username: username,
                ),
                MyPlants(
                  refreshNotifier: _myPlantsRefreshNotifier,
                  token: widget.token,
                  email: widget.email,
                  onNavigateAway: () {
                    _myPlantsRefreshNotifier.value = false;
                  },
                ),
                SearchScreen(
                  email: widget.email,
                  token: widget.token,
                ),
                MyProfile(
                  token: widget.token,
                  username: snapshot.data!['username'],
                  profileImg: profileImg,
                  email: widget.email,
                  updateUsernameCallback: updateUsername,
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
            List<PlantDetails> newPlants = await fetchMyPlants(widget.email, widget.token);
            List<String> newPlantsNames = [];
            for (PlantDetails plant in newPlants) {
              newPlantsNames.add(plant.nickname);
            }
            setState(() {
              userPlants = newPlantsNames;
            });
            // show loader
            presentLoader(context, text: 'Sending image...');
            // calling with http
            diseaseName = await uploadPhoto(image!.path);
            // hide loader
            Navigator.of(context).pop();
            showCustomDialog(context);
            setState(() {
              _selectedPlant = null;
            });
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
