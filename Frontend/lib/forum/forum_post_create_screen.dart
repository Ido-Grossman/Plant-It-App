import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/service/http_service.dart';

class PostCreationScreen extends StatefulWidget {
  final String? token;
  final int plantId;

  const PostCreationScreen({super.key, required this.token, required this.plantId});

  @override
  _PostCreationScreenState createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        backgroundColor: Consts.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter the title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Enter the description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Consts.primaryColor,
        onPressed: () async {
          // Handle post creation logic
          String title = _titleController.text;
          String description = _descriptionController.text;
          if (title.isNotEmpty && description.isNotEmpty) {
            // Save the post and navigate back to the previous screen
            await createPost(widget.plantId, widget.token, title, description);
            Navigator.pop(context, true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please fill in both title and description'),
              ),
            );
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
