import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/service/http_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import 'forum_post_create_screen.dart';
import 'forum_post_screen.dart';

class ForumScreen extends StatefulWidget {
  final int plantId;
  final String? token;

  ForumScreen({Key? key, required this.plantId, required this.token}) : super(key: key);

  @override
  ForumScreenState createState() => ForumScreenState();
}

class ForumScreenState extends State<ForumScreen> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      List<Post> fetchedPosts =
      await getPosts(widget.plantId, widget.token);
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print(e);
    }
  }

  void _handlePostTap(Post post) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(post: post, token: widget.token,)));
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
        backgroundColor: Consts.primaryColor,
        heroTag: 'createPostButton',
        onPressed: () async {
          bool? refreshPosts = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostCreationScreen(plantId: widget.plantId, token: widget.token)),
          );
          if (refreshPosts == true) {
            await fetchPosts();
          }
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
                'Published at: ${DateFormat("y MMM d 'at' hh:mm a").format(post.date.toLocal())}',
                style: GoogleFonts.lato(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
