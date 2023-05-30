import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../service/http_service.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String? token;
  const ChatScreen({super.key, required this.token});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  bool _isWaiting = false;
  List<ChatBubble> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Consts.primaryColor,
        title: const Text('Chat with bot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (ctx, index) => _messages[index],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 8.0, 8.0), // increased top padding
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !_isWaiting,
                    decoration: InputDecoration(
                      labelText: 'Type your message here',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isWaiting ? null : _sendMessage,
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: _isWaiting
                ? CircularProgressIndicator(key: ValueKey<int>(1))
                : Container(key: ValueKey<int>(0)),
          ),

        ],

      ),
    );
  }


  void _sendMessage() async {
    final question = _controller.text;
    if (question.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add(ChatBubble(
        message: question,
        time: DateFormat('HH:mm').format(DateTime.now()),
        type: ChatBubbleType.sent,
      ));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
    setState(() {
      _isWaiting = true;
    });

    final response = await chatBotMsg(widget.token, question);

    setState(() {
      _isWaiting = false;
      _messages.add(ChatBubble(
        message: response,
        time: DateFormat('HH:mm').format(DateTime.now()),
        type: ChatBubbleType.received,
      ));
    });
    _saveMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMessages = prefs.getStringList('messages') ?? [];
    setState(() {
      _messages = savedMessages
          .map((message) => ChatBubble.fromJson(json.decode(message)))
          .toList()
          .cast<ChatBubble>();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'messages',
      _messages.map((message) => json.encode(message.toJson())).toList(),
    );
  }

}
