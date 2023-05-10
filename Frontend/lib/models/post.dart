import 'comment.dart';

class Post {
  final int postId;
  final int plantId;
  final String title;
  final String description;
  final String author;
  final DateTime date;
  final String profilePic;
  List<Comment>? comments;

  Post({
    required this.postId,
    required this.title,
    required this.description,
    required this.author,
    required this.date,
    required this.profilePic,
    required this.plantId,
    this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      postId: json['id'],
      title: json['title'],
      description: json['content'],
      author: json['user']['username'],
      profilePic: json['user']['profile_picture'],
      date: DateTime.parse(json['date_posted']),
      plantId: json['plant'],
    );
  }
}

