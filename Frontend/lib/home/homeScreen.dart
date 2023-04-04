import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/menu/cameraPage.dart';
import 'package:frontend/menu/homeScreen.dart';
import 'package:frontend/menu/myPlantsScreen.dart';
import 'package:frontend/menu/profileScreen.dart';
import 'package:frontend/menu/searchScreen.dart';
import 'package:frontend/service/googleSignIn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _bottomNavigationIdx = 0;
  List<Widget> screens = const [
    HomeScreen(), MyPlants(), SearchScreen(), MyProfile()
  ];

  List<IconData> screenIconsList = [
    Icons.home,
    Icons.list,
    Icons.search,
    Icons.person
  ];

  List<String> screenTitleList = [
    'Home',
    'My Plants',
    'Search',
    'Profile'
  ];



  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(screenTitleList[_bottomNavigationIdx],
            style: TextStyle(
              color: Consts.lessBlack,
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        actions: [
          TextButton(onPressed: () {
            final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.logOut();
          }, child: Text('Logout'))
        ],
      ),
      body: IndexedStack(
        index: _bottomNavigationIdx,
        children: screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, PageTransition(
              child: CameraScreen(title: "Camera"),
              type: PageTransitionType.bottomToTop));
        },
        backgroundColor: Consts.primaryColor,
        child: Image.asset('assets/camera.png', height: 40.0,),
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
        onTap: (index){
          setState(() {
            _bottomNavigationIdx = index;
          });
        },
      ),
    );
  }
}
