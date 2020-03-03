import 'package:flutter/material.dart';
import 'package:car_locator_2/quick_actions_manager.dart';
import 'package:provider/provider.dart';
import 'package:car_locator_2/appstate/app_state.dart';
import 'screens/home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';



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


class MyApp extends State<MainPage>{



 @override
  void initState() {
    super.initState();
   
  }

  IconData iconlocal;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
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

        MyHomePage(title: 'car locator'),
  
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
                  appState.icon1 = Icons.check_circle;
                  if(appState.markers.length == 0){
                    appState.addGeoPoint();
                  
                    setState(() {
                      appState.icon1 = Icons.check_circle;
                    });
                  }    
                  
              } 
              break; 
              
              case 1: { 
                appState.removeAllMarker();
                appState.deleteData();
                appState.deleteLocalData();
                setState(() {
                      appState.icon1 = Icons.pin_drop;
                    });
              } 
              break; 
              
              case 2: {
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


