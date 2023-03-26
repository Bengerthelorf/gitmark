import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Page/github.dart';
import 'Page/settting.dart';

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
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.folder),
        onPressed: () {
          
        },
      ),
      drawer: Drawer(
        child: ListView(
          // wan to add a black space at the top of the drawer, but somehow it doesn't work
          padding: EdgeInsets.all(8.0),
          children: [
            ListTile(
              title: Text('Repositories'),
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
    );
  }
}