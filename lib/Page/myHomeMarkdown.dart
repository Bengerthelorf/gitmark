import 'package:flutter/material.dart';

class myHomeMark extends StatelessWidget {
  const myHomeMark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Markdown'),
        ],
      )
    );
  }
}