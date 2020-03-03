import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

//void main() => runApp(new MyApp());

/*class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}*/

class Child1Page extends StatefulWidget {
  final String title;

  const Child1Page({Key key, this.title}) : super(key: key);

  @override
  _Child1PageState createState() => _Child1PageState();

  
}


enum TtsState { playing, stopped }
FlutterTts flutterTts;
List<dynamic> languages;
//class _MyAppState extends State<MyApp> {
  
class _Child1PageState extends State<Child1Page> {
  

  String _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  @override
  initState() {
    super.initState();
    initTts();
  }

  

  void initTts() async {
    flutterTts = new FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    languages = await flutterTts.getLanguages;
    setState(() {
      languages;
    });
  }

  Future _speak() async {
    var result = await flutterTts.speak(_newVoiceText);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  String language;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String type in languages) {
      items.add(new DropdownMenuItem(value: type, child: new Text(type)));
    }
    return items;
  }

  void changedDropDownItem(String selectedType) {
    try{
    setState(() {
      language = selectedType;
      flutterTts.setLanguage(language);
    });
    }
    catch(e)
    {
      //...
    }
  }

/*
  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }
*/


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        
          body: languages != null ? _buildRow() : null),
    );
  }

  Widget _buildRow() => new Column(children: <Widget>[
       /* new Container(
            alignment: Alignment.topCenter,
            padding: new EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
            child: new TextField(
              onChanged: (String value) {
                _onChange(value);
              },
            )),*/
        new Container(
            padding: new EdgeInsets.only(top: 200.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                /*  new IconButton(
                      icon: new Icon(Icons.play_arrow),
                      onPressed: _newVoiceText == null || isPlaying
                          ? null
                          : () => _speak(),
                      color: Colors.green,
                      splashColor: Colors.greenAccent),
                  new IconButton(
                      icon: new Icon(Icons.stop),
                      onPressed: isStopped ? null : () => _stop(),
                      color: Colors.red,
                      splashColor: Colors.redAccent),
                      */
                  new DropdownButton(
                    value: language,
                    items: getDropDownMenuItems(),
                    onChanged: changedDropDownItem,
                  )
                ]))
      ]);
}
