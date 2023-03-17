import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


import 'package:frontend/service/httpService.dart';
import 'package:frontend/menu/cardPicture.dart';
import 'package:frontend/menu/takePhoto.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Upload',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Upload'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HttpService _httpService = HttpService();
  late CameraDescription _cameraDescription;
  List<String> _images = [];
  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      final camera = cameras
          .where((camera) => camera.lensDirection == CameraLensDirection.back)
          .toList()
          .first;
      setState(() {
        _cameraDescription = camera;
      });
    }).catchError((err) {
      print(err);
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
                child: Text(
                  'OK',
                  // style: greenText,
                ),
                onPressed: ok != null ? ok : Navigator.of(context).pop,
              ),
            ],
          );
        });
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

  @override
  Widget build(BuildContext context) {
    if (_images.isNotEmpty){
      return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Column(
          children: [
            Text('Please send a photo', style: TextStyle(fontSize: 17.0)),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              height: 400,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                        CardPicture(
                          onTap: () async {
                            final String? imagePath =
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => TakePhoto(
                                              camera: _cameraDescription,
                                            )));

                            print('imagepath: $imagePath');
                            if (imagePath != null) {
                              setState(() {
                                _images.add(imagePath);
                              });
                            }
                          },
                        imagePath: _images[0],),
                      ]),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              // color: Colors.indigo,
                              gradient: LinearGradient(colors: [
                                Colors.indigo,
                                Colors.indigo.shade800
                              ]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0))),
                          child: RawMaterialButton(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            onPressed: () async {
                              // show loader
                              presentLoader(context, text: 'Sending image...');

                              // calling with http
                              var responseDataHttp = await _httpService.uploadPhoto(_images[0]);

                              // hide loader
                              Navigator.of(context).pop();

                              // showing alert dialogs
                              await presentAlert(context,
                               title: 'HTTP Success',
                               message: responseDataHttp);

                            },
                            child: Center(
                                child: Text(
                              'SEND',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            )),
                          )),
                    )
                  ],
                ))
          ],
        ),
      ),
    ));
    }
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Column(
          children: [
            Text('Please send a photo', style: TextStyle(fontSize: 17.0)),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              height: 400,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                        CardPicture(
                          onTap: () async {
                            final String? imagePath =
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => TakePhoto(
                                              camera: _cameraDescription,
                                            )));

                            print('imagepath: $imagePath');
                            if (imagePath != null) {
                              setState(() {
                                _images.add(imagePath);
                              });
                            }

                          },
                        ),
                      ] +
                      _images
                          .map((String path) => CardPicture(
                                imagePath: path,
                              ))
                          .toList()),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              // color: Colors.indigo,
                              gradient: LinearGradient(colors: [
                                Colors.indigo,
                                Colors.indigo.shade800
                              ]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0))),
                          child: RawMaterialButton(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            onPressed: () async {
                              // show loader
                              presentLoader(context, text: 'Wait...');

                              // calling with dio



                              // hide loader
                              Navigator.of(context).pop();

                              // showing alert dialogs
                              
                            },
                            child: Center(
                                child: Text(
                              'SEND',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            )),
                          )),
                    )
                  ],
                ))
          ],
        ),
      ),
    ));
  }
}