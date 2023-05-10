import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/forum/create_comment_screen.dart';

import '../models/Comment.dart';
import '../models/post.dart';

class PostScreen extends StatefulWidget {
  final Post post;

  PostScreen({Key? key, required this.post}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
        backgroundColor: Consts.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/default_avatar.png'),
                  // Replace with user's profile image
                  radius: 20,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.author,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${widget.post.date}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              widget.post.description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
            Text(
              'Comments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.post.comments.length,
              itemBuilder: (context, index) {
                Comment comment = widget.post.comments[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.content,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${comment.author} - ${comment.date}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Consts.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCommentScreen(),
            ),
          );
        },
        child: Icon(Icons.add_comment),
      ),
    );
  }
}
