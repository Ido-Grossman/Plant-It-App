import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class AddCommentScreen extends StatefulWidget {
  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Consts.primaryColor,
        automaticallyImplyLeading: false,
        title: Text('Add a comment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Enter your comment',
                labelStyle: TextStyle(color: Consts.primaryColor),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Consts.primaryColor),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle comment creation logic
                String content = _commentController.text;
                if (content.isNotEmpty) {
                  // Save the comment and update the UI
                  print('Comment created: $content'); // Replace with your comment creation logic
                  _commentController.clear();
                }
                Navigator.of(context).pop();
              },
              child: Text('Submit Comment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Consts.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
