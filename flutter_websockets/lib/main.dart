import 'package:flutter/foundation.dart';
import 'package:flutter_websockets/tts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

void main() => runApp(MyApp());

enum TtsState { playing, stopped }
String _newVoiceText;
FlutterTts flutterTts;
//TabController _controller2;



class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final title = 'reply from websocket (+speech)';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: MyHomePage(
        title: title,
        channel: IOWebSocketChannel.connect('ws://demos.kaazing.com/echo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  
  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();

}



class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  

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

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
 TtsState ttsState = TtsState.stopped;
 @override
  initState() {
    super.initState();
    initTts();
  }

  
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: 
         
          Padding(
            padding: const EdgeInsets.all(20.0),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: <Widget>[
                Form(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Send a message to ws://demos.kaazing.com/echo'),
                    onChanged: (String value) {

                        _onChange(value);
                      },
                  ),
                ),
                StreamBuilder(
                  stream: widget.channel.stream,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        snapshot.hasData ? '${snapshot.data}' : ''),
                      /* new TextField(
                      
                      onChanged: (String value) {

                        _onChange(value);
                      },),*/

                    );
                    
                  },
                ),
              
               Expanded(
          child: Child1Page()
          
        ),
              ],
              
            ),
          ),
          
           
          floatingActionButton: FloatingActionButton(
            onPressed: _sendMessage,

           

            tooltip: 'Send message',
            child: Icon(Icons.send),
          ), // This trailing comma makes auto-formatting nicer for build methods.
          //
       
        
        );
             
          
          
          //
    
    
        //widget
        
      }
    

void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

    Future _speak() async {
      if(_newVoiceText != null || isPlaying )
        {     
          var result = await flutterTts.speak(_newVoiceText);
          if (result == 1) setState(() => ttsState = TtsState.playing);
        }
  }
      void _sendMessage() {
        if (_controller.text.isNotEmpty) {
          widget.channel.sink.add(_controller.text);
          _speak();
        }
      }
    
      @override
      void dispose() {
        widget.channel.sink.close();
        super.dispose();
        flutterTts.stop();
      }
    
  

    
}