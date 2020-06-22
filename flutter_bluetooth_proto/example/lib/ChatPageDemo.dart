import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import './Data.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:async/async.dart';

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
  Timer _timer;
  //BuildContext scaffoldContext;  
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
  int txtvoltagevalue = 0;
  int ssvalue = 0;
  bool timerrunner = false;
  double dblVoltage = 0.0;
  bool toTop = true;
  int mapEdit;
  String fullmsg;
  //final AsyncMemoizer _memoizer = AsyncMemoizer();
  //bool firstTime = true;

  double selectedDropDownValue = 0.5;
  int selectedDropDownRPMslopeValue = 40;
  int selectedDropDownRPMslopeONValue = 0;
  int selectedO2BPstr ;
  Future<dynamic> _futureO2Val;
  Future<dynamic> _futureO2BP;
  Future<dynamic> _futureRPMslope;
  Future<dynamic> _futureRPMslope_ON;
  Future<dynamic> _futureMap1;
  Future<dynamic> _futureMap2;
  Future<dynamic> _futureAcc0;
  Future<dynamic> _futureAcc1;
  Future<dynamic> _futureAcc2;
  Future<dynamic> _futureidleRPM;

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
        //firstTime = false;
       // _sendMessage("SS:0");
        //_sendMessage("param");

      setState(() {
         _sendMessage("param");
        // _sendMessage("SS:0");
        // _sendMessage("param");
        
        // _futureO2Val =  getO2Val();
        // _futureO2BP = getO2BP();
        // _futureRPMslope_ON = getRPMslope_ON();
        // _futureRPMslope = getRPMslope();
        // _futureMap1 = _getMaps("Map1");
        // _futureMap2 = _getMaps("Map2");
        // _futureAcc0 = _getMaps("Acc0");
        // _futureAcc1 = _getMaps("Acc1");
        // _futureAcc2 = _getMaps("Acc2");
        // _futureidleRPM = _getIdleRPM();

        isConnecting = false;
        isDisconnecting = false;
      });

      
 

      //  _futureO2Val =  getO2Val();
      //   _futureO2BP = getO2BP();
      //   _futureRPMslope_ON = getRPMslope_ON();
      //   _futureRPMslope = getRPMslope();
      //   _futureMap1 = _getMaps("Map1");
      //   _futureMap2 = _getMaps("map2");
      //   _futureAcc0 = _getMaps("acc0");
      //   _futureAcc1 = _getMaps("acc1");
      //   _futureAcc2 = _getMaps("acc2");
      //   _futureidleRPM = _getIdleRPM();

  
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

        // _futureO2Val =  getO2Val();
        // _futureO2BP = getO2BP();
        // _futureRPMslope_ON = getRPMslope_ON();
        // _futureRPMslope = getRPMslope();
        // _futureMap1 = _getMaps("Map1");
        // _futureMap2 = _getMaps("map2");
        // _futureAcc0 = _getMaps("acc0");
        // _futureAcc1 = _getMaps("acc1");
        // _futureAcc2 = _getMaps("acc2");
        // _futureidleRPM = _getIdleRPM();

  }

  @override
  void dispose() {
    bluetoothData = null;
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      // _sendMessage("SS:0");
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //scaffoldContext = context;

   
    final List<String> list = messages.map((_message) {
      if(_message.text != '"' ){

     
       // _timer = new Timer(const Duration(milliseconds: 900), () {
        //setState(() {
 
                      _getData(_message.text);
                      //});
         //             });
                     //  print(_message.text);
                     print(_message.text);

                 
      }
    }).toList();
    //list.clear();
    messages.clear();
    // final List<Row> list = messages.map((_message) {
    //   return Row(
    //     children: <Widget>[
    //       Container(
    //         child: Text(
    //             (text) {
    //               _getData(text);
    //               print(text);
    //               return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
    //             }(_message.text.trim()),
    //             style: TextStyle(color: Colors.white)),
    //         padding: EdgeInsets.all(12.0),
    //         margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
    //         width: 222.0,
    //         decoration: BoxDecoration(
    //             color:
    //                 _message.whom == clientID ? Colors.blueAccent : Colors.grey,
    //             borderRadius: BorderRadius.circular(7.0)),
    //       ),
    //     ],
    //     mainAxisAlignment: _message.whom == clientID
    //         ? MainAxisAlignment.end
    //         : MainAxisAlignment.start,
    //   );
    // }).toList();

    return Scaffold(
        key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: new Color(0xff622F74),
          title: (isConnecting
              ? Text('Connecting to ' +  widget.server.name + '...')
              : isConnected
                  ? Text('Live data with ' +  widget.server.name)
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
              crossAxisCount: 12,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              controller: _scrollController,
              //physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
              children: <Widget>[
                  
              myItems(Icons.graphic_eq,"Map:0",setmap==0? Colors.green[300]:Colors.grey[300],"SetMap:0",true),
              myItems(Icons.graphic_eq,"Map:1",setmap==1? Colors.green[300]:Colors.grey[300],"SetMap:1",true),
              myItems(Icons.graphic_eq,"Map:2",setmap==2? Colors.green[300]:Colors.grey[300],"SetMap:2",true),
              myItems(Icons.notifications,"Monitor",ssvalue==1? Colors.grey[300]:Colors.blue[300],"SS:" + ssvalue.toString(),true),
              // Stack(
              // children: <Widget>[
              //   Center(child: Text(txtvoltagevalue.toString(),textAlign: TextAlign.center,
              // style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold)
              // )),
              Container(
                  margin: const EdgeInsets.all(0.0),
           
                  child: SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(minimum: 0, maximum: 12000,
                  ranges: <GaugeRange>[
                  GaugeRange(startValue: 0, endValue: 4000, color:Colors.green),
                  GaugeRange(startValue: 4000,endValue: 8000,color: Colors.orange),
                  GaugeRange(startValue: 8000,endValue: 12000,color: Colors.red)],
               //  pointers: <GaugePointer>[
                 //NeedlePointer(value: txtvoltagevalue,needleColor: Colors.blue[300])],
                 
                 pointers: <GaugePointer>
                 [NeedlePointer(value: double.parse(txtvoltagevalue.toString()), 
                  needleStartWidth: 1, needleEndWidth: 5,
                    knobStyle: KnobStyle(knobRadius: 0.05, borderColor: Colors.blue,
                     borderWidth: 0.01, 
                     color: Colors.white
                 ))],
                 
                  annotations: <GaugeAnnotation>[
                  GaugeAnnotation(widget: Container(child: 
                    Text(dblVoltage.toStringAsFixed(2) + " V" +  "\n" + " " +txtvoltagevalue.toString() ,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                    angle: 90, positionFactor: 0.5
                  )]
                )],)
              ),
              
             // ]),
               rpmRunner(txtvoltagevalue.toString() + " RPM"),
             // myItems(Icons.content_copy,toTop?"Advanced Settings":"Basic Settings",Colors.purple[300],"ConfigPage",false),
                            //page 2
              
              _mapsLayout(Icons.create,"MAP 1",Colors.orange[300],"Map1",false),//_futureMap1,_futureidleRPM),
              _mapsLayout1(Icons.create,"MAP 2",Colors.orange[300],"Map2",false),//_futureMap2,_futureidleRPM),
              //Expanded(child: Container()),
              _mapsLayout2(Icons.create,"ACC 0",Colors.orange[300],"Acc0",false),//_futureAcc0,_futureidleRPM),
              _mapsLayout3(Icons.create,"ACC 1",Colors.orange[300],"Acc1",false),//_futureAcc1,_futureidleRPM),
              _mapsLayout4(Icons.create,"ACC 2",Colors.orange[300],"Acc2",false),//_futureAcc2,_futureidleRPM),
              myItemsString("02 Sensor Bypass",bluetoothData.O2BP == 0?Colors.purple[300]:Colors.green[500],"O2BP:",true),
              myItemsCustom("O2 Sensor Value",Colors.purple[300],"O2SV",false),

              myItemsRPMslope_ON("ACC. Map ON",bluetoothData.RPMslope_ON == 0?Colors.red[300]:Colors.green[500],"RPMslopeON:" ,true),
              myItemsRPMslope("ACC. Sensitivity",Colors.red[300],"RPMslope",false),
              
              ],
              staggeredTiles: [
                StaggeredTile.extent(4,130.0),//setmap
                StaggeredTile.extent(4,130.0),//setmap
                StaggeredTile.extent(4,130.0),//setmap
                StaggeredTile.extent(12, 130.0),//monitor
                StaggeredTile.extent(12, 250.0),//gauge
                StaggeredTile.extent(12, 70.0),//rpm
                //StaggeredTile.extent(3, 130.0), // advanced settings
                                //page 2
                StaggeredTile.extent(6,150.0), //map1
                StaggeredTile.extent(6,150.0), //map2
                StaggeredTile.extent(4,150.0), //acc0
                StaggeredTile.extent(4,150.0), //acc1
                StaggeredTile.extent(4,150.0), //acc2
                StaggeredTile.extent(6,150.0),  //o2 bp
                StaggeredTile.extent(6,150.0), //o2sv
                StaggeredTile.extent(6,150.0),  //rpmslope_on
                StaggeredTile.extent(6,150.0), //rpmslope
              ],
            ),
      
       ),
    );
  }

// Future<void> getData() async {
   
 
//        _futureO2Val =  await getO2Val();
//         _futureO2BP = await getO2BP();
//         _futureRPMslope_ON = await getRPMslope_ON();
//         _futureRPMslope = await getRPMslope();
//         _futureMap1 = await _getMaps("map1");
//         _futureMap2 = await _getMaps("map2");
//         _futureAcc0 = await _getMaps("acc0");
//         _futureAcc1 = await _getMaps("acc1");
//         _futureAcc2 = await _getMaps("acc2");
//         _futureidleRPM = await _getIdleRPM();

   
//      // setState(() =>  _futureMap1);
//   }

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
    // _getData(dataString);
     //createSnackBar(dataString);
    // print(dataString);
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
    //_getData(messages[messages.length-1].text.toString());
    
  }
 

void _getData  (String data) async {
 //check multiple :
 if(':'.allMatches(data).length == 1){
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
        txtvoltagevalue = int.parse(voltagevalue[1]);
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
  


  if(data.contains("MAP1:"))
  {
    bluetoothData.MAP1 = new List<int>();
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK" ){
      
       var mapsplit = splitvalue[1].split(","); 

        for (int i = 0; i < mapsplit.length-1; i++) {
         bluetoothData.MAP1.add(int.parse(mapsplit[i]));
         
        }
         _futureMap1 = _getMaps("Map1");
    }
  }
  
if(data.contains("MAP2:") )
  {
    bluetoothData.MAP2 = new List<int>();
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK" ){
      
       var mapsplit = splitvalue[1].split(","); 

       for (int i = 0; i < mapsplit.length-1; i++) {
         bluetoothData.MAP2.add(int.parse(mapsplit[i]));
         
        }
        _futureMap2 = _getMaps("Map2");
    }
  }

  if(data.contains("IdelRPM:"))
  {
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK" ){// && splitvalue[1].length > 3){
      bluetoothData.IdelRPM = int.parse(splitvalue[1]);
       _futureidleRPM = _getIdleRPM();
    }
  }
 
 if(data.contains("O2BP:"))
 {
   var splitvalue = data.split(":");
    if(splitvalue[1] != "OK"  ){
      bluetoothData.O2BP = int.parse(splitvalue[1]);
      selectedO2BPstr = bluetoothData.O2BP;
      _futureO2BP = getO2BP();

   
    }
 }
 
 if(data.contains("ACC0:"))
  {
    bluetoothData.ACC0 = new List<int>();
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK" ){
      
       var mapsplit = splitvalue[1].split(","); 

       for (int i = 0; i < mapsplit.length-1; i++) {
         bluetoothData.ACC0.add(int.parse(mapsplit[i]));
         
        }
        _futureAcc0 = _getMaps("Acc0");
    }
  }

if(data.contains("ACC1:"))
  {
    bluetoothData.ACC1 = new List<int>();
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK" ){
      
       var mapsplit = splitvalue[1].split(","); 

       for (int i = 0; i < mapsplit.length-1; i++) {
         bluetoothData.ACC1.add(int.parse(mapsplit[i]));
         
        }
        _futureAcc1 = _getMaps("Acc1");
    }
  }
  
  if(data.contains("ACC2:"))
  {
    bluetoothData.ACC2 = new List<int>();
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK" ){
      
       var mapsplit = splitvalue[1].split(","); 

       for (int i = 0; i < mapsplit.length-1; i++) {
         bluetoothData.ACC2.add(int.parse(mapsplit[i]));
         
        }
        _futureAcc2 = _getMaps("Acc2");
    }
  }
  if(data.contains("O2VAL:"))
  {
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK"  ){
      bluetoothData.O2VAL = double.parse(splitvalue[1])/10;
      selectedDropDownValue = bluetoothData.O2VAL;
       _futureO2Val = getO2Val();
    }
  }
   
  if(data.contains("RPMslope:"))
  {
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK"  ){
      
      bluetoothData.RPMslope = int.parse(splitvalue[1]);
      selectedDropDownRPMslopeValue = bluetoothData.RPMslope;
      _futureRPMslope = getRPMslope();
    }
  }
  
  if(data.contains("RPMslopeON:"))
  {
    var splitvalue = data.split(":");
    if(splitvalue[1] != "OK"  ){
      bluetoothData.RPMslope_ON = int.parse(splitvalue[1]);
      selectedDropDownRPMslopeONValue = bluetoothData.RPMslope_ON;
      _futureRPMslope_ON = getRPMslope_ON();
     
    }
  }
// setState(() {
//   });
}
if(data.contains("Ver"))
{
     if(_futureAcc0 == null || _futureAcc1 == null || _futureAcc2 == null || _futureMap1 == null || _futureMap2 == null || _futureO2BP == null
        || _futureO2Val == null || _futureRPMslope == null || _futureidleRPM == null || _futureRPMslope_ON == null)
        {
          //_timer = new Timer(const Duration(milliseconds: 300), () {
          _sendMessage("param");
           //});
        }
}
  

}
Future<dynamic> getO2Val() async {
  
  return bluetoothData.O2VAL;
}

Future<dynamic> getO2BP() async {
   return bluetoothData.O2BP;
}
Future<dynamic> getRPMslope_ON() async{
  return bluetoothData.RPMslope_ON;
}
Future<dynamic>  getRPMslope() async
{
  return bluetoothData.RPMslope;
}

Future<dynamic>  _getMaps(String btvalue) async
{
  //return this._memoizer.runOnce(() async {
    switch(btvalue) { 
    case "Map1": { 
      
      return bluetoothData.MAP1;
    } 
    break;
    case "Map2": { 
        return bluetoothData.MAP2;
    } 
    break; 
      case "Acc0": { 
        return bluetoothData.ACC0;
    } 
    break; 
      case "Acc1": { 
        return bluetoothData.ACC1;
    } 
    break; 
      case "Acc2": { 
        return bluetoothData.ACC2;
    } 
    break; 
    default: { 
        return null;
    }
    break; 
    } 
 // });
}

Future<dynamic>  _getIdleRPM() async
{
  return bluetoothData.IdelRPM;
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
        case "O2BP" : {
          if(bluetoothData.O2BP == 1){
            bluetoothData.O2BP = 0;
          }
          else
          {
            bluetoothData.O2BP = 1;
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
      var mapsplit = "100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100"; //splitvalue[1].split(","); 
      var counter = mapsplit.split(",");
        for (int i = 0; i <= counter.length-1; i++) {
          bluetoothData.MAP1.add(int.parse(counter[i]));
          
        }
      }
    mapEdit = 1;
    _mapEdit("map1");
  
    }
    catch(e){
      print(e);
    }
  }
  if(text == "Map2")
  {
    try{
      if(bluetoothData.MAP2 ==null){ 
      bluetoothData.MAP2 =new List<int>();
      var mapsplit = "100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100"; //splitvalue[1].split(","); 
      var counter = mapsplit.split(",");
        for (int i = 0; i <= counter.length-1; i++) {
          bluetoothData.MAP2.add(int.parse(counter[i]));
          
        }
      }
    mapEdit = 2;
    //showToast();
    //showDialog();
    _mapEdit("map2");
  //  showDialog(context: context,builder: (context) => _onTapTable(context));
  
    }
    catch(e){
      print(e);
    }
  }

if(text == "Acc0")
  {
    try{
      if(bluetoothData.ACC0 ==null){ 
      bluetoothData.ACC0 =new List<int>();
      var mapsplit = "100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100"; //splitvalue[1].split(","); 
      var counter = mapsplit.split(",");
        for (int i = 0; i <= counter.length-1; i++) {
          bluetoothData.ACC0.add(int.parse(counter[i]));
          
        }
      }
    mapEdit = 2;
    //showToast();
    //showDialog();
    _mapEdit("acc0");
  //  showDialog(context: context,builder: (context) => _onTapTable(context));
  
    }
    catch(e){
      print(e);
    }
  }

if(text == "Acc1")
  {
    try{
      if(bluetoothData.ACC1 ==null){ 
      bluetoothData.ACC1 =new List<int>();
      var mapsplit = "100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100"; //splitvalue[1].split(","); 
      var counter = mapsplit.split(",");
        for (int i = 0; i <= counter.length-1; i++) {
          bluetoothData.ACC1.add(int.parse(counter[i]));
          
        }
      }
    mapEdit = 2;
    //showToast();
    //showDialog();
    _mapEdit("acc1");
  //  showDialog(context: context,builder: (context) => _onTapTable(context));
  
    }
    catch(e){
      print(e);
    }
  }
if(text == "Acc2")
  {
    try{
      if(bluetoothData.ACC2 ==null){ 
      bluetoothData.ACC2 =new List<int>();
      var mapsplit = "100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100"; //splitvalue[1].split(","); 
      var counter = mapsplit.split(",");
        for (int i = 0; i <= counter.length-1; i++) {
          bluetoothData.ACC2.add(int.parse(counter[i]));
          
        }
      }
    mapEdit = 2;
    //showToast();
    //showDialog();
    _mapEdit("acc2");
  //  showDialog(context: context,builder: (context) => _onTapTable(context));
  
    }
    catch(e){
      print(e);
    }
  }

}

  void _sendMessage(String text) async {
    print('MESSAGE SENT:  ' + text);
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

          //_showAlert(context);
          // Future.delayed(Duration(milliseconds: 333)).then((_) {
          //   listScrollController.animateTo(
          //       listScrollController.position.maxScrollExtent,
          //       duration: Duration(milliseconds: 333),
          //       curve: Curves.easeOut);
               
          // });
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
             new GestureDetector(
                  onTap: 
                   // Navigator.pushNamed(context, "myRoute");
                  
                     isConnected
                          ? () => _sendMessageType(msg,msgType)
                          : null,
            child: Column(  
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
                Material(  
                  color: color,
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(  
                      icon,
                      color: Colors.white,
                      size: 30.0,
                      
                    ),
                  // )
                  )
                ),
              ],
            ),
            )
          ],
        ),
      ),
    ),
  );
}

  Material rpmRunner(String msg){
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
            
                //text
                Padding(
                  
                  padding: const EdgeInsets.all(8.0),

                    child: Text(msg, 
                    style: TextStyle(  
                      color:  Colors.black,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold
                    ),
                    
                    ),
                    
                ),

              ],
            ),
            )
         
  ));
}

Material _mapsLayout(IconData icon, String heading, Color color,String msg,bool msgType){//,Future<dynamic> maptypes,Future<dynamic> idleRPMf){
  
  return  Material(
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
        
       FutureBuilder<dynamic>(
        future: Future.wait([_futureMap1,_futureidleRPM]),//Future.wait([_futureMap1,_futureidleRPM]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          
        if(!snapshot.hasData) {
         // show loading while waiting for real data
        return CircularProgressIndicator();
       }

             return 
             GestureDetector(
                  onTap: 
                   // Navigator.pushNamed(context, "myRoute");
                  
                     isConnected
                          ? () => _sendMessageType(msg,msgType)
                          : null,
            child: Column(  
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
                Material(  
                  color: color,
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(  
                      icon,
                      color: Colors.white,
                      size: 30.0,
                      
                    ),
                  
                  )
                ),
              ],
            ),
            );
        
           })
           
          ],
        ),
      ),
    ),
  );
}

FutureBuilder buildmaps(BuildContext context,IconData icon, String heading, Color color,String msg,bool msgType) {
    return FutureBuilder<dynamic>(
        future: Future.wait([_futureMap1,_futureidleRPM]),//Future.wait([_futureMap1,_futureidleRPM]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          
        if(!snapshot.hasData) {
         // show loading while waiting for real data
        return CircularProgressIndicator();
     }

             return 
             GestureDetector(
                  onTap: 
                   // Navigator.pushNamed(context, "myRoute");
                  
                     isConnected
                          ? () => _sendMessageType(msg,msgType)
                          : null,
            child: Column(  
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
                Material(  
                  color: color,
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(  
                      icon,
                      color: Colors.white,
                      size: 30.0,
                      
                    ),
                  
                  )
                ),
              ],
            ),
            );
             
           });
  }

/////maps layout
 Material _mapsLayout1(IconData icon, String heading, Color color,String msg,bool msgType){//,Future<dynamic> maptypes,Future<dynamic> idleRPMf){
  return  Material(
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
         FutureBuilder<dynamic>(
        future: Future.wait([_futureMap2,_futureidleRPM]),//Future.wait([_futureMap1,_futureidleRPM]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          
        if(!snapshot.hasData) {
         // show loading while waiting for real data
        return CircularProgressIndicator();
       }

             return 
             GestureDetector(
                  onTap: 
                   // Navigator.pushNamed(context, "myRoute");
                  
                     isConnected
                          ? () => _sendMessageType(msg,msgType)
                          : null,
            child: Column(  
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
                Material(  
                  color: color,
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(  
                      icon,
                      color: Colors.white,
                      size: 30.0,
                      
                    ),
                  
                  )
                ),
              ],
            ),
            );
        
           })
          ],
        ),
      ),
    ),
  );
}

Material _mapsLayout2(IconData icon, String heading, Color color,String msg,bool msgType){//,Future<dynamic> maptypes,Future<dynamic> idleRPMf){
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
           FutureBuilder<dynamic>(
        future: Future.wait([_futureAcc0,_futureidleRPM]),//Future.wait([_futureMap1,_futureidleRPM]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          
        if(!snapshot.hasData) {
         // show loading while waiting for real data
        return CircularProgressIndicator();
       }

             return 
             GestureDetector(
                  onTap: 
                   // Navigator.pushNamed(context, "myRoute");
                  
                     isConnected
                          ? () => _sendMessageType(msg,msgType)
                          : null,
            child: Column(  
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
                Material(  
                  color: color,
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(  
                      icon,
                      color: Colors.white,
                      size: 30.0,
                      
                    ),
                  
                  )
                ),
              ],
            ),
            );
        
           })
          ],
        ),
      ),
    ),
  );
}
Material _mapsLayout3(IconData icon, String heading, Color color,String msg,bool msgType){//,Future<dynamic> maptypes,Future<dynamic> idleRPMf){
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
             FutureBuilder<dynamic>(
        future: Future.wait([_futureAcc1,_futureidleRPM]),//Future.wait([_futureMap1,_futureidleRPM]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          
        if(!snapshot.hasData) {
         // show loading while waiting for real data
        return CircularProgressIndicator();
       }

             return 
             GestureDetector(
                  onTap: 
                   // Navigator.pushNamed(context, "myRoute");
                  
                     isConnected
                          ? () => _sendMessageType(msg,msgType)
                          : null,
            child: Column(  
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
                Material(  
                  color: color,
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(  
                      icon,
                      color: Colors.white,
                      size: 30.0,
                      
                    ),
                  
                  )
                ),
              ],
            ),
            );
        
           })
          ],
        ),
      ),
    ),
  );
}

Material _mapsLayout4(IconData icon, String heading, Color color,String msg,bool msgType){//,Future<dynamic> maptypes,Future<dynamic> idleRPMf){
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
             FutureBuilder<dynamic>(
        future: Future.wait([_futureAcc2,_futureidleRPM]),//Future.wait([_futureMap1,_futureidleRPM]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          
        if(!snapshot.hasData) {
         // show loading while waiting for real data
        return CircularProgressIndicator();
       }

             return 
             GestureDetector(
                  onTap: 
                   // Navigator.pushNamed(context, "myRoute");
                  
                     isConnected
                          ? () => _sendMessageType(msg,msgType)
                          : null,
            child: Column(  
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
                Material(  
                  color: color,
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(  
                      icon,
                      color: Colors.white,
                      size: 30.0,
                      
                    ),
                  
                  )
                ),
              ],
            ),
            );
        
           })
          ],
        ),
      ),
    ),
  );
}
///
Future<Null> _mapEdit(String strmaptype) async {
  String txtTitle;
  List<int> list = [for(var i=2500; i<=12000; i+=500) i];
  list.insert(0, bluetoothData.IdelRPM);// == null?1800:bluetoothData.IdelRPM); //add idlerpm value here
  List<int> finallist = [];
  //finallist.add(bluetoothData.MAP1[0]); 
 String strmaptypenum;
 if(strmaptype == "map1"){
    for (var i = 0; i < bluetoothData.MAP1.length; i++) {
      finallist.add(bluetoothData.MAP1[i]);
    }
    strmaptypenum = "map1";
    txtTitle = "Map : 1";
 }
 if(strmaptype == "map2"){
    for (var i = 0; i < bluetoothData.MAP2.length; i++) {
      finallist.add(bluetoothData.MAP2[i]);
    }
    strmaptypenum = "map2";
    txtTitle = "Map 2";
 }

 if(strmaptype == "acc0"){
    for (var i = 0; i < bluetoothData.ACC0.length; i++) {
      finallist.add(bluetoothData.ACC0[i]);
    }
    strmaptypenum = "acc0";
    txtTitle = "ACC 0";
 }
if(strmaptype == "acc1"){
    for (var i = 0; i < bluetoothData.ACC1.length; i++) {
      finallist.add(bluetoothData.ACC1[i]);
    }
    strmaptypenum = "acc1";
    txtTitle = "ACC 1";
 }

if(strmaptype == "acc2"){
    for (var i = 0; i < bluetoothData.ACC2.length; i++) {
      finallist.add(bluetoothData.ACC2[i]);
    }
    strmaptypenum = "acc2";
    txtTitle = "ACC 2";
 }

  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    child: new AlertDialog(
      contentPadding: const EdgeInsets.all(10.0),
      title: new Text(
       txtTitle,
        style:
        new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      content: 
      
      new Container(
        // Specify some width
        width: MediaQuery.of(context).size.width * .2,
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
                 style: TextStyle(backgroundColor: Colors.green[500],fontWeight: FontWeight.bold),
                  
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
                                          _decodeparams(finallist,strmaptypenum);
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

void _decodeparams(List<int> paramarrays,String strmaptype){
  String idelRPMstr = (paramarrays[0] / 10).round().toString();
  bluetoothData.IdelRPM = paramarrays[0];
  
  String idleRPMstr = "IdelRPM:" + idelRPMstr;
  _sendMessage(idleRPMstr);
  //print(idleRPMstr);
  String map1array;
  if(strmaptype == "map1"){
    bluetoothData.MAP1 =  [];
    for (var i = 1; i < paramarrays.length; i++) {
      bluetoothData.MAP1.add(paramarrays[i]);
    }
    map1array = "MAP1:";
    for(var i = 0; i < bluetoothData.MAP1.length;i++){
        map1array = map1array + bluetoothData.MAP1[i].toString() + ",";
    }
  }

  if(strmaptype == "map2"){
    bluetoothData.MAP2 =  [];
    for (var i = 1; i < paramarrays.length; i++) {
      bluetoothData.MAP2.add(paramarrays[i]);
    }
    map1array = "MAP2:";
    for(var i = 0; i < bluetoothData.MAP2.length;i++){
        map1array = map1array + bluetoothData.MAP2[i].toString() + ",";
    }
  }

 if(strmaptype == "acc0"){
    bluetoothData.ACC0 =  [];
    for (var i = 1; i < paramarrays.length; i++) {
      bluetoothData.ACC0.add(paramarrays[i]);
    }
    map1array = "ACC0:";
    for(var i = 0; i < bluetoothData.ACC0.length;i++){
        map1array = map1array + bluetoothData.ACC0[i].toString() + ",";
    }
  }

if(strmaptype == "acc1"){
    bluetoothData.ACC1 =  [];
    for (var i = 1; i < paramarrays.length; i++) {
      bluetoothData.ACC1.add(paramarrays[i]);
    }
    map1array = "ACC1:";
    for(var i = 0; i < bluetoothData.ACC1.length;i++){
        map1array = map1array + bluetoothData.ACC1[i].toString() + ",";
    }
  }
if(strmaptype == "acc2"){
    bluetoothData.ACC2 =  [];
    for (var i = 1; i < paramarrays.length; i++) {
      bluetoothData.ACC2.add(paramarrays[i]);
    }
    map1array = "ACC2:";
    for(var i = 0; i < bluetoothData.ACC2.length;i++){
        map1array = map1array + bluetoothData.ACC2[i].toString() + ",";
    }
  }

  _sendMessage(map1array);
  //print(map1array);
}
 void _toEnd() {                                                     
    _scrollController.animateTo(                                      
      toTop?_scrollController.position.minScrollExtent:_scrollController.position.maxScrollExtent,                     
      duration: const Duration(milliseconds: 300),                    // NEW
      curve: Curves.ease,                                             // NEW
    );                                                                // NEW
  }    


Material myItemsCustom(String heading, Color color,String msg,bool msgType){
  List<String> dbvalues = [];
  for(double i = 0.1 ; i <= 3.1; i = i + 0.1){
    dbvalues.add(i.toStringAsFixed(1));
  }

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
         
             FutureBuilder<dynamic>(
        future: _futureO2Val,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          
        if(!snapshot.hasData) {
         // show loading while waiting for real data
        return CircularProgressIndicator();
       }

             return 
             Column(  
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                //text
                Padding(
                  
                  padding: const EdgeInsets.all(8.0),

                    child: Text(heading, 
                    style: TextStyle(  
                      color:  color,
                      fontSize: 15.0,
                    ),
                    
                    ),
                    
                ),
                Material(  
                  color: color,
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<double>(
                      value: bluetoothData.O2VAL,// != null? bluetoothData.O2VAL : selectedDropDownValue,
                      //hint: Text("0.5"),
                      items:  dbvalues.map((String value) {
                        return new DropdownMenuItem<double>(
                          value: double.parse(value),
                          child: Text(value.toString(),
                           style: TextStyle(  
                      color:  Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                          ),
                        ),
                        );
                      }).toList(),
                      onChanged: (double value) {
                        setState(() {
                          selectedDropDownValue = value;      // Problem here too, the element doesn’t show in the dropdown as selected
                          int val = (selectedDropDownValue * 10).toInt();
                          _sendMessage("O2VAL:" + val.toString());
                        });
                      },
                    ),
                  )
                ),
              ],
            );
           })
            
          ],
        ),
      ),
    ),
  );
}


Material myItemsRPMslope_ON(String heading, Color color,String msg,bool msgType){
  //selectedDropDownRPMslopeONValue = bluetoothData.RPMslope_ON;
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
                FutureBuilder<dynamic>(
        future: _futureRPMslope_ON,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          
        if(!snapshot.hasData) {
         // show loading while waiting for real data
        return CircularProgressIndicator();
       }

             return 

          Column(  
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                //text
                Padding(
                  
                  padding: const EdgeInsets.all(8.0),

                    child: Text(heading, 
                    style: TextStyle(  
                      color:  color,
                      fontSize: 15.0,
                    ),
                    
                    ),
                    
                ),
                Material(  
                  color: color,
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<int>(
                      value: bluetoothData.RPMslope_ON,                      //hint: Text("0.5"),
                      items: <int>[0,1].map((int value) {
                        return new DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString(),
                           style: TextStyle(  
                      color:  Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                          ),
                        ),
                        );
                      }).toList(),
                      onChanged: (int value) {
                        setState(() {
                          selectedDropDownRPMslopeONValue = value;      // Problem here too, the element doesn’t show in the dropdown as selected
                          
                          _sendMessage("RPMslopeON:" + value.toString());
                        });
                      },
                    ),
                  )
                ),
              ],
            );
           })
         
          ],
        ),
      ),
    ),
  );
}

Material myItemsString(String heading, Color color,String msg,bool msgType){
  selectedO2BPstr = bluetoothData.O2BP;
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
             FutureBuilder<dynamic>(
        future: _futureO2BP,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          
        if(!snapshot.hasData) {
         // show loading while waiting for real data
        return CircularProgressIndicator();
       }

             return 
        Column(  
              mainAxisAlignment: MainAxisAlignment.center,



              children: <Widget>[
                
                //text
                Padding(
                  
                  padding: const EdgeInsets.all(8.0),

                    child: Text(heading, 
                    style: TextStyle(  
                      color:  color,
                      fontSize: 15.0,
                    ),
                    
                    ),
                    
                ),
                Material(  
                  color: color,
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<int>(
                      value: bluetoothData.O2BP,//bluetoothData.O2BP != null? bluetoothData.O2BP : selectedO2BPstr,
                      //hint: Text("0.5"),
                      items: <int>[0,1].map((int value) {
                        return new DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString(),
                           style: TextStyle(  
                      color:  Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                          ),
                        
                          ),
                        );
                      }).toList(),
                      onChanged: (int value) {
                        setState(() {
                          selectedO2BPstr = value;      // Problem here too, the element doesn’t show in the dropdown as selected
                          
                          _sendMessage("O2BP:" + value.toString());
                        });
                      },
                    ),
                  )
                ),
              ],
            );
         
         })
         ],
        ),
      ),
    ),
  );
}

Material myItemsRPMslope(String heading, Color color,String msg,bool msgType){
  List<String> dbvalues = [];
  for(int i = 10 ; i <= 250; i = i + 5){
    dbvalues.add(i.toString());
  }

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
      FutureBuilder<dynamic>(
        future: _futureRPMslope,//Future.wait([_futureMap1,_futureidleRPM]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          
        if(!snapshot.hasData) {
         // show loading while waiting for real data
        return CircularProgressIndicator();
       }

             return 
         Column(  
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding( 
                  padding: const EdgeInsets.all(8.0),
                    child: Text(heading, 
                    style: TextStyle(  
                      color:  color,
                      fontSize: 15.0,
                    ),             
                    ),
                    
                ),
                Material(  
                  color: color,
                  borderRadius:  BorderRadius.circular(24.0),
                  child: Padding(  
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<int>(
                      value: bluetoothData.RPMslope,// != null? bluetoothData.RPMslope : selectedDropDownRPMslopeValue,
                      //hint: Text("0.5"),
                      items:  dbvalues.map(( value) {
                        return new DropdownMenuItem<int>(
                          value: int.parse(value),
                          child: Text(value.toString(),
                           style: TextStyle(  
                      color:  Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                          ),
                        ));
                      }).toList(),
                      onChanged: (int value) {
                        setState(() {
                          selectedDropDownRPMslopeValue = value;      // Problem here too, the element doesn’t show in the dropdown as selected
                         
                          _sendMessage("RPMslope:" + selectedDropDownRPMslopeValue.toString());
                        });
                      },
                    ),
                  )
                ),
              ],
            );
           },    )
          ],
        ),
      ),
    ),
  );
}

void _showAlert(BuildContext context) {
      showDialog(
          context: context,
        
          builder: (context)  {
          Future.delayed(Duration(milliseconds: 600), () {
                          Navigator.of(context).pop(true);
                        });
            return AlertDialog(
  
              contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
            //title: Text("Syncing data..."),
            content: 
             Container(
        
                height: 40.0,
                width: 30.0,
                child: CircularProgressIndicator(),
               
             )
            
          );
          });
    }

         
}


