import 'package:flutter/material.dart';

class MangasListPage extends StatefulWidget {
  @override
  _MangasListPageState createState() => _MangasListPageState();
}

class _MangasListPageState extends State<MangasListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mangas"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
