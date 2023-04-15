import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String? username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    String? name;
    if (widget.username == null) {
      final user = FirebaseAuth.instance.currentUser!;
      name = user.displayName;
    } else {
      name = widget.username;
    }

    return Scaffold(
      body: Center(
        child: Text('Name: $name'),
      ),
    );
  }
}
