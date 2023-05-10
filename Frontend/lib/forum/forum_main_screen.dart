import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/post.dart';

class ForumScreen extends StatefulWidget {
  final int plantId;

  ForumScreen({Key? key, required this.plantId}) : super(key: key);

  @override
  ForumScreenState createState() => ForumScreenState();
}

class ForumScreenState extends State<ForumScreen> {
  List<Post> posts = getSamplePosts();

  void _handlePostTap(Post post) {
    // Navigate to the post details screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsScreen(post: post)));
    print('Tapped on post: ${post.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Consts.primaryColor,
        title: Text('Plant Discussions', style: GoogleFonts.robotoSlab(fontSize: 22)),
      ),
      body: posts.isNotEmpty
          ? ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          Post post = posts[index];
          return buildPostCard(context, post);
        },
      )
          : Center(
        child: Text(
          'There are no posts yet.',
          style: GoogleFonts.lato(fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => PostCreationScreen(),
          //   ),
          // );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildPostCard(BuildContext context, Post post) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          _handlePostTap(post);
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  color: Consts.primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                post.description,
                style: GoogleFonts.lato(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Written by: ${post.author}',
                style: GoogleFonts.lato(fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                'Published at: ${post.date}',
                style: GoogleFonts.lato(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
