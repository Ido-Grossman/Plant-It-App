import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class InformationScreen extends StatelessWidget {
  final String appVersion = '1.0.0';
  final String buildNumber = '100';
  final String copyrightInfo = '© 2023 PlantIt-App. All rights reserved.';
  final String privacyPolicyURL = 'https://yourcompany.com/privacy-policy';
  final String termsOfServiceURL = 'https://yourcompany.com/terms-of-service';

  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'),
        backgroundColor: Consts.primaryColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('App Version'),
            subtitle: Text(appVersion),
          ),
          ListTile(
            title: Text('Build Number'),
            subtitle: Text(buildNumber),
          ),
          Divider(),
          ListTile(
            title: Text('Privacy Policy'),
            onTap: () {
              // Open privacy policy URL
            },
          ),
          ListTile(
            title: Text('Terms of Service'),
            onTap: () {
              // Open terms of service URL
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              copyrightInfo,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
