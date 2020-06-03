import 'package:flutter/material.dart';

import './screens/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiktok',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        accentColor: Color(0xFFFFC107),
      ),
      home: MyHomePage(title: 'Tic-tac-toe'),
    );
  }
}