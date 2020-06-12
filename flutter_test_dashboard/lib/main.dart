import 'package:flutter/material.dart';
import 'package:scodix_dashboard/dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scodix Dashboard',
      theme: ThemeData(
        primaryColor: new Color(0xff622F74),
      ),
      home: Dashboard(),
    );
  }
}

