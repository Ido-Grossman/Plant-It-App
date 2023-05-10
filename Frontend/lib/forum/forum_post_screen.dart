import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:intl/intl.dart';

import '../models/comment.dart';
import '../models/post.dart';
import '../service/http_service.dart';
import 'create_comment_screen.dart';

class PostScreen extends StatefulWidget {
  final Post post;
  final String? token;

  PostScreen({Key? key, required this.post, this.token}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture =
        fetchComments(widget.post.postId, widget.post.plantId, widget.token);
  }

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.post.profilePic),
                  radius: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.title,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Written by ${widget.post.author} - ${DateFormat("y MMM d 'at' hh:mm a").format(widget.post.date.toLocal())}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
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
            FutureBuilder<List<Comment>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Comment> comments = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      Comment comment = comments[index];
                      return Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment.content),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(width: 8),
                                Text(
                                    'From: ${comment.author} - ${DateFormat("y MMM d 'at' hh:mm a").format(comment.date.toLocal())}'),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Consts.primaryColor,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCommentScreen(
                post: widget.post,
                token: widget.token,
              ),
            ),
          );
          if (result != null && result) {
            setState(() {
              _commentsFuture = fetchComments(
                  widget.post.postId,
                  widget.post.plantId,
                  widget.token); // Refresh comments after adding a new one
            });
          }
        },
        child: Icon(Icons.add_comment),
      ),
    );
  }
}
