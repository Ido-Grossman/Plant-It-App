import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/settings/privacy_policy_screen.dart';
import 'package:frontend/settings/terms_of_service_screen.dart';

class InformationScreen extends StatelessWidget {
  final String appVersion = '1.0.0';
  final String buildNumber = '100';
  final String copyrightInfo = '© 2023 PlantIt-App. All rights reserved.';
  final String privacyPolicyURL = 'https://yourcompany.com/privacy-policy';
  final String termsOfServiceURL = 'https://yourcompany.com/terms-of-service';

  const InformationScreen({Key? key}) : super(key: key);

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
            title: Text('App Version', style: TextStyle(fontSize: 16)),
            subtitle: Text(appVersion, style: TextStyle(fontSize: 14)),
          ),
          ListTile(
            title: Text('Build Number', style: TextStyle(fontSize: 16)),
            subtitle: Text(buildNumber, style: TextStyle(fontSize: 14)),
          ),
          Divider(),
          ListTile(
            title: Text('Privacy Policy', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Terms of Service', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsOfServiceScreen(),
                ),
              );
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
