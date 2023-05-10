import 'Comment.dart';

class Post {
  final String title;
  final String description;
  final String author;
  final DateTime date;
  final List<Comment> comments;

  Post({
    required this.title,
    required this.description,
    required this.author,
    required this.date,
    required this.comments,
  });
}

List<Post> getSamplePosts() {
  return [
    Post(
      title: 'Watering tips',
      description: 'I need help with watering my plant...',
      author: 'User1',
      date: DateTime.now().subtract(Duration(days: 1)),
      comments: [
        Comment(
          author: 'User3',
          content: 'I usually water my plant once a week.',
          date: DateTime.now().subtract(Duration(days: 1, hours: 1)),
        ),
        Comment(
          author: 'User4',
          content: 'Make sure to not overwater it.',
          date: DateTime.now().subtract(Duration(days: 1, hours: 2)),
        ),
      ],
    ),
    Post(
      title: 'Repotting advice',
      description: 'When is the best time to repot this plant?',
      author: 'User2',
      date: DateTime.now().subtract(Duration(days: 2)),
      comments: [
        Comment(
          author: 'User5',
          content: 'Spring is usually the best time for repotting.',
          date: DateTime.now().subtract(Duration(days: 2, hours: 1)),
        ),
      ],
    ),
    Post(
      title: 'Fertilizing schedule',
      description: 'How often should I fertilize my plant?',
      author: 'User6',
      date: DateTime.now().subtract(Duration(days: 3)),
      comments: [],
    ),
    Post(
      title: 'Pest control',
      description: 'What are the best ways to control pests for this plant?',
      author: 'User7',
      date: DateTime.now().subtract(Duration(days: 4)),
      comments: [],
    ),
  ];
}

