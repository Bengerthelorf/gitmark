import 'package:flutter/material.dart';

class MarkdownPage extends StatefulWidget {
  @override
  State<MarkdownPage> createState() => _MarkdownPageState();
}

class _MarkdownPageState extends State<MarkdownPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          // Text('Markdown Page page'),

          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: MaekdownPage()
            )
            )

        ],
      ),
    );
  }
}


class MaekdownPage extends StatelessWidget {
  const MaekdownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Card(
      color: theme.colorScheme.background,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10, height: 10), // <--- Add this line
                Text(
                  'MarkdownText',
                  style: style.copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
