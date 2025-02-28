import 'package:flutter/material.dart';
import '../widgets/markdown_renderer.dart';

class MarkdownView extends StatelessWidget {
  final String title;
  final String content;

  const MarkdownView({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: MarkdownRenderer(
        markdown: content,
      ),
    );
  }
}