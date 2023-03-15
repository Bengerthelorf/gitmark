import 'package:flutter/material.dart';

class MarkdownPage extends StatefulWidget {
  @override
  State<MarkdownPage> createState() => _MarkdownPageState();
}

class _MarkdownPageState extends State<MarkdownPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Markdown Page page'),
        ],
      ),
    );
  }
}