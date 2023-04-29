import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportBugPage extends StatelessWidget {
  void _launchURL() async {
    const url = 'mailto:idoddii@gmail.com?subject=Bug%20Report&body=';
    try {
      await launch(url);
    } on Exception {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report a Bug'),
        backgroundColor: Consts.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'To report a bug, please send an email to our support team.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Image.network(
                'https://media.licdn.com/dms/image/C5612AQF4du-IOzgaOQ/article-cover_image-shrink_600_2000/0/1624356214000?e=2147483647&v=beta&t=PjU2ElnO7piQOROqxQ8es9So1Y6ZiGVy-eS5ZHm8R9s', // Add a relevant image asset
                height: 200,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _launchURL,
                child: Text('Report a Bug'),
                style: ElevatedButton.styleFrom(
                  primary: Consts.primaryColor,
                  onPrimary: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
