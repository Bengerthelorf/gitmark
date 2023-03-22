import 'package:flutter/material.dart';
import 'package:github/github.dart';

class GithubPage extends StatefulWidget {
  @override
  State<GithubPage> createState() => _GithubPageState();
}

class _GithubPageState extends State<GithubPage> {
  final List<String> _fruits = ['Apple', 'Banana', 'Cherry', 'Durian'];
  String? _selectedFruit;
  final github = GitHub(auth: Authentication.anonymous());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          Positioned(
            top: 0,
            left: 0,
            child: 
            
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _selectedFruit = value;
              });
            },
            itemBuilder: (BuildContext ctx) {
              print('itemBuilder');
              return _fruits.map<PopupMenuItem<String>>((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              
              // 

              }).toList();
            },
          ),

          ),

          Positioned(
            left: 0,
            right: 0,
            top: 50,
            bottom: 0,
            child: Center(
              child: BranchCard()
            )
            )
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
    var style = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onSecondary,
    );

    return Card(
      color: theme.colorScheme.secondary,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10, height: 10), // <--- Add this line
                Text(
                  'Text',
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

