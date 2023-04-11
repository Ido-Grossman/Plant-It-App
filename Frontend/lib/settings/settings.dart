import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Consts.primaryColor,
      ),
      body: ListView(
        children: [
          ListTile(title: Text('Account Information')),
          ListTile(
            title: Text('Email'),
            subtitle: Text('johndoe@email.com'),
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
            title: Text('Password'),
            subtitle: Text('**********'),
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
            title: Text('Profile Picture'),
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
          ListTile(title: Text('Notifications Preferences')),
          ListTile(
            title: Text('Preferred Notification Times'),
            subtitle: Text(
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
            title: Text('Location Settings'),
            subtitle: Text('Use GPS: On, Zip Code: 12345'),
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
          ListTile(title: Text('Display Settings')),
          ListTile(
            title: Text('Theme'),
            trailing: SizedBox(
              width: 80,
              child: Switch(
                value: true, // Change this value based on the selected theme
                onChanged: (bool value) {
                  // Toggle between light and dark mode
                },
              ),
            ),
          ),
          ListTile(
            title: Text('Font Size'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                min: 12,
                max: 24,
                value: 16, // Change this value based on the selected font size
                onChanged: (double value) {
                  // Adjust font size
                },
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Frequently Asked Questions'),
            onTap: () {
              // Access FAQ
            },
          ),
          ListTile(
            title: Text('Tutorials'),
            onTap: () {
              // Access video and text tutorials
            },
          ),
          ListTile(
            title: Text('Report a Bug'),
            onTap: () {
              // Submit a bug report
            },
          ),
          ListTile(
            title: Text('Contact Support'),
            onTap: () {
              // Access support contact options
            },
          ),
        ],
      ),
    );
  }
}
