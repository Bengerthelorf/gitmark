import 'package:flutter/material.dart';

class GithubPage extends StatefulWidget {
  @override
  State<GithubPage> createState() => _GithubPageState();
}

class _GithubPageState extends State<GithubPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
            // do something
            },
            // ignore: sort_child_properties_last
            child: Text('branch'),
            style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
              ),
            // other properties
            ),
          ),
          //Dropdownbuttomstart

          // Dropdown buttom end
          BranchCard(),
        ],
      ),
    );
  }
}

class BranchCard extends StatelessWidget {
  const BranchCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.headlineSmall!.copyWith(
    color: theme.colorScheme.onSecondary,
    );

    return Card(
      color: theme.colorScheme.secondary,
      child: Column(
        children: [
          Text(
            'Branch Card',
            style: style.copyWith(fontWeight: FontWeight.w200),

          ),
        ],
      ),
    );
  }
}

