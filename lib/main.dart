import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'myHomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gitmark",
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
}
}