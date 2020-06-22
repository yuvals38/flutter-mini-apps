import 'package:flutter/material.dart';

import './MainPage.dart';
import './SelectBondedDevicePage.dart';
void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainPage());
    //return MaterialApp(home: SelectBondedDevicePage());
  }
}
