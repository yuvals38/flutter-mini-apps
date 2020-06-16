import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_gauge/flutter_gauge.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;
  String param = "";
  int setmap = 3;
  
  final txtVoltage = TextEditingController();
  final txtValue = TextEditingController();
  double txtvoltagevalue = 0.0;
  int ssvalue = 0;
  bool timerrunner = false;
  double dblVoltage = 0.0;




  @override
  void initState() {
  

    super.initState();
    
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
       _sendMessage("param");

      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
       _sendMessage("SS:0");
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
          title: (isConnecting
              ? Text('Connecting to ' + widget.server.name + '...')
              : isConnected
                  ? Text('Live data with ' + widget.server.name)
                  : Text('Data log with ' + widget.server.name))),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //
              RaisedButton(
                  onPressed:  isConnected
                          ? () => _sendMessage("param")
                          : null),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text('Get udpates'),
                  new Icon(Icons.update),
                ],
              
            ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                      color: setmap==0? Colors.green[300]:Colors.grey[300],
                      
                      icon: const Icon(Icons.map),
                      onPressed: isConnected
                          ? () => _sendMessage("SetMap:0")
                          : null),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                      color: setmap==1? Colors.green[300]:Colors.grey[300],
                      icon: const Icon(Icons.map),
                      onPressed: isConnected
                          ? () => _sendMessage("SetMap:1")
                          : null),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                      color: setmap==2? Colors.green[300]:Colors.grey[300],
                      icon: const Icon(Icons.map),
                      onPressed: isConnected
                          ? () => _sendMessage("SetMap:2")
                          : null),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                      color: setmap==2? Colors.green[300]:Colors.grey[300],
                      icon: const Icon(Icons.shutter_speed),
                      onPressed:
                          isConnected
                          ? () => _sendMessage("SS:" + ssvalue.toString())
                          : null),
                ),
               Container(    
                          
                  margin: const EdgeInsets.all(8.0),
                  child:  TextField(
                  controller: txtVoltage,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                  hintText: txtvoltagevalue.toString(),
                  ),
                ),
               ),
              
               Container(    
                          
                  margin: const EdgeInsets.all(8.0),
                  child:  TextField(
                  controller: txtValue,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                  hintText: txtValue.toString(),
                  ),
                ),
               ),
             // Container(
              //    margin: const EdgeInsets.all(8.0),
              ////FlutterGauge(inactiveColor: Colors.white38,activeColor: Colors.white,handSize: 30,width: 200,index: 65.0,fontFamily: "Iran",end: 400,number: Number.none,secondsMarker: SecondsMarker.minutes,isCircle: false,hand: Hand.none,counterAlign: CounterAlign.center,counterStyle: TextStyle(color: Colors.white,fontSize: 30,),isDecimal: false,)),
              //child: FlutterGauge(width: 150,
              //index: dblVoltage,
              //fontFamily: "Iran",counterStyle: TextStyle(color: Colors.black,fontSize: 35,),numberInAndOut: NumberInAndOut.outside,counterAlign: CounterAlign.center,secondsMarker: SecondsMarker.secondsAndMinute,hand: Hand.short,start: 0,end: 5,),
            //),
            //
            Flexible(
              child: ListView(
                  padding: const EdgeInsets.all(12.0),
                  controller: listScrollController,
                  children: list),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      style: const TextStyle(fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: isConnecting
                            ? 'Wait until connected...'
                            : isConnected
                                ? 'Type your message...'
                                : 'Chat got disconnected',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      enabled: isConnected,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: isConnected
                          ? () => _sendMessage(textEditingController.text)
                          : null),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    //decifer params
     _getData(dataString);
     print(dataString);
    //
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
    _getData(messages[messages.length-1].text.toString());
    
  }
 

void  _getData(String data)  {
 
 //_counter = _counter + 1;
 // txtVoltage.text = data + " -- " + _counter.toString() ;
  
  //var ok = data.contains("SS:");
  if(data.contains("SS:"))
  {
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK" && (splitvalue[1] != "1" || splitvalue[1] != "0") ){
      var voltagevalue = splitvalue[1].split(",");
      dblVoltage =double.parse(voltagevalue[0]);
      txtVoltage.text = voltagevalue[0] + " V";

      txtValue.text = voltagevalue[1];
    }
  }
  
  if(data.contains("SetMap:"))
  {
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK"  ){
      setmap = int.parse(splitvalue[1]);
    }
  }

    var delim = data.split(":");

    switch(delim[0]) { 
      case "SetMap": { 
         setmap = int.parse(delim[1]);
      } 
      break; 
      
      case "Map1": { 
          //statements; 
      } 
      break; 
      case "SS" : {
        //if(delim[1] != "OK"){
         // var ssdelim = delim[1].split(",");
         // txtvoltagevalue = double.parse(ssdelim[0]);
       // }
       
      }
      break;
      default: { 
          //statements;  
      }
      break; 
    } 
  setState(() {});

  }


void _setData(String data) async {
 
    var delim = data.split(":");

    switch(delim[0]) { 
      case "SetMap": { 
         setmap = int.parse(delim[1]);
      } 
      break; 
      
      case "Map1": { 
          //statements; 
      } 
      break; 
      case "SS" : {
        if (ssvalue == 0)
          {
            ssvalue = 1;
              
          }
          else
          {
            ssvalue = 0;
            
           
          }
      }
      break;
      default: { 
          //statements;  
      }
      break; 
    } 
  
}

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();
    
    _setData(text);

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
               // _getData(messages[messages.length-1].toString());
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
