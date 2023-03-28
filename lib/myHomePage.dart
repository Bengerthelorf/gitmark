import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Page/github.dart';
import 'Page/settting.dart';
import 'Page/myHomeMarkdown.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gitmark'),
        // centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              showMenu(
            context: context, 
            position: RelativeRect.fromLTRB(100, 0, 0, 0),
            items: [
              PopupMenuItem(
                child: Text('font size'),
                value: 1,
                // onTap: () {
                //   Navigator.of(context).pop();
                //   showDialog(context: context, builder: (context) => SimpleDialog(
                //     title: Text('choose a font size'),
                //     children: [
                //       TextButton(
                //         onPressed: () {
                //           Navigator.of(context).pop();
                //         },
                //         child: Text('small'),
                //       ),
                //       TextButton(
                //         onPressed: () {
                //           Navigator.of(context).pop();
                //         },
                //         child: Text('medium'),
                //       ),
                //       TextButton(
                //         onPressed: () {
                //           Navigator.of(context).pop();
                //         },
                //         child: Text('large'),
                //       ),
                //     ],
                //   ));
                // },
              ),
              PopupMenuItem(
                child: Text('font color'),
                value: 2,
              ),
              PopupMenuItem(
                child: Text('background color'),
                value: 3,
              ),
            ],
          );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.folder),
        onPressed: () {
          showDialog(context: context, builder: (context) => SimpleDialog(
            title: Text('choose a repository'),
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('repository1'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('repository2'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('repository3'),
              ),
            ],
          ));
        },
      ),
      drawer: Drawer(
        child: ListView(
          // wan to add a black space at the top of the drawer, but somehow it doesn't work
          padding: EdgeInsets.all(8.0),
          children: [
            ListTile(
              title: Text('Github Account'),
              leading: Icon(Icons.inbox),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => github()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => setting()));
              },
            ),
          ],
        )
      ),
      body: myHomeMark(),
    );
  }
}