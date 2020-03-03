
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:car_locator_2/appstate/app_state.dart';


class Category {
  String name;
  IconData icon;
  Category(this.name, this.icon);
}

class MapCategory {
  String name;
  MapType mapType;
  MapCategory(this.name,this.mapType);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
  
}

String _currentlySelected = "walking"; //var to hold currently selected value
String _selectmaptype = "normal";


MapType returnMapType(String name){
   switch(name) { 
        case "normal": { 
            return MapType.normal;
        } 
        break; 
          case "hybrid": {
              return MapType.hybrid;
          }
        break;
          case "satellite":{
            return MapType.satellite;
          }
        break;
          case "terrain":{
            return MapType.terrain;
          }
        default: { 
                return MapType.normal;  
        }
        break; 

        }

}

class _MyHomePageState extends State<MyHomePage> {
String shortcut = "no action set";

@override
  void initState() {
    super.initState();
    
  }

final List<String> _listMapType = [
    "normal",
    "hybrid",
    "satellite",
    "terrain",
];



final List<String> _dropdownValues = [
    "driving",
    "walking",
    "bicycling",
    "transit",
  ]; //The list of values we want on the dropdown
  
 List<Category> _categories = [
    Category('driving', Icons.directions_car),
    Category('walking', Icons.directions_run),
    Category('bicycling', Icons.directions_bike),
    Category('transit', Icons.directions_bus),
    
];

IconData getIcon(String name){
  return _categories[_categories.indexWhere((cat) => cat.name.contains(name))].icon;
}

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('One Click App'),
            //
           
            //
             
            //Add the dropdown widget to the `Action` part of our appBar. it can also be among the `leading` part
            actions: <Widget>[ 
              DropdownButton(
              //map each value from the lIst to our dropdownMenuItem widget
              items: _listMapType
                  .map((value) => DropdownMenuItem(
                        child:Text(value),//mapt: value,//Text(value),
                        value: value,
                      ))
                  .toList(),
              onChanged: (String value) {
                
                //once dropdown changes, update the state of out currentValue
                setState(() {
                  _selectmaptype = value;
                });
                 
                
              },
              //this wont make dropdown expanded and fill the horizontal space
              isExpanded: false,
              //make default value of dropdown the first value of our list
              value:  _selectmaptype,//_dropdownValues.first,
            ),
              
              
              
              DropdownButton(
              //map each value from the lIst to our dropdownMenuItem widget
              items: _dropdownValues
                  .map((value) => DropdownMenuItem(
                        child: Icon(getIcon(value)),//Text(value),
                        value: value,
                      ))
                  .toList(),
              onChanged: (String value) {
                appState.recreateRoute(value);
                //once dropdown changes, update the state of out currentValue
                setState(() {
                  _currentlySelected = value;
                });
                
              },
              //this wont make dropdown expanded and fill the horizontal space
              isExpanded: false,
              //make default value of dropdown the first value of our list
              value:  _currentlySelected,//_dropdownValues.first,
            ),
          ],
        ),
      //map
        body: Map(),
      
      //drawer
  drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
    ),

      );
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    
    final appState = Provider.of<AppState>(context);
    
    return SafeArea(
      child: appState.initialPosition == null
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              SpinKitChasingDots(
              color: Colors.blueAccent,
                size: 50.0,
              )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Visibility(
                    visible: appState.locationServiceActive == false,
                    child: Text("Please enable location services", style: TextStyle(color: Colors.grey, fontSize: 18),),
                  )
                ],
              )
            )
          : Stack(
              children:  <Widget>[
                  //_createMap(appState),
                  GoogleMap(
                      initialCameraPosition: CameraPosition(
                      target: appState.initialPosition, zoom: 18.0),
                      onMapCreated: appState.onCreatedAndroid,
                      myLocationEnabled: true,
                      mapType: returnMapType(_selectmaptype),
                      compassEnabled: true,
                      
                      markers: appState.markers,
                      onCameraMove: appState.onCameraMove,
                      polylines: appState.polyLines,
                      
                    ),
              
              ],
              
            ),
    );
   
  }

}
