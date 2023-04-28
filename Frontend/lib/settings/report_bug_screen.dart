import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportBugPage extends StatelessWidget {
  void _launchURL() async {
    const url = 'mailto:idoddii@gmail.com?subject=Bug%20Report&body=';
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
        title: Text('Report a Bug'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'To report a bug, please send an email to our support team.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _launchURL,
              child: Text('Report a Bug'),
            ),
          ],
        ),
      ),
    );
  }
}
