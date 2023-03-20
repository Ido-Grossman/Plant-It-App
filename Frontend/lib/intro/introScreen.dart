import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

import 'package:frontend/home/homeScreen.dart';
import 'package:frontend/logins/loginScreen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Intro Screen"),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20, top: 20),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Login()));
              }, // to login screen
              child: const Text('Skip', style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            onPageChanged: (int page){
              setState(() {
                currentIdx = page;
              });
            },
            controller: _pageController,
            children: [
              startScreen(img: 'assets/plant-a.png',
              title: Consts.firstTitle,
              description: Consts.firstSubTitle,),
              startScreen(img: 'assets/plant-b.png',
                title: Consts.secondTitle,
                description: Consts.secondSubTitle,),
              startScreen(img: 'assets/plant-c.png',
                title: Consts.thirdTitle,
                description: Consts.thirdSubTitle,),
            ],
          ),
          Positioned(
            left: 60,
            bottom: 90,
              child: Row(
                children: _initIndicator(),
              ),),
          Positioned(
            bottom: 60,
              right: 30,
              child: Container(
                child: IconButton(
                  onPressed: (){
                    setState(() {
                      if(currentIdx < 2){
                        currentIdx++;
                        if(currentIdx < 3){
                          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                        }
                      } else {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const Login()));
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_forward, size: 24, color: Colors.white,),),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Consts.primaryColor
                ),
              ))
        ],
      ),
    );
  }
  Widget _indicator(bool isHere){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10.0,
      width: isHere? 20 : 8,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Consts.primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),);
  }

  List<Widget> _initIndicator() {
    List<Widget> indicators = [];

    for(int i = 0; i < 3; i++){
      if(currentIdx == i){
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }
}

class startScreen extends StatelessWidget {
  final String img;
  final String title;
  final String description;

  const startScreen({
    super.key, required this.img, required this.title, required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 350, child: Image.asset(img),),
          const SizedBox(height: 20,),
          Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Consts.primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),),
        const SizedBox(height: 20,),
          Text(description,
            textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.grey
          ),),
          const SizedBox(height: 20,)
        ],
      ),
    );
  }
}



