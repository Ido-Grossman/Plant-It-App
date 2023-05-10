class Post {
  final String title;
  final String description;
  final String author;
  final DateTime date;

  Post({required this.title, required this.description, required this.author, required this.date});
}

List<Post> getSamplePosts() {
  return [
    Post(
      title: 'Watering tips',
      description: 'I need help with watering my plant...',
      author: 'User1',
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Post(
      title: 'Repotting advice',
      description: 'When is the best time to repot this plant?',
      author: 'User2',
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
  ];
}
