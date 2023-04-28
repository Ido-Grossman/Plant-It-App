import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportPage extends StatelessWidget {
  void _launchURL() async {
    const url = 'mailto:idoddii@gmail.com?subject=Support%20Request&body=';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Support'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'For any inquiries or assistance, please contact our support team via email.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _launchURL,
              child: Text('Contact Support'),
            ),
          ],
        ),
      ),
    );
  }
}
