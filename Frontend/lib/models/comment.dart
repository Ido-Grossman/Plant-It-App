class Comment {
  final String author;
  final String content;
  final DateTime date;

  Comment({required this.author, required this.content, required this.date});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      author: json['user'],
      content: json['content'],
      date: DateTime.parse(json['date_posted']),
    );
  }
}
