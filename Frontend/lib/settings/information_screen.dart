import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

import '../service/widgets.dart';

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
            title: CustomFontText(text: 'App Version'),
            subtitle: CustomFontText(text: appVersion),
          ),
          ListTile(
            title: CustomFontText(text: 'Build Number'),
            subtitle: CustomFontText(text: buildNumber),
          ),
          Divider(),
          ListTile(
            title: CustomFontText(text: 'Privacy Policy'),
            onTap: () {
              // Open privacy policy URL
            },
          ),
          ListTile(
            title: CustomFontText(text: 'Terms of Service'),
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
