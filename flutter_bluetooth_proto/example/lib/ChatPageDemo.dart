import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import './Data.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ChatPageDemo extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPageDemo({this.server});

  @override
  _ChatPageDemo createState() => new _ChatPageDemo();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPageDemo extends State<ChatPageDemo> {
  Data bluetoothData = Data();
  
  BuildContext scaffoldContext;  
  ScrollController _scrollController; 
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
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
  bool toTop = true;
  int mapEdit;


  @override
  void initState() {
  

    super.initState();
    _scrollController = new ScrollController(                         // NEW
      initialScrollOffset: 0.0,                                       // NEW
      keepScrollOffset: true,                                         // NEW
    );
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
       _sendMessage("SS:0");
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
    scaffoldContext = context;
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
        key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: new Color(0xff622F74),
          title: (isConnecting
              ? Text('Connecting to ' + 'demo' + '...')
              : isConnected
                  ? Text('Live data with ' + 'demo')
                  : Text('Data log with ' + 'demo')),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.devices),
            onPressed: 
               isConnected
                          ? () => _sendMessage("param")
                          : null
             
          ),
        ],
      ),

      body: SafeArea(
        child: StaggeredGridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              controller: _scrollController,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
              children: <Widget>[
                  
              myItems(Icons.graphic_eq,"Map:0",setmap==0? Colors.green[300]:Colors.grey[300],"SetMap:0",true),
              myItems(Icons.graphic_eq,"Map:1",setmap==1? Colors.green[300]:Colors.grey[300],"SetMap:1",true),
              myItems(Icons.graphic_eq,"Map:2",setmap==2? Colors.green[300]:Colors.grey[300],"SetMap:2",true),
              myItems(Icons.notifications,"Monitor",ssvalue==1? Colors.blue[300]:Colors.grey[300],"SS:" + ssvalue.toString(),true),
              Container(
                  margin: const EdgeInsets.all(8.0),
            
                  child: SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(minimum: 0, maximum: 12000,
                  ranges: <GaugeRange>[
                  GaugeRange(startValue: 0, endValue: 4000, color:Colors.green),
                  GaugeRange(startValue: 4000,endValue: 8000,color: Colors.orange),
                  GaugeRange(startValue: 8000,endValue: 12000,color: Colors.red)],
                  pointers: <GaugePointer>[
                  NeedlePointer(value: txtvoltagevalue)],
                  annotations: <GaugeAnnotation>[
                  GaugeAnnotation(widget: Container(child: 
                    Text(dblVoltage.toStringAsFixed(2) + " V",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                    angle: 90, positionFactor: 0.5
                  )]
                )])
      
              ),
              myItems(Icons.content_copy,toTop?"Advanced Settings":"Basic Settings",Colors.purple[300],"ConfigPage",false),
                            //page 2
              myItems(Icons.create,"MAP 1",Colors.purple[300],"Map1",false),
              myItems(Icons.create,"BBBB",Colors.purple[300],"",false),
              myItems(Icons.create,"CCCC",Colors.purple[300],"",false),
              myItems(Icons.create,"DDD",Colors.purple[300],"",false),
              ],
              staggeredTiles: [
                StaggeredTile.extent(1,130.0),
                StaggeredTile.extent(1,130.0),
                StaggeredTile.extent(1,130.0),
                StaggeredTile.extent(3, 130.0),
                StaggeredTile.extent(3, 250.0),
                StaggeredTile.extent(3, 130.0),
                                //page 2
                StaggeredTile.extent(3,130.0),
                StaggeredTile.extent(3,130.0),
                StaggeredTile.extent(3,130.0),
                StaggeredTile.extent(3,130.0)
              ],
            ),
      // appBar: AppBar(
      //     title: (isConnecting
      //         ? Text('Connecting to ' + widget.server.name + '...')
      //         : isConnected
      //             ? Text('Live data with ' + widget.server.name)
      //             : Text('Data log with ' + widget.server.name))),
      // body: SafeArea(
      //   child: Column(
      //     children: <Widget>[
      //       //
      //         RaisedButton(
      //             onPressed:  isConnected
      //                     ? () => _sendMessage("param")
      //                     : null),
      //           Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           mainAxisSize: MainAxisSize.min,
      //           children: <Widget>[
      //             new Text('Get udpates'),
      //             new Icon(Icons.update),
      //           ],
              
      //       ),
      //           Container(
      //             margin: const EdgeInsets.all(8.0),
      //             child: IconButton(
      //                 color: setmap==0? Colors.green[300]:Colors.grey[300],
                      
      //                 icon: const Icon(Icons.map),
      //                 onPressed: isConnected
      //                     ? () => _sendMessage("SetMap:0")
      //                     : null),
      //           ),
      //           Container(
      //             margin: const EdgeInsets.all(8.0),
      //             child: IconButton(
      //                 color: setmap==1? Colors.green[300]:Colors.grey[300],
      //                 icon: const Icon(Icons.map),
      //                 onPressed: isConnected
      //                     ? () => _sendMessage("SetMap:1")
      //                     : null),
      //           ),
      //           Container(
      //             margin: const EdgeInsets.all(8.0),
      //             child: IconButton(
      //                 color: setmap==2? Colors.green[300]:Colors.grey[300],
      //                 icon: const Icon(Icons.map),
      //                 onPressed: isConnected
      //                     ? () => _sendMessage("SetMap:2")
      //                     : null),
      //           ),
      //           Container(
      //             margin: const EdgeInsets.all(8.0),
      //             child: IconButton(
      //                 color: setmap==2? Colors.green[300]:Colors.grey[300],
      //                 icon: const Icon(Icons.shutter_speed),
      //                 onPressed:
      //                     isConnected
      //                     ? () => _sendMessage("SS:" + ssvalue.toString())
      //                     : null),
      //           ),
      //          Container(    
                          
      //             margin: const EdgeInsets.all(8.0),
      //             child:  TextField(
      //             controller: txtVoltage,
      //             textAlign: TextAlign.center,
      //             decoration: InputDecoration(
      //             hintText: txtvoltagevalue.toString(),
      //             ),
      //           ),
      //          ),
              
      //          Container(    
                          
      //             margin: const EdgeInsets.all(8.0),
      //             child:  TextField(
      //             controller: txtValue,
      //             textAlign: TextAlign.center,
      //             decoration: InputDecoration(
      //             hintText: txtValue.toString(),
      //             ),
      //           ),
      //          ),
      //        // Container(
      //         //    margin: const EdgeInsets.all(8.0),
      //         ////FlutterGauge(inactiveColor: Colors.white38,activeColor: Colors.white,handSize: 30,width: 200,index: 65.0,fontFamily: "Iran",end: 400,number: Number.none,secondsMarker: SecondsMarker.minutes,isCircle: false,hand: Hand.none,counterAlign: CounterAlign.center,counterStyle: TextStyle(color: Colors.white,fontSize: 30,),isDecimal: false,)),
      //         //child: FlutterGauge(width: 150,
      //         //index: dblVoltage,
      //         //fontFamily: "Iran",counterStyle: TextStyle(color: Colors.black,fontSize: 35,),numberInAndOut: NumberInAndOut.outside,counterAlign: CounterAlign.center,secondsMarker: SecondsMarker.secondsAndMinute,hand: Hand.short,start: 0,end: 5,),
      //       //),
      //       //
      //       Flexible(
      //         child: ListView(
      //             padding: const EdgeInsets.all(12.0),
      //             controller: listScrollController,
      //             children: list),
      //       ),
      //       Row(
      //         children: <Widget>[
      //           Flexible(
      //             child: Container(
      //               margin: const EdgeInsets.only(left: 16.0),
      //               child: TextField(
      //                 style: const TextStyle(fontSize: 15.0),
      //                 controller: textEditingController,
      //                 decoration: InputDecoration.collapsed(
      //                   hintText: isConnecting
      //                       ? 'Wait until connected...'
      //                       : isConnected
      //                           ? 'Type your message...'
      //                           : 'Chat got disconnected',
      //                   hintStyle: const TextStyle(color: Colors.grey),
      //                 ),
      //                 enabled: isConnected,
      //               ),
      //             ),
      //           ),
      //           Container(
      //             margin: const EdgeInsets.all(8.0),
      //             child: IconButton(
      //                 icon: const Icon(Icons.send),
      //                 onPressed: isConnected
      //                     ? () => _sendMessage(textEditingController.text)
      //                     : null),
      //           ),
      //         ],
      //       )
      //     ],
      //   ),
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
     //createSnackBar(dataString);
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
    if(splitvalue[1] != "OK" ){
      if(splitvalue[1] != "1" && splitvalue[1] != "0"){
        var voltagevalue = splitvalue[1].split(",");
        dblVoltage =double.parse(voltagevalue[0]);
        txtVoltage.text = voltagevalue[0] + " V";
        txtvoltagevalue = double.parse(voltagevalue[1]);
        txtValue.text = voltagevalue[1];
      }
    }
  }
  
  
  if(data.contains("SetMap:"))
  {
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK"  ){
      setmap = int.parse(splitvalue[1]);
    }
  }
  
  if(data.contains("Map1:"))
  {
    bluetoothData.MAP1 = new List<int>();
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK" ){
      
       var mapsplit = splitvalue[1].split(","); 

       for (int i = 0; i < mapsplit.length; i++) {
         bluetoothData.MAP1.add(int.parse(mapsplit[i]));
         
        }
    }
  }
  
  if(data.contains("IdelRPM:"))
  {
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK"  ){
      bluetoothData.IdelRPM = int.parse(splitvalue[1]);
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
 if(data != "ConfigPage"){
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
 else{
   if(toTop){
    toTop = false;
    //_startChatDemo(context,);
    _toEnd();
   }
   else{
     toTop = true;
     _toEnd();
   }
 }
  
}

void _sendMessageType(String text,bool msgType) async {
  if(msgType)
  {
    _sendMessage(text);
  }
  else
  {
    _sendAppMessage(text);
  }
}

void _sendAppMessage(String text) async {
  if(text == "ConfigPage"){
     _setData(text);
  }
  if(text == "Map1")
  {
    try{
      if(bluetoothData.MAP1 ==null){ 
      bluetoothData.MAP1 =new List<int>();
      var mapsplit = "120,120,115,115,115,115,115,115,115,115,115,115,115,115,115,115,115,115,115,115,120"; //splitvalue[1].split(","); 
      var counter = mapsplit.split(",");
        for (int i = 0; i <= counter.length-1; i++) {
          bluetoothData.MAP1.add(int.parse(counter[i]));
          
        }
      }
    mapEdit = 1;
    //showToast();
    //showDialog();
    _mapEdit();
  //  showDialog(context: context,builder: (context) => _onTapTable(context));
  
    }
    catch(e){
      print(e);
    }
  }
}

  void _sendMessage(String text) async {
    if(text != "ConfigPage"){
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
    else{
      _setData(text);
    }
  }

  Material myItems(IconData icon, String heading, Color color,String msg,bool msgType){
  return Material(
    color:Colors.white,
    elevation: 14.0,
    //shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(24.0),
    child: Center(  
      child: Padding(  
        padding: const EdgeInsets.all(8.0),
        child: Row(  
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(  
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                //text
                Padding(
                  
                  padding: const EdgeInsets.all(8.0),

                    child: Text(heading, 
                    style: TextStyle(  
                      color:  color,
                      fontSize: 20.0,
                    ),
                    
                    ),
                    
                ),

                //icon / graph
               
                Material(  
                  color: color,
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    
                    child: 
                  new GestureDetector(
                  onTap: 
                   // Navigator.pushNamed(context, "myRoute");
                  
                     isConnected
                          ? () => _sendMessageType(msg,msgType)
                          : null,
                    child: Icon(  
                      icon,
                      color: Colors.white,
                      size: 30.0,
                      
                    ),
                  )
                  )
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Future<Null> _mapEdit() async {
  List<int> list = [for(var i=2500; i<=12000; i+=500) i];
  list.insert(0, bluetoothData.IdelRPM.toString() == null?bluetoothData.IdelRPM.toString():1800); //add idlerpm value here
  List<int> finallist = [];
  //finallist.add(bluetoothData.MAP1[0]); 
 
  for (var i = 0; i < bluetoothData.MAP1.length; i++) {
    finallist.add(bluetoothData.MAP1[i]);
  }
 

  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    child: new AlertDialog(
      contentPadding: const EdgeInsets.all(10.0),
      title: new Text(
        'MAP : ' + mapEdit.toString(),
        style:
        new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      content: 
      
      new Container(
        // Specify some width
        width: MediaQuery.of(context).size.width * .5,
        child: new GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            children: List.generate(21, (index) {
           
             //return index.isEven
                //?
            
              return   Column(
              children:<Widget> [
                 index != 0?
                 Text(list[index].toString(),
                 style: TextStyle(backgroundColor: Colors.white),
                                //style: Theme.of(context).textTheme.headline6,
                                  )
                                  :
                  TextField(
                  style: TextStyle(backgroundColor: Colors.orange[300]),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                                  hintText: list[index].toString(),
                                  
                                ),
                  onChanged: (newVal) {
                      list[index] = int.parse(newVal);
                  }
                              ),
              //Expanded(child: Container()),
                TextField(
                  style: TextStyle(backgroundColor: index==0?Colors.orange[300]:Colors.white),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                                  hintText: finallist[index].toString(),
                                  
                                ),
                  onChanged: (newVal) {
                      finallist[index] = int.parse(newVal);
                  }
                              )
                      ],);})),
                      
                      ),
                      actions: <Widget>[

                      Container(
                                    child:  FlatButton.icon(
                                        onPressed: () {
                                          setState(() {});
                                          finallist.insert(0, list[0]);
                                          _decodeparams(finallist);
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.save_alt,color: Colors.white,),
                                        label: Text("Save",style:
                                        new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
                                        color: Colors.purple[300],
                                  ),
                      ],
                   
  )
  );



}

void _decodeparams(List<int> paramarrays){
  bluetoothData.IdelRPM = (paramarrays[0] / 10).round();
  bluetoothData.MAP1 =  [];
  for (var i = 1; i < paramarrays.length; i++) {
    bluetoothData.MAP1.add(paramarrays[i]);
  }
  
  String idleRPMstr = "IdelRPM:" + bluetoothData.IdelRPM.toString();
  _sendMessage(idleRPMstr);
  print(idleRPMstr);

  String map1array = "MAP1:";
  for(var i = 0; i < bluetoothData.MAP1.length;i++){
      map1array = map1array + bluetoothData.MAP1[i].toString() + ",";
  }
  _sendMessage(map1array);
  print(map1array);
}
 void _toEnd() {                                                     // NEW
    _scrollController.animateTo(                                      // NEW
      toTop?_scrollController.position.minScrollExtent:_scrollController.position.maxScrollExtent,                     // NEW
      duration: const Duration(milliseconds: 500),                    // NEW
      curve: Curves.ease,                                             // NEW
    );                                                                // NEW
  }    

}
