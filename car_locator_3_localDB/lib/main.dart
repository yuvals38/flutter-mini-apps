import 'package:flutter/material.dart';
import 'package:car_locator_2/quick_actions_manager.dart';
import 'package:provider/provider.dart';
import 'package:car_locator_2/appstate/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:uuid/uuid.dart';

//var uuid = Uuid();
//uuid.v1(); // -> '6c84fb90-12c4-11e1-840d-7b25c5ee775a'


void main() {
  
 
  
  runApp(StarterMyApp());
}

class StarterMyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'QuickActions Demo', home: QuickActionsManager(child: 
        MultiProvider(providers: [

                ChangeNotifierProvider.value(value: AppState(false),)
            ],

            child: MainPage(),)));
  }
  
}

class MainPage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return new MyApp();
  }
}

const String spKey = 'uID';

class MyApp extends State<MainPage>{
 SharedPreferences sharedPreferences;
 String _testValue;
 var uuid = Uuid();

 @override
  void initState() {
    super.initState();
   
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      _testValue = sharedPreferences.getString(spKey);
      // will be null if never previously saved
      if (_testValue == null) {
        _testValue = uuid.v1();
        persist(_testValue); // set an initial value
      }
      setState(() {});
    });
  }

  void persist(String value) {
    setState(() {
      _testValue = value;
    });
    sharedPreferences?.setString(spKey, value);
    

  }

  IconData iconlocal;
 
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
   
    appState.userID = _testValue;
    setState(() {
      iconlocal = appState.icon1;
    });
 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'car locator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
      
       body: 
       
    
        MyHomePage(),
        

      bottomNavigationBar: new CurvedNavigationBar(
          color: Colors.lightBlue,
          backgroundColor: Colors.white,
          buttonBackgroundColor: Colors.lightBlue,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          index: appState.markers.length == 0 ? 1:0,
          items: <Widget>[
            Icon(iconlocal , size: 50,color: Colors.purpleAccent), 
            Icon(Icons.delete_forever, size: 30,color: Colors.redAccent,),
            Icon(Icons.mobile_screen_share, size: 30,color: Colors.greenAccent,),
          ],
          onTap: (index) {
            switch(index) { 
              case 0: { 
                appState.newtext = '';
                  appState.icon1 = Icons.check_circle;
                  if(appState.markers.length == 0){
                    //appState.addGeoPoint();
                    appState.globalVisibility = 1;
                    //appState.UpdateLocalDataMarkers();
                    appState.addGeoPoint();
                    setState(() {
                      appState.icon1 = Icons.check_circle;
                    });
                  }    
                  
              } 
              break; 
              
              case 1: { 
                appState.newtext = '';
                appState.removeAllMarker();
                appState.deleteData();
                //appState.updateVisibilityData();
                //appState.deleteLocalData();
                setState(() {
                      appState.icon1 = Icons.pin_drop;
                    });
              } 
              break; 
              
              case 2: {
                appState.newtext = '';
                  appState.handleTap();
              }
              break;
              default: { 
                  
              }
              break; 
            } 
        },
      ),

    
      ),
      
    );

  }

  @override
  @mustCallSuper
  dispose() {

    super.dispose();
  }
}


