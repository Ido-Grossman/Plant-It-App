import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:frontend/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../widgets/plant_loading_icon.dart';
import '../widgets/font_adjusted_text.dart';

class SettingsScreen extends StatefulWidget {
  final String? token;

  const SettingsScreen({super.key, required this.token});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  File? image;
  final ImagePicker picker = ImagePicker();

  Future<String> upPhoto(String path) async {
    Uri uri =
        Uri.parse('${Consts.getApiLink()}accounts/upload-profile-picture/');
    http.MultipartRequest request = http.MultipartRequest('PUT', uri);
    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('file', path);
    request.files.add(multipartFile);
    String? token = widget.token;
    request.headers.addAll(<String, String>{
      'Authorization': 'Token $token',
    });

    http.StreamedResponse response = await request.send();
    var responseBytes = await response.stream.toBytes();
    var responseString = utf8.decode(responseBytes);
    var decodedResponse = jsonDecode(responseString);
    return decodedResponse['image_url'];
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

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    FontSizeNotifier fontSizeNotifier = Provider.of<FontSizeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Consts.primaryColor,
      ),
      body: ListView(
        children: [
          ListTile(
              title: FontAdjustedText(
            text: 'Account Information',
          )),
          ListTile(
            title: FontAdjustedText(text: 'Email'),
            subtitle: FontAdjustedText(text: 'johndoe@email.com'),
            trailing: SizedBox(
              width: 50,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Edit email
                },
              ),
            ),
          ),
          ListTile(
            title: FontAdjustedText(text: 'Password'),
            subtitle: FontAdjustedText(text: '**********'),
            trailing: SizedBox(
              width: 50,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Edit password
                },
              ),
            ),
          ),
          ListTile(
            title: FontAdjustedText(text: 'Profile Picture'),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/default-profile.png'),
              backgroundColor: Colors.white,
            ),
            trailing: SizedBox(
              width: 50,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  await takePhoto();
                  var responseDataHttp = await upPhoto(image!.path);
                  // Edit profile picture
                },
              ),
            ),
          ),
          Divider(),
          ListTile(title: FontAdjustedText(text: 'Notifications Preferences')),
          ListTile(
            title: FontAdjustedText(text: 'Preferred Notification Times'),
            subtitle: FontAdjustedText(
                text:
                    'Watering: 9:00 AM, Plant Health: 12:00 PM, New Plant Suggestions: 6:00 PM'),
            trailing: SizedBox(
              width: 50,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Edit preferred notification times
                },
              ),
            ),
          ),
          ListTile(
            title: FontAdjustedText(text: 'Location Settings'),
            subtitle: FontAdjustedText(text: 'Use GPS: On, Zip Code: 12345'),
            trailing: SizedBox(
              width: 50,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Edit location settings
                },
              ),
            ),
          ),
          Divider(),
          ListTile(title: FontAdjustedText(text: 'Display Settings')),
          ListTile(
            title: FontAdjustedText(text: 'Theme'),
            trailing: SizedBox(
              width: 80,
              child: Switch(
                value: appTheme.themeData.brightness == Brightness.dark,
                // Update the switch value based on the theme brightness
                onChanged: (bool value) {
                  appTheme
                      .toggleTheme(); // Make sure to call the function with parentheses
                },
              ),
            ),
          ),
          ListTile(
            title: FontAdjustedText(text: 'Font Size'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                min: 12,
                max: 24,
                value: fontSizeNotifier.fontSize,
                onChanged: (double value) {
                  fontSizeNotifier.updateFontSize(value);
                },
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: FontAdjustedText(text: 'Frequently Asked Questions'),
            onTap: () {
              // Access FAQ
            },
          ),
          ListTile(
            title: FontAdjustedText(text: 'Tutorials'),
            onTap: () {
              // Access video and text tutorials
            },
          ),
          ListTile(
            title: FontAdjustedText(text: 'Report a Bug'),
            onTap: () {
              // Submit a bug report
            },
          ),
          ListTile(
            title: FontAdjustedText(text: 'Contact Support'),
            onTap: () {
              // Access support contact options
            },
          ),
        ],
      ),
    );
  }
}
