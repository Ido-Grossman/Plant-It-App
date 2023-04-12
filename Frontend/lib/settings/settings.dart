import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../service/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          ListTile(title: CustomFontText(text: 'Account Information',)),
          ListTile(
            title: CustomFontText(text: 'Email'),
            subtitle: CustomFontText(text: 'johndoe@email.com'),
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
            title: CustomFontText(text: 'Password'),
            subtitle: CustomFontText(text: '**********'),
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
            title: CustomFontText(text: 'Profile Picture'),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/default-profile.png'),
              backgroundColor: Colors.white,
            ),
            trailing: SizedBox(
              width: 50,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Edit profile picture
                },
              ),
            ),
          ),
          Divider(),
          ListTile(title: CustomFontText(text: 'Notifications Preferences')),
          ListTile(
            title: CustomFontText(text: 'Preferred Notification Times'),
            subtitle: CustomFontText(text:
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
            title: CustomFontText(text: 'Location Settings'),
            subtitle: CustomFontText(text: 'Use GPS: On, Zip Code: 12345'),
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
          ListTile(title: CustomFontText(text: 'Display Settings')),
          ListTile(
            title: CustomFontText(text: 'Theme'),
            trailing: SizedBox(
              width: 80,
              child: Switch(
                value: appTheme.themeData.brightness == Brightness.dark, // Update the switch value based on the theme brightness
                onChanged: (bool value) {
                  appTheme.toggleTheme(); // Make sure to call the function with parentheses
                },
              ),
            ),
          ),
          ListTile(
            title: CustomFontText(text: 'Font Size'),
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
            title: CustomFontText(text: 'Frequently Asked Questions'),
            onTap: () {
              // Access FAQ
            },
          ),
          ListTile(
            title: CustomFontText(text: 'Tutorials'),
            onTap: () {
              // Access video and text tutorials
            },
          ),
          ListTile(
            title: CustomFontText(text: 'Report a Bug'),
            onTap: () {
              // Submit a bug report
            },
          ),
          ListTile(
            title: CustomFontText(text: 'Contact Support'),
            onTap: () {
              // Access support contact options
            },
          ),
        ],
      ),
    );
  }
}
