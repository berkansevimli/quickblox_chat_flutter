import 'package:flutter/material.dart';

class ShowFollows extends StatefulWidget {
  ShowFollows({Key? key}) : super(key: key);

  @override
  _ShowFollowsState createState() => _ShowFollowsState();
}

class _ShowFollowsState extends State<ShowFollows> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Takip Ettiklerim"),),
      body: Center(child: Text("Select User"),),
    );
  }
}
