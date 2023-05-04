import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/service/http_service.dart';
import 'package:frontend/settings/report_bug_screen.dart';
import 'package:frontend/settings/tutorial_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../widgets/plant_loading_icon.dart';
import '../widgets/font_adjusted_text.dart';
import 'contact_support_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String? token;
  String username;
  String profileImg;
  final String email;
  final Function(String) updateProfileImgCallback;
  final Function(String) updateUsernameCallback;

  SettingsScreen({super.key, required this.token, required this.username, required this.profileImg, required this.updateProfileImgCallback, required this.updateUsernameCallback, required this.email});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  File? image;
  final ImagePicker picker = ImagePicker();

  Future<void> upPhoto(String path) async {
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

  Future<void> _showPasswordDialog() async {
    String? newPassword;
    String? confirmPassword;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to change your password?'),
          content: SingleChildScrollView(
            child: ListBody(
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                  int statusCode = await forgotPass(widget.email);
                  if (statusCode == 200) {
                    Fluttertoast.showToast(
                      msg: "Check your mail, you received a reset password link.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Navigator.of(context).pop();
                  } else {
                    Consts.alertPopup(context, 'Something went wrong. Please try again.');
                  }
                }
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUsernameDialog() async {
    String? newUsername;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Username'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'New username'),
                  onChanged: (value) {
                    newUsername = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                if (newUsername != null && newUsername!.isNotEmpty) {
                  int statusCode =
                  await setUsername(newUsername!, widget.token);
                  if (statusCode == 200) {
                    setState(() {
                      widget.updateUsernameCallback(newUsername!);
                      widget.username = newUsername!;
                    });
                    Navigator.of(context).pop();
                  } else if (statusCode == 409) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Username already taken. Please try another one."),
                      duration: Duration(seconds: 3),
                    ));
                  } else {
                    // Handle other errors
                  }
                }
              },
            ),
          ],
        );
      },
    );
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
            title: FontAdjustedText(text: 'Username'),
            subtitle: FontAdjustedText(text: widget.username),
            trailing: SizedBox(
              width: 50,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _showUsernameDialog();
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
                onPressed: () async {
                  _showPasswordDialog();
                },
              ),
            ),
          ),
          ListTile(
            title: FontAdjustedText(text: 'Profile Picture'),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.profileImg),
              backgroundColor: Colors.white,
            ),
            trailing: SizedBox(
              width: 50,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  await takePhoto();
                  await upPhoto(image!.path);
                  var response = await getUserDetails(widget.token, widget.email);
                  setState(() {
                    widget.profileImg = response['profile_picture'];
                    print(widget.profileImg);
                  });
                  widget.updateProfileImgCallback(response['profile_picture']);
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
            title: FontAdjustedText(text: 'Tutorials'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorialsPage(),
                ),
              );
            },
          ),
          ListTile(
            title: FontAdjustedText(text: 'Report a Bug'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportBugPage(),
                ),
              );
            },
          ),
          ListTile(
            title: FontAdjustedText(text: 'Contact Support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactSupportPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
