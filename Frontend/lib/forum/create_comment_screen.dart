import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

import '../models/post.dart';
import '../service/http_service.dart';

class AddCommentScreen extends StatefulWidget {
  final Post post;
  final String? token;

  const AddCommentScreen({super.key, required this.post, this.token});

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
              onPressed: () async {
                String content = _commentController.text;
                if (content.isNotEmpty) {
                  await createComment(widget.post.postId, content, widget.post.plantId ,widget.token);
                  _commentController.clear();
                  Navigator.of(context).pop(true); // Return true to indicate the comment was added successfully
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a comment'),
                    ),
                  );
                }
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
