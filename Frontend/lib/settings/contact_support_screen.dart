import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportPage extends StatelessWidget {
  void _launchURL() async {
    const url = 'mailto:idoddii@gmail.com?subject=Support%20Request&body=';
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
        title: Text('Contact Support'),
        backgroundColor: Consts.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'For any inquiries or assistance, please contact our support team via email.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Image.network(
                'https://img.freepik.com/premium-vector/customer-support-illustration-concept_23152-154.jpg',
                height: 200,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _launchURL,
                child: Text('Contact Support'),
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
