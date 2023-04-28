import 'package:flutter/material.dart';

import '../constants.dart';

class TermsOfServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Consts.primaryColor,
        title: Text('Terms of Service'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: [28/04/2023]',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'By using Our App (Plant-It-App), you agree to be bound by these Terms of Service. If you do not agree with these Terms, please do not access or use the App.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '1. Use of the App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The App is intended for your personal, non-commercial use only. You may not copy, reproduce, distribute, or create derivative works from the App or any content provided by the App without our express written permission.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. User-Generated Content',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'You are solely responsible for any content that you create, transmit, or display while using the App. By submitting content, you grant us a non-exclusive, royalty-free, worldwide license to use, reproduce, and display your content for the purposes of providing and improving the App.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. Copyright and Intellectual Property',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'All content on the App, including but not limited to text, images, graphics, and software, is the property of the App or its content suppliers and is protected by copyright and other intellectual propertylaws. Unauthorized use of such content may violate these laws and our Terms of Service.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '4. Limitation of Liability',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'In no event shall the App, its owners, employees, or affiliates be liable for any direct, indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of profits, data, or other intangible losses, resulting from the use or inability to use the App, even if we have been advised of the possibility of such damages.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '5. Changes to Terms of Service',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We reserve the right to modify these Terms of Service at any time. Your continued use of the App after any changes to these Terms constitutes your acceptance of the new Terms.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '6. Governing Law and Jurisdiction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'These Terms of Service shall be governed by and construed in accordance with the laws of [Israel], without regard to its conflict of law provisions. You agree to submit to the personal and exclusive jurisdiction of the courts located in [Country/State].',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '7. Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'If you have any questions or concerns about these Terms of Service, please contact us at [idoddii@gmail.com].',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
