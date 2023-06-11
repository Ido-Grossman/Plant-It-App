import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

enum ChatBubbleType { sent, received }

class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final ChatBubbleType type;

  const ChatBubble({super.key, required this.message, required this.time, required this.type});

  // The fromJson constructor
  factory ChatBubble.fromJson(Map<String, dynamic> json) {
    return ChatBubble(
      message: json['message'],
      time: json['time'],
      type: ChatBubbleType.values.firstWhere((e) => e.toString() == 'ChatBubbleType.${json['type']}'),
    );
  }

  // Converting ChatBubble object to json
  Map<String, dynamic> toJson() => {
    'message': message,
    'time': time,
    'type': type.toString().split('.').last,
  };


  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color textColor;
    if (Theme.of(context).brightness == Brightness.dark) {
      bgColor = type == ChatBubbleType.received ? Consts.primaryColor : Colors.grey[800]!; // change to any color you want
      textColor = Colors.white;
    } else {
      bgColor = type == ChatBubbleType.received ? Consts.primaryColor : Colors.grey[200]!;
      textColor = Colors.black;
    }

    final align = type == ChatBubbleType.received ? CrossAxisAlignment.start : CrossAxisAlignment.end;

    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                message,
                style: TextStyle(color: textColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
